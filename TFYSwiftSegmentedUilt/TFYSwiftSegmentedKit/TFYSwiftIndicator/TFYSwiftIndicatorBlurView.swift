//
//  TFYSwiftIndicatorBlurView.swift
//  TFYSwiftSegmentedKit
//
//  毛玻璃（UIVisualEffectView）背景指示器，适合浅色/深色主题自适应的场景。
//

import UIKit

open class TFYSwiftIndicatorBlurView: TFYSwiftIndicatorBaseView {

    /// 模糊样式；默认 `.systemMaterial`，跟随深色模式自动切换。
    open var blurStyle: UIBlurEffect.Style = .systemMaterial {
        didSet {
            guard oldValue != blurStyle else { return }
            blurView.effect = UIBlurEffect(style: blurStyle)
        }
    }

    /// 额外的着色层（可选），会叠加在 blur 之上。
    open var tintColor2: UIColor? = nil {
        didSet { tintView.backgroundColor = tintColor2 }
    }

    private let blurView: UIVisualEffectView
    private let tintView: UIView = UIView()

    public override init(frame: CGRect) {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        super.init(coder: aDecoder)
    }

    open override func commonInit() {
        super.commonInit()
        indicatorWidthIncrement = 12
        indicatorHeight = 30
        indicatorPosition = .center
        backgroundColor = .clear

        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.clipsToBounds = true
        addSubview(blurView)

        tintView.frame = bounds
        tintView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tintView.backgroundColor = nil
        blurView.contentView.addSubview(tintView)
    }

    private func applyCorner(for radius: CGFloat) {
        blurView.layer.cornerRadius = radius
        blurView.layer.cornerCurve = .continuous
        layer.cornerRadius = radius
    }

    open override func refreshIndicatorState(model: TFYSwiftIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)

        let width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        let height = getIndicatorHeight(itemFrame: model.currentSelectedItemFrame)
        let x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - width)/2
        var y: CGFloat = 0
        switch indicatorPosition {
        case .top:    y = verticalOffset
        case .bottom: y = model.currentSelectedItemFrame.size.height - height - verticalOffset
        case .center: y = (model.currentSelectedItemFrame.size.height - height)/2 + verticalOffset
        }
        applyCorner(for: indicatorCornerRadius == TFYSwiftViewAutomaticDimension ? height/2 : indicatorCornerRadius)
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    open override func contentScrollViewDidScroll(model: TFYSwiftIndicatorTransitionParams) {
        super.contentScrollViewDidScroll(model: model)
        guard canHandleTransition(model: model) else { return }

        let leftFrame = model.leftItemFrame
        let rightFrame = model.rightItemFrame
        let percent = CGFloat(model.percent)
        var targetWidth = getIndicatorWidth(itemFrame: leftFrame, itemContentWidth: model.leftItemContentWidth)
        let leftWidth = targetWidth
        let rightWidth = getIndicatorWidth(itemFrame: rightFrame, itemContentWidth: model.rightItemContentWidth)
        let leftX = leftFrame.origin.x + (leftFrame.size.width - leftWidth)/2
        let rightX = rightFrame.origin.x + (rightFrame.size.width - rightWidth)/2
        let targetX = TFYSwiftViewTool.interpolate(from: leftX, to: rightX, percent: percent)
        if indicatorWidth == TFYSwiftViewAutomaticDimension {
            targetWidth = TFYSwiftViewTool.interpolate(from: leftWidth, to: rightWidth, percent: percent)
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
