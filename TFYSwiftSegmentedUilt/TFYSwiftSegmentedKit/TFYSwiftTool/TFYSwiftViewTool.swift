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

public class TFYSwiftViewTool {
    public static func interpolate<T: SignedNumeric & Comparable>(from: T, to:  T, percent:  T) ->  T {
        let percent = max(0, min(1, percent))
        return from + (to - from) * percent
    }

    public static func interpolateColor(from: UIColor, to: UIColor, percent: CGFloat) -> UIColor {
        let r = interpolate(from: from.ge_red, to: to.ge_red, percent: percent)
        let g = interpolate(from: from.ge_green, to: to.ge_green, percent: CGFloat(percent))
        let b = interpolate(from: from.ge_blue, to: to.ge_blue, percent: CGFloat(percent))
        let a = interpolate(from: from.ge_alpha, to: to.ge_alpha, percent: CGFloat(percent))
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    public static func interpolateColors(from: [CGColor], to: [CGColor], percent: CGFloat) -> [CGColor] {
        guard from.count == to.count else {
            return from
        }
        var resultColors = [CGColor]()
        for index in 0..<from.count {
            let fromColor = UIColor(cgColor: from[index])
            let toColor = UIColor(cgColor: to[index])
            let r = interpolate(from: fromColor.ge_red, to: toColor.ge_red, percent: percent)
            let g = interpolate(from: fromColor.ge_green, to: toColor.ge_green, percent: CGFloat(percent))
            let b = interpolate(from: fromColor.ge_blue, to: toColor.ge_blue, percent: CGFloat(percent))
            let a = interpolate(from: fromColor.ge_alpha, to: toColor.ge_alpha, percent: CGFloat(percent))
            resultColors.append(UIColor(red: r, green: g, blue: b, alpha: a).cgColor)
        }
        return resultColors
    }
}

extension TFYSwiftViewTool {
    public static func interpolateThemeColor(from: UIColor, to: UIColor, percent: CGFloat) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection) -> UIColor in
                let resolvedFrom = from.resolvedColor(with: traitCollection)
                let resolvedTo = to.resolvedColor(with: traitCollection)
                return interpolateColor(from: resolvedFrom, to: resolvedTo, percent: percent)
            }
        } else {
            return interpolateColor(from: from, to: to, percent: percent)
        }
    }
}
