//
//  TFYSwiftIndicatorImageView.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

open class TFYSwiftIndicatorImageView: TFYSwiftIndicatorBaseView {
    open var image: UIImage? {
        didSet {
            layer.contents = image?.cgImage
        }
    }

    open override func commonInit() {
        super.commonInit()

        indicatorWidth = 20
        indicatorHeight = 20
        layer.contentsGravity = .resizeAspect
    }

    open override func refreshIndicatorState(model: TFYSwiftIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)

        backgroundColor = nil

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
        let targetWidth = getIndicatorWidth(itemFrame: model.leftItemFrame, itemContentWidth: model.leftItemContentWidth)

        let leftX = leftItemFrame.origin.x + (leftItemFrame.size.width - targetWidth)/2
        let rightX = rightItemFrame.origin.x + (rightItemFrame.size.width - targetWidth)/2
        let targetX = TFYSwiftViewTool.interpolate(from: leftX, to: rightX, percent: CGFloat(percent))
        
        self.frame.origin.x = targetX
    }

    open override func selectItem(model: TFYSwiftIndicatorSelectedParams) {
        super.selectItem(model: model)

        let targetWidth = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        var toFrame = self.frame
        toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - targetWidth)/2
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

