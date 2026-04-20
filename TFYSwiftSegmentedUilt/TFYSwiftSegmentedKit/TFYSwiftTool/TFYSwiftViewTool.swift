//
//  TFYSwiftViewTool.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import Foundation
import UIKit

public extension UIColor {
    private var tfy_rgbaComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red, green, blue, alpha)
        }

        guard
            let convertedColor = cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil),
            let components = convertedColor.components
        else {
            return (0, 0, 0, cgColor.alpha)
        }

        switch components.count {
        case 4:
            return (components[0], components[1], components[2], components[3])
        case 2:
            return (components[0], components[0], components[0], components[1])
        default:
            return (0, 0, 0, cgColor.alpha)
        }
    }

    var ge_red: CGFloat {
        tfy_rgbaComponents.red
    }
    var ge_green: CGFloat {
        tfy_rgbaComponents.green
    }
    var ge_blue: CGFloat {
        tfy_rgbaComponents.blue
    }
    var ge_alpha: CGFloat {
        tfy_rgbaComponents.alpha
    }
}

public extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

public typealias LoadImageClosure = ((UIImageView, String) -> Void)

public final class TFYSwiftViewTool {
    private init() {}

    /// 浮点数线性插值。percent 会被 clamp 到 [0, 1]。
    /// 约束为 `FloatingPoint` 以保证 clamp 与乘法在整数类型下不会丢失精度
    /// （旧实现使用 SignedNumeric & Comparable，若传入 Int 类型会退化为 step 函数）。
    @inlinable
    public static func interpolate<T: FloatingPoint>(from: T, to: T, percent: T) -> T {
        let p = Swift.max(T.zero, Swift.min(T(1), percent))
        return from + (to - from) * p
    }

    public static func interpolateColor(from: UIColor, to: UIColor, percent: CGFloat) -> UIColor {
        let p = max(0, min(1, percent))
        let r = interpolate(from: from.ge_red, to: to.ge_red, percent: p)
        let g = interpolate(from: from.ge_green, to: to.ge_green, percent: p)
        let b = interpolate(from: from.ge_blue, to: to.ge_blue, percent: p)
        let a = interpolate(from: from.ge_alpha, to: to.ge_alpha, percent: p)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    public static func interpolateColors(from: [CGColor], to: [CGColor], percent: CGFloat) -> [CGColor] {
        guard from.count == to.count else {
            return from
        }
        let p = max(0, min(1, percent))
        var resultColors = [CGColor]()
        resultColors.reserveCapacity(from.count)
        for index in 0..<from.count {
            let fromColor = UIColor(cgColor: from[index])
            let toColor = UIColor(cgColor: to[index])
            let r = interpolate(from: fromColor.ge_red, to: toColor.ge_red, percent: p)
            let g = interpolate(from: fromColor.ge_green, to: toColor.ge_green, percent: p)
            let b = interpolate(from: fromColor.ge_blue, to: toColor.ge_blue, percent: p)
            let a = interpolate(from: fromColor.ge_alpha, to: toColor.ge_alpha, percent: p)
            resultColors.append(UIColor(red: r, green: g, blue: b, alpha: a).cgColor)
        }
        return resultColors
    }

    /// 生成一个随 `UITraitCollection` 动态解析的插值颜色，适合深色模式下的实时切换。
    public static func interpolateThemeColor(from: UIColor, to: UIColor, percent: CGFloat) -> UIColor {
        UIColor { traitCollection in
            let resolvedFrom = from.resolvedColor(with: traitCollection)
            let resolvedTo = to.resolvedColor(with: traitCollection)
            return interpolateColor(from: resolvedFrom, to: resolvedTo, percent: percent)
        }
    }

    /// 计算两个颜色的 WCAG 2.1 对比度比例（1~21）。
    ///
    /// 实际 UI 文本可读性要求：
    /// - 正文： ≥ 4.5
    /// - 大号文字（18pt+）：≥ 3.0
    /// - UI 图形/图标：≥ 3.0
    ///
    /// 本方法在 Debug 构建下也会附带一个 console warning（调用 `warnIfContrastTooLow`）。
    public static func contrastRatio(_ lhs: UIColor, _ rhs: UIColor) -> CGFloat {
        func relativeLuminance(_ c: UIColor) -> CGFloat {
            func channel(_ x: CGFloat) -> CGFloat {
                let v = x < 0.03928 ? x / 12.92 : pow((x + 0.055) / 1.055, 2.4)
                return v
            }
            let r = channel(c.ge_red)
            let g = channel(c.ge_green)
            let b = channel(c.ge_blue)
            return 0.2126 * r + 0.7152 * g + 0.0722 * b
        }
        let l1 = relativeLuminance(lhs)
        let l2 = relativeLuminance(rhs)
        let (light, dark) = (Swift.max(l1, l2), Swift.min(l1, l2))
        return (light + 0.05) / (dark + 0.05)
    }

    /// Debug 辅助：当 `foreground/background` 对比度小于 `minimum` 时在 console 输出警告。
    /// - Parameter minimum: 默认 3.0（图形/大号文字阈值）。
    public static func warnIfContrastTooLow(foreground: UIColor,
                                            background: UIColor,
                                            minimum: CGFloat = 3.0,
                                            file: StaticString = #file,
                                            line: UInt = #line) {
        #if DEBUG
        let ratio = contrastRatio(foreground, background)
        if ratio < minimum {
            let msg = String(format: "⚠️ TFYSwiftSegmentedKit: contrast %.2f < %.2f at %@:%d",
                             Double(ratio), Double(minimum), "\(file)", line)
            print(msg)
        }
        #endif
    }
}
