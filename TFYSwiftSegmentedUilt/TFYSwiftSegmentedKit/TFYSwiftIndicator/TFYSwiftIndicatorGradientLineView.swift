//
//  TFYSwiftIndicatorGradientLineView.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

/// 会无视indicatorColor属性，以gradientColors为准
open class TFYSwiftIndicatorGradientLineView: TFYSwiftIndicatorLineView {
    open var colors = [UIColor]()
    open var startPoint = CGPoint.zero
    open var endPoint = CGPoint(x: 1, y: 0)
    open var locations: [NSNumber]?
    public let gradientLayer = CAGradientLayer()

    open override func commonInit() {
        super.commonInit()

        layer.masksToBounds = true
        layer.addSublayer(gradientLayer)
    }

    open override func refreshIndicatorState(model: TFYSwiftIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)

        backgroundColor = .clear
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = locations
        CATransaction.commit()
    }

    open override func contentScrollViewDidScroll(model: TFYSwiftIndicatorTransitionParams) {
        super.contentScrollViewDidScroll(model: model)

        guard canHandleTransition(model: model) else {
            return
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = bounds
        CATransaction.commit()
    }

    open override func selectItem(model: TFYSwiftIndicatorSelectedParams) {
        super.selectItem(model: model)

        let targetWidth = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        CATransaction.begin()
        CATransaction.setAnimationDuration(scrollAnimationDuration)
        CATransaction.setAnimationTimingFunction(.init(name: .easeOut))
        gradientLayer.frame.size.width = targetWidth
        CATransaction.commit()
    }

}

