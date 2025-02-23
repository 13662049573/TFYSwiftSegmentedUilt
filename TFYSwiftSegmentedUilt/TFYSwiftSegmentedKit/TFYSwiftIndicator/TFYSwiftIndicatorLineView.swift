//
//  TFYSwiftIndicatorLineView.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

public enum TFYSwiftIndicatorLineStyle {
    case normal
    case lengthen
    case lengthenOffset
}

open class TFYSwiftIndicatorLineView: TFYSwiftIndicatorBaseView {
    open var lineStyle: TFYSwiftIndicatorLineStyle = .normal
    /// lineStyle为lengthenOffset时使用，滚动时x的偏移量
    open var lineScrollOffsetX: CGFloat = 10

    open override func commonInit() {
        super.commonInit()

        indicatorHeight = 3
    }

    open override func refreshIndicatorState(model: TFYSwiftIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)

        backgroundColor = indicatorColor
        layer.cornerRadius = getIndicatorCornerRadius(itemFrame: model.currentSelectedItemFrame)

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
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    open override func contentScrollViewDidScroll(model: TFYSwiftIndicatorTransitionParams) {
        super.contentScrollViewDidScroll(model: model)

        guard canHandleTransition(model: model) else {
            return
        }

        let rightItemFrame = model.rightItemFrame
        let leftItemFrame = model.leftItemFrame
        let percent = model.percent
        var targetX: CGFloat = leftItemFrame.origin.x
        var targetWidth = getIndicatorWidth(itemFrame: leftItemFrame, itemContentWidth: model.leftItemContentWidth)

        let leftWidth = targetWidth
        let rightWidth = getIndicatorWidth(itemFrame: rightItemFrame, itemContentWidth: model.rightItemContentWidth)
        let leftX = leftItemFrame.origin.x + (leftItemFrame.size.width - leftWidth)/2
        let rightX = rightItemFrame.origin.x + (rightItemFrame.size.width - rightWidth)/2

        switch lineStyle {
        case .normal:
            targetX = TFYSwiftViewTool.interpolate(from: leftX, to: rightX, percent: CGFloat(percent))
            if indicatorWidth == TFYSwiftViewAutomaticDimension {
                targetWidth = TFYSwiftViewTool.interpolate(from: leftWidth, to: rightWidth, percent: CGFloat(percent))
            }
        case .lengthen:
            //前50%，只增加width；后50%，移动x并减小width
            let maxWidth = rightX - leftX + rightWidth
            if percent <= 0.5 {
                targetX = leftX
                targetWidth = TFYSwiftViewTool.interpolate(from: leftWidth, to: maxWidth, percent: CGFloat(percent*2))
            }else {
                targetX = TFYSwiftViewTool.interpolate(from: leftX, to: rightX, percent: CGFloat((percent - 0.5)*2))
                targetWidth = TFYSwiftViewTool.interpolate(from: maxWidth, to: rightWidth, percent: CGFloat((percent - 0.5)*2))
            }
        case .lengthenOffset:
            //前50%，增加width，并少量移动x；后50%，少量移动x并减小width
            let maxWidth = rightX - leftX + rightWidth - lineScrollOffsetX*2
            if percent <= 0.5 {
                targetX = TFYSwiftViewTool.interpolate(from: leftX, to: leftX + lineScrollOffsetX, percent: CGFloat(percent*2))
                targetWidth = TFYSwiftViewTool.interpolate(from: leftWidth, to: maxWidth, percent: CGFloat(percent*2))
            }else {
                targetX = TFYSwiftViewTool.interpolate(from:leftX + lineScrollOffsetX, to: rightX, percent: CGFloat((percent - 0.5)*2))
                targetWidth = TFYSwiftViewTool.interpolate(from: maxWidth, to: rightWidth, percent: CGFloat((percent - 0.5)*2))
            }
        }

        self.frame.origin.x = targetX
        self.frame.size.width = targetWidth
    }

    open override func selectItem(model: TFYSwiftIndicatorSelectedParams) {
        super.selectItem(model: model)

        let targetWidth = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        var toFrame = self.frame
        toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - targetWidth)/2
        toFrame.size.width = targetWidth
        if canSelectedWithAnimation(model: model) {
            UIView.animate(withDuration: scrollAnimationDuration, delay: 0, options: .curveEaseOut, animations: {
                self.frame = toFrame
            }) { (_) in
            }
        }else {
            frame = toFrame
        }
    }

}

