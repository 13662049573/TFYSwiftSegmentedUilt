//
//  TFYSwiftBadgeConfiguration.swift
//  TFYSwiftSegmentedKit
//
//  统一的徽章 (Badge) 配置对象；任何 Title 系列 cell 都可以借助
//  `applyBadge(_:)` 在右上角叠加一个红点、数字或自定义视图。
//

import UIKit

public enum TFYSwiftBadgeStyle: Sendable {
    /// 红点：无文字，尺寸固定。
    case dot
    /// 数字徽章：显示一个计数（0 会被隐藏，可以通过 config 关闭）。
    case number(Int)
    /// 纯文本徽章：任意 String（NEW、HOT 等）。
    case text(String)
}

public struct TFYSwiftBadgeConfiguration: Sendable {
    public var style: TFYSwiftBadgeStyle
    /// 背景色。
    public var backgroundColor: UIColor
    /// 文字色。
    public var textColor: UIColor
    /// 字体。
    public var font: UIFont
    /// 相对 cell 右上角的偏移（x 向右为正，y 向下为正）。
    public var offset: CGPoint
    /// 内边距。
    public var insets: UIEdgeInsets
    /// 是否在 `number` 风格下，数字为 0 时隐藏。
    public var hidesWhenZero: Bool

    public init(style: TFYSwiftBadgeStyle,
                backgroundColor: UIColor = .systemRed,
                textColor: UIColor = .white,
                font: UIFont = .systemFont(ofSize: 10, weight: .semibold),
                offset: CGPoint = CGPoint(x: -4, y: 4),
                insets: UIEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4),
                hidesWhenZero: Bool = true) {
        self.style = style
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.font = font
        self.offset = offset
        self.insets = insets
        self.hidesWhenZero = hidesWhenZero
    }
}

/// 内部使用的徽章 view；Title 系列 cell 可通过扩展 `applyBadge(_:)` 安装。
@MainActor
public final class TFYSwiftBadgeView: UIView {
    public let label = UILabel()
    public private(set) var configuration: TFYSwiftBadgeConfiguration?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        isUserInteractionEnabled = false
        addSubview(label)
        label.textAlignment = .center
    }

    public required init?(coder: NSCoder) { fatalError() }

    public func apply(_ config: TFYSwiftBadgeConfiguration) {
        configuration = config
        backgroundColor = config.backgroundColor
        label.textColor = config.textColor
        label.font = config.font

        switch config.style {
        case .dot:
            label.text = ""
            isHidden = false
        case .number(let n):
            if n == 0 && config.hidesWhenZero {
                isHidden = true
            } else {
                isHidden = false
                label.text = n > 99 ? "99+" : String(n)
            }
        case .text(let s):
            isHidden = s.isEmpty
            label.text = s
        }
        setNeedsLayout()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds.inset(by: configuration?.insets ?? .zero)
        // 圆角：dot 全圆；其他为胶囊。
        layer.cornerRadius = bounds.height / 2
    }

    public func intrinsicSize() -> CGSize {
        guard let config = configuration else { return .zero }
        switch config.style {
        case .dot:
            return CGSize(width: 8, height: 8)
        case .number, .text:
            label.sizeToFit()
            let w = ceil(label.frame.width) + config.insets.left + config.insets.right
            let h = ceil(label.frame.height) + config.insets.top + config.insets.bottom
            return CGSize(width: max(w, h), height: h) // 保证至少是圆形
        }
    }
}

public extension UIView {
    private static var tfy_badgeKey: UInt8 = 0

    /// 在 view 的右上角安装/更新一个徽章。调用 `applyBadge(nil)` 可卸载。
    /// 要求 view 有确定 frame。
    func tfy_applyBadge(_ config: TFYSwiftBadgeConfiguration?) {
        let existing = objc_getAssociatedObject(self, &UIView.tfy_badgeKey) as? TFYSwiftBadgeView
        guard let config else {
            existing?.removeFromSuperview()
            objc_setAssociatedObject(self, &UIView.tfy_badgeKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return
        }
        let badge = existing ?? TFYSwiftBadgeView(frame: .zero)
        if existing == nil {
            addSubview(badge)
            objc_setAssociatedObject(self, &UIView.tfy_badgeKey, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        badge.apply(config)
        let size = badge.intrinsicSize()
        badge.frame = CGRect(x: bounds.width - size.width + config.offset.x,
                             y: config.offset.y,
                             width: size.width,
                             height: size.height)
    }
}
