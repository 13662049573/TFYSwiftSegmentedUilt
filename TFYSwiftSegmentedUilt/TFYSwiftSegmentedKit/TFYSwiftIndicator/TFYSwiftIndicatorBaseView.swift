//
//  TFYSwiftIndicatorBaseView.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

public enum TFYSwiftIndicatorPosition {
    case top
    case bottom
    case center
}

open class TFYSwiftIndicatorBaseView: UIView, TFYSwiftIndicatorProtocol {
    /// 默认TFYSwiftViewAutomaticDimension（与cell的宽度相等）。内部通过getIndicatorWidth方法获取实际的值
    open var indicatorWidth: CGFloat = TFYSwiftViewAutomaticDimension
    open var indicatorWidthIncrement: CGFloat = 0   //指示器的宽度增量。比如需求是指示器宽度比cell宽度多10 point。就可以将该属性赋值为10。最终指示器的宽度=indicatorWidth+indicatorWidthIncrement
    /// 默认TFYSwiftViewAutomaticDimension（与cell的高度相等）。内部通过getIndicatorHeight方法获取实际的值
    open var indicatorHeight: CGFloat = TFYSwiftViewAutomaticDimension
    /// 默认TFYSwiftViewAutomaticDimension （等于indicatorHeight/2）。内部通过getIndicatorCornerRadius方法获取实际的值
    open var indicatorCornerRadius: CGFloat = TFYSwiftViewAutomaticDimension
    /// 指示器的颜色
    open var indicatorColor: UIColor = .red
    /// 指示器的位置，top、bottom、center
    open var indicatorPosition: TFYSwiftIndicatorPosition = .bottom
    /// 垂直方向偏移，指示器默认贴着底部或者顶部，verticalOffset越大越靠近中心。
    open var verticalOffset: CGFloat = 0
    /// 手势滚动、点击切换的时候，是否允许滚动。
    open var isScrollEnabled: Bool = true
    /// 是否需要将当前的indicator的frame转换到cell。辅助TFYSwiftTitleDataSourced的isTitleMaskEnabled属性使用。
    /// 如果添加了多个indicator，仅能有一个indicator的isIndicatorConvertToItemFrameEnabled为true。
    /// 如果有多个indicator的isIndicatorConvertToItemFrameEnabled为true，则以最后一个isIndicatorConvertToItemFrameEnabled为true的indicator为准。
    open var isIndicatorConvertToItemFrameEnabled: Bool = true
    /// 点击选中时的滚动动画时长
    open var scrollAnimationDuration: TimeInterval = 0.25
    ///  指示器的宽度是否跟随item的内容变化（而不是跟着cell的宽度变化）。indicatorWidth=TFYSwiftViewAutomaticDimension才能生效
    open var isIndicatorWidthSameAsItemContent = false

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    open func commonInit() {
    }

    public func getIndicatorCornerRadius(itemFrame: CGRect) -> CGFloat {
        if indicatorCornerRadius == TFYSwiftViewAutomaticDimension {
            return getIndicatorHeight(itemFrame: itemFrame)/2
        }
        return indicatorCornerRadius
    }

    public func getIndicatorWidth(itemFrame: CGRect, itemContentWidth: CGFloat) -> CGFloat {
        if indicatorWidth == TFYSwiftViewAutomaticDimension {
            if isIndicatorWidthSameAsItemContent {
                return itemContentWidth + indicatorWidthIncrement
            }else {
                return itemFrame.size.width + indicatorWidthIncrement
            }
        }
        return indicatorWidth + indicatorWidthIncrement
    }

    public func getIndicatorHeight(itemFrame: CGRect) -> CGFloat {
        if indicatorHeight == TFYSwiftViewAutomaticDimension {
            return itemFrame.size.height
        }
        return indicatorHeight
    }

    public func canHandleTransition(model: TFYSwiftIndicatorTransitionParams) -> Bool {
        if model.percent == 0 || !isScrollEnabled {
            //model.percent等于0时不需要处理，会调用selectItem(model: TFYSwiftIndicatorParamsModel)方法处理
            //isScrollEnabled为false不需要处理
            return false
        }
        return true
    }

    public func canSelectedWithAnimation(model: TFYSwiftIndicatorSelectedParams) -> Bool {
        if isScrollEnabled && (model.selectedType == .click || model.selectedType == .code) {
            //允许滚动且选中类型是点击或代码选中，才进行动画过渡
            return true
        }
        return false
    }

    //MARK: - TFYSwiftIndicatorProtocol
    open func refreshIndicatorState(model: TFYSwiftIndicatorSelectedParams) {
    }

    open func contentScrollViewDidScroll(model: TFYSwiftIndicatorTransitionParams) {
    }

    open func selectItem(model: TFYSwiftIndicatorSelectedParams) {
    }
}

