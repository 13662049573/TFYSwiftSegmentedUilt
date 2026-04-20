//
//  TFYSwiftTextMeasure.swift
//  TFYSwiftSegmentedKit
//
//  Provides an NSCache-backed text width measurement helper used across the
//  title-oriented data sources. Repeated reloadData / scrolling events typically
//  ask for the same (title, font, numberOfLines) width many times per second;
//  caching the boundingRect result keeps the main thread idle.
//

import Foundation
import UIKit

/// 线程安全的文本宽度缓存（以 (title, font, numberOfLines) 作为 key）。
/// 内部使用 `NSCache`，系统内存紧张时会自动清理；也提供 `invalidate()` 供外部手动清空。
///
/// 并发安全性保证：
/// 1. `NSCache` 自身是线程安全的（Apple 文档；内部用锁保护 objectForKey/setObject）。
/// 2. `countLimit` 的 setter 写入也是 atomic。
/// 3. `boundingRect` 在不同线程上调用 UIKit text layout 被 Apple 明确支持（TextKit1 在 iOS 7 后对 attributed string 的只读测量线程安全）。
/// 4. `liveKeysLock` 保护 `liveKeys` 这个集合，使部分失效也是线程安全的。
/// 因此此类对外以 `@unchecked Sendable` 暴露给 Swift 6 并发检查。
public final class TFYSwiftTextMeasure: @unchecked Sendable {

    /// 进程级共享实例；一般情况下业务无需再实例化。
    public static let shared = TFYSwiftTextMeasure()

    /// 最多缓存的独立条目数量。默认 512，足以覆盖主流分段控件规模。
    public var countLimit: Int {
        get { cache.countLimit }
        set { cache.countLimit = newValue }
    }

    /// 匹配缓存条目的查询字段，用于 `invalidate(matching:)` 精细清理。
    public struct MatchCriteria: Sendable {
        public var title: String?
        public var fontName: String?
        public var numberOfLines: Int?

        public init(title: String? = nil, fontName: String? = nil, numberOfLines: Int? = nil) {
            self.title = title
            self.fontName = fontName
            self.numberOfLines = numberOfLines
        }
    }

    private let cache: NSCache<NSString, NSNumber> = {
        let c = NSCache<NSString, NSNumber>()
        c.countLimit = 512
        return c
    }()

    private let liveKeysLock = NSLock()
    /// 记录当前 cache 中曾经存在过的所有 key，便于 partial invalidation。
    /// NSCache 会自动驱逐条目，因此该集合是「上界」而非精确集合；但这对 invalidation 是安全的。
    private var liveKeys: Set<String> = []

    public init() {
        #if canImport(UIKit)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tfy_handleMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
        #endif
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// 返回以指定 `font` 渲染 `title` 所需的最小向上取整宽度。
    /// - Parameters:
    ///   - title: 文本
    ///   - font: 字体
    ///   - numberOfLines: 行数（影响布局选项；默认 1）
    public func width(for title: String, font: UIFont, numberOfLines: Int = 1) -> CGFloat {
        if title.isEmpty { return 0 }
        let keyString = makeKeyString(title: title, font: font, numberOfLines: numberOfLines)
        let key = keyString as NSString
        if let cached = cache.object(forKey: key) {
            return CGFloat(cached.doubleValue)
        }
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        let measured = (title as NSString).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
            options: options,
            attributes: [.font: font],
            context: nil
        ).size.width
        let rounded = CGFloat(ceil(measured))
        cache.setObject(NSNumber(value: Double(rounded)), forKey: key)
        liveKeysLock.lock()
        liveKeys.insert(keyString)
        liveKeysLock.unlock()
        return rounded
    }

    /// 清空全部缓存（例如字体资源切换、语言切换、Dynamic Type 变化后调用）。
    public func invalidate() {
        cache.removeAllObjects()
        liveKeysLock.lock()
        liveKeys.removeAll()
        liveKeysLock.unlock()
    }

    /// 部分失效：按条件精细清除匹配的缓存项。未指定的字段不参与过滤。
    public func invalidate(matching criteria: MatchCriteria) {
        let snapshot: [String]
        liveKeysLock.lock()
        snapshot = Array(liveKeys)
        liveKeysLock.unlock()

        var removed = Set<String>()
        for keyString in snapshot {
            let parts = keyString.split(separator: "|", omittingEmptySubsequences: false)
            guard parts.count == 4 else { continue }
            let (title, fontName, _, linesStr) = (String(parts[0]), String(parts[1]), String(parts[2]), String(parts[3]))
            if let t = criteria.title, t != title { continue }
            if let fn = criteria.fontName, fn != fontName { continue }
            if let n = criteria.numberOfLines, String(n) != linesStr { continue }
            cache.removeObject(forKey: keyString as NSString)
            removed.insert(keyString)
        }
        if !removed.isEmpty {
            liveKeysLock.lock()
            liveKeys.subtract(removed)
            liveKeysLock.unlock()
        }
    }

    @objc private func tfy_handleMemoryWarning() {
        invalidate()
    }

    private func makeKeyString(title: String, font: UIFont, numberOfLines: Int) -> String {
        // 使用字体名 + pointSize 而非 UIFont 指针，保证同样配置命中同一条目。
        return "\(title)|\(font.fontName)|\(font.pointSize)|\(numberOfLines)"
    }
}
