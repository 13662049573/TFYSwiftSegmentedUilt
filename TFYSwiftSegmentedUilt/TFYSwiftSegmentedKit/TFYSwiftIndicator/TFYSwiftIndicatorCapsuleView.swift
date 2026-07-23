//
//  TFYSwiftIndicatorCapsuleView.swift
//  TFYSwiftSegmentedKit
//
//  胶囊背景指示器：与 Apple UISegmentedControl 原生胶囊风格一致。
//  默认圆角 = min(width, height)/2，支持描边和阴影。
//

import UIKit

open class TFYSwiftIndicatorCapsuleView: TFYSwiftIndicatorBaseView {

    /// 描边颜色；nil 表示不描边。
    open var borderColor: UIColor? = nil

    /// 描边宽度。
    open var borderWidth: CGFloat = 0

    /// 阴影颜色；nil 表示不阴影。
    open var shadowColor: UIColor? = nil

    /// 阴影偏移。
    open var shadowOffset: CGSize = .zero

    /// 阴影半径。
    open var shadowRadius: CGFloat = 0

    /// 阴影透明度。
    open var shadowOpacity: Float = 0

    open override func commonInit() {
        super.commonInit()
        indicatorWidthIncrement = 8
        indicatorHeight = 30
        indicatorColor = UIColor(white: 0.95, alpha: 1)
        indicatorPosition = .center
        verticalOffset = 0
    }

    private func applyDecoration(cornerRadius: CGFloat) {
        backgroundColor = indicatorColor
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = .continuous
        if let borderColor, borderWidth > 0 {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
        } else {
            layer.borderWidth = 0
        }
        if let shadowColor, shadowOpacity > 0 {
            layer.shadowColor = shadowColor.cgColor
            layer.shadowOffset = shadowOffset
            layer.shadowRadius = shadowRadius
            layer.shadowOpacity = shadowOpacity
        } else {
            layer.shadowOpacity = 0
        }
    }

    open override func refreshIndicatorState(model: TFYSwiftIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)

        let width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        let height = getIndicatorHeight(itemFrame: model.currentSelectedItemFrame)
        let x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - width)/2
        var y: CGFloat = 0
        switch indicatorPosition {
        case .top:
            y = verticalOffset
        case .bottom:
            y = model.currentSelectedItemFrame.size.height - height - verticalOffset
        case .center:
            y = (model.currentSelectedItemFrame.size.height - height)/2 + verticalOffset
        }
        applyDecoration(cornerRadius: indicatorCornerRadius == TFYSwiftViewAutomaticDimension ? height/2 : indicatorCornerRadius)
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    open override func contentScrollViewDidScroll(model: TFYSwiftIndicatorTransitionParams) {
        super.contentScrollViewDidScroll(model: model)
        guard canHandleTransition(model: model) else { return }

        let rightItemFrame = model.rightItemFrame
        let leftItemFrame = model.leftItemFrame
        let percent = model.percent
        var targetWidth = getIndicatorWidth(itemFrame: leftItemFrame, itemContentWidth: model.leftItemContentWidth)
        let leftWidth = targetWidth
        let rightWidth = getIndicatorWidth(itemFrame: rightItemFrame, itemContentWidth: model.rightItemContentWidth)
        let leftX = leftItemFrame.origin.x + (leftItemFrame.size.width - leftWidth)/2
        let rightX = rightItemFrame.origin.x + (rightItemFrame.size.width - rightWidth)/2
        let targetX = TFYSwiftViewTool.interpolate(from: leftX, to: rightX, percent: CGFloat(percent))
        if indicatorWidth == TFYSwiftViewAutomaticDimension {
            targetWidth = TFYSwiftViewTool.interpolate(from: leftWidth, to: rightWidth, percent: CGFloat(percent))
        }
        self.frame.origin.x = targetX
        self.frame.size.width = targetWidth
    }

    open override func selectItem(model: TFYSwiftIndicatorSelectedParams) {
        super.selectItem(model: model)
        let width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        var toFrame = self.frame
        toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - width)/2
        toFrame.size.width = width
        if canSelectedWithAnimation(model: model) {
            UIView.animate(withDuration: scrollAnimationDuration, delay: 0, options: [.curveEaseOut]) {
                self.frame = toFrame
            }
        } else {
            frame = toFrame
        }
    }
}
