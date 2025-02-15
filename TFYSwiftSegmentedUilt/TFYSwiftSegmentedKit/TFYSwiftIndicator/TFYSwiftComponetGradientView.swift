//
//  TFYSwiftComponetGradientView.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

open class TFYSwiftComponetGradientView: UIView {
    open class override var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    open var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
}

