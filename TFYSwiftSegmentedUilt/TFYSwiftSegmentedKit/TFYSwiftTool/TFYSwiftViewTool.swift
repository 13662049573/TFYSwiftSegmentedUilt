//
//  TFYSwiftViewTool.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import Foundation
import UIKit

public extension UIColor {
    var ge_red: CGFloat {
        var r: CGFloat = 0
        getRed(&r, green: nil, blue: nil, alpha: nil)
        return r
    }
    var ge_green: CGFloat {
        var g: CGFloat = 0
        getRed(nil, green: &g, blue: nil, alpha: nil)
        return g
    }
    var ge_blue: CGFloat {
        var b: CGFloat = 0
        getRed(nil, green: nil, blue: &b, alpha: nil)
        return b
    }
    var ge_alpha: CGFloat {
        return cgColor.alpha
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

