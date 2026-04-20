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
public final class TFYSwiftTextMeasure {

    /// 进程级共享实例；一般情况下业务无需再实例化。
    public static let shared = TFYSwiftTextMeasure()

    /// 最多缓存的独立条目数量。默认 512，足以覆盖主流分段控件规模。
    public var countLimit: Int {
        get { cache.countLimit }
        set { cache.countLimit = newValue }
    }

    private let cache: NSCache<NSString, NSNumber> = {
        let c = NSCache<NSString, NSNumber>()
        c.countLimit = 512
        return c
    }()

    public init() {}

    /// 返回以指定 `font` 渲染 `title` 所需的最小向上取整宽度。
    /// - Parameters:
    ///   - title: 文本
    ///   - font: 字体
    ///   - numberOfLines: 行数（影响布局选项；默认 1）
    public func width(for title: String, font: UIFont, numberOfLines: Int = 1) -> CGFloat {
        if title.isEmpty { return 0 }
        let key = makeKey(title: title, font: font, numberOfLines: numberOfLines)
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
        return rounded
    }

    /// 清空全部缓存（例如字体资源切换、语言切换、Dynamic Type 变化后调用）。
    public func invalidate() {
        cache.removeAllObjects()
    }

    private func makeKey(title: String, font: UIFont, numberOfLines: Int) -> NSString {
        // 使用字体名 + pointSize 而非 UIFont 指针，保证同样配置命中同一条目。
        return "\(title)|\(font.fontName)|\(font.pointSize)|\(numberOfLines)" as NSString
    }
}
