//
//  TFYSwiftIndicatorSymbolView.swift
//  TFYSwiftSegmentedKit
//
//  SF Symbols 选中态图标指示器：在当前选中 cell 顶部（或 cell 中）叠加一个 symbol 图标。
//  典型用途：iPad/Tab bar 风格、快应用导航。
//

import UIKit

open class TFYSwiftIndicatorSymbolView: TFYSwiftIndicatorBaseView {

    /// 选中态展示的 SF Symbol 名；空字符串表示不展示。
    open var symbolName: String = "" {
        didSet { reloadImage() }
    }

    /// symbol 配色。
    open var symbolTintColor: UIColor = .systemBlue {
        didSet { imageView.tintColor = symbolTintColor }
    }

    /// symbol 字体大小。
    open var symbolPointSize: CGFloat = 14 {
        didSet { reloadImage() }
    }

    /// symbol 权重。
    open var symbolWeight: UIImage.SymbolWeight = .semibold {
        didSet { reloadImage() }
    }

    private let imageView = UIImageView()

    open override func commonInit() {
        super.commonInit()
        indicatorWidthIncrement = 0
        indicatorHeight = 18
        indicatorPosition = .top
        indicatorColor = .clear
        backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = symbolTintColor
        addSubview(imageView)
    }

    private func reloadImage() {
        guard !symbolName.isEmpty else {
            imageView.image = nil
            return
        }
        let config = UIImage.SymbolConfiguration(pointSize: symbolPointSize, weight: symbolWeight)
        imageView.image = UIImage(systemName: symbolName, withConfiguration: config)
    }

    open override func refreshIndicatorState(model: TFYSwiftIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)
        if imageView.image == nil { reloadImage() }
        // symbol 指示器的宽度固定跟随 symbol 本身，不参与 itemWidthIncrement 逻辑。
        let size = imageView.image?.size ?? CGSize(width: indicatorHeight, height: indicatorHeight)
        let itemFrame = model.currentSelectedItemFrame
        let x = itemFrame.origin.x + (itemFrame.size.width - size.width)/2
        var y: CGFloat = 0
        switch indicatorPosition {
        case .top:    y = verticalOffset
        case .bottom: y = itemFrame.size.height - size.height - verticalOffset
        case .center: y = (itemFrame.size.height - size.height)/2 + verticalOffset
        }
        frame = CGRect(x: x, y: y, width: size.width, height: size.height)
        imageView.frame = bounds
    }

    open override func contentScrollViewDidScroll(model: TFYSwiftIndicatorTransitionParams) {
        super.contentScrollViewDidScroll(model: model)
        guard canHandleTransition(model: model) else { return }

        let leftFrame = model.leftItemFrame
        let rightFrame = model.rightItemFrame
        let percent = CGFloat(model.percent)
        let size = frame.size
        let leftX = leftFrame.origin.x + (leftFrame.size.width - size.width)/2
        let rightX = rightFrame.origin.x + (rightFrame.size.width - size.width)/2
        self.frame.origin.x = TFYSwiftViewTool.interpolate(from: leftX, to: rightX, percent: percent)
        // 过渡阶段做一个轻微的 opacity 抖动，强化切换反馈。
        self.alpha = 1.0 - abs(percent - 0.5) * 0.6
    }

    open override func selectItem(model: TFYSwiftIndicatorSelectedParams) {
        super.selectItem(model: model)
        let size = frame.size
        let itemFrame = model.currentSelectedItemFrame
        var toFrame = self.frame
        toFrame.origin.x = itemFrame.origin.x + (itemFrame.size.width - size.width)/2
        if canSelectedWithAnimation(model: model) {
            UIView.animate(withDuration: scrollAnimationDuration,
                           delay: 0,
                           options: [.curveEaseOut]) {
                self.frame = toFrame
                self.alpha = 1
            }
        } else {
            self.frame = toFrame
            self.alpha = 1
        }
    }
}
