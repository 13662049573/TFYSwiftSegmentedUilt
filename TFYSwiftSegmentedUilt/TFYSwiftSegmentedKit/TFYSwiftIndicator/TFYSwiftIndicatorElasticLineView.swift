//
//  TFYSwiftIndicatorElasticLineView.swift
//  TFYSwiftSegmentedKit
//
//  橡皮筋（Elastic）线条指示器：跨项切换时指示线会先拉伸再回弹，
//  参考 Material 3 的 TabIndicatorAnimator 风格。
//

import UIKit

open class TFYSwiftIndicatorElasticLineView: TFYSwiftIndicatorBaseView {

    /// 拉伸动画超调量（占 item 宽度的比例）。数值越大拉伸感越强，默认 0.3。
    open var stretchFactor: CGFloat = 0.3

    open override func commonInit() {
        super.commonInit()
        indicatorHeight = 3
        indicatorPosition = .bottom
        indicatorColor = .red
        verticalOffset = 0
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
        case .top:    y = verticalOffset
        case .bottom: y = model.currentSelectedItemFrame.size.height - height - verticalOffset
        case .center: y = (model.currentSelectedItemFrame.size.height - height)/2 + verticalOffset
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    /// 关键：拉伸/回弹逻辑。percent < 0.5 时 width 随距离拉伸；percent > 0.5 时 width 回弹。
    open override func contentScrollViewDidScroll(model: TFYSwiftIndicatorTransitionParams) {
        super.contentScrollViewDidScroll(model: model)
        guard canHandleTransition(model: model) else { return }

        let leftFrame = model.leftItemFrame
        let rightFrame = model.rightItemFrame
        let percent = CGFloat(model.percent)

        let leftWidth = getIndicatorWidth(itemFrame: leftFrame, itemContentWidth: model.leftItemContentWidth)
        let rightWidth = getIndicatorWidth(itemFrame: rightFrame, itemContentWidth: model.rightItemContentWidth)
        let leftX = leftFrame.origin.x + (leftFrame.size.width - leftWidth)/2
        let rightX = rightFrame.origin.x + (rightFrame.size.width - rightWidth)/2

        // 拉伸比例：0 - 1 - 0 抛物线。
        let bulge = sin(percent * .pi) * stretchFactor

        let targetX: CGFloat
        let targetWidth: CGFloat
        if percent <= 0.5 {
            // 前半段：左端固定，右端朝 right 推进。
            let headX = leftX + (rightX + rightWidth - (leftX + leftWidth)) * percent * 2
            let head = min(headX, rightX + rightWidth)
            targetX = leftX
            targetWidth = head - leftX + leftWidth * bulge
        } else {
            // 后半段：右端固定，左端追上。
            let tailX = leftX + (rightX - leftX) * (percent * 2 - 1)
            targetX = tailX - rightWidth * bulge
            targetWidth = rightX + rightWidth - targetX
        }

        self.frame.origin.x = targetX
        self.frame.size.width = max(targetWidth, 1)
    }

    open override func selectItem(model: TFYSwiftIndicatorSelectedParams) {
        super.selectItem(model: model)

        let width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        var toFrame = self.frame
        toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - width)/2
        toFrame.size.width = width

        if canSelectedWithAnimation(model: model) {
            UIView.animate(withDuration: scrollAnimationDuration,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.5,
                           options: [.curveEaseOut]) {
                self.frame = toFrame
            }
        } else {
            frame = toFrame
        }
    }
}
