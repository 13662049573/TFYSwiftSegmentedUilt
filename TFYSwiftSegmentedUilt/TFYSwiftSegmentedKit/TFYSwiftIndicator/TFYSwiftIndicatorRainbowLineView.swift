//
//  TFYSwiftIndicatorRainbowLineView.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit


/// 会无视indicatorColor属性，以indicatorColors为准
open class TFYSwiftIndicatorRainbowLineView: TFYSwiftIndicatorLineView {
    /// 数量需要与item的数量相等。默认空数组，必须要赋值该属性。segmentedView在reloadData的时候，也要一并更新该属性，不然会出现数组越界。
    open var indicatorColors = [UIColor]()

    private func indicatorColor(at index: Int) -> UIColor? {
        indicatorColors[safe: index]
    }

    open override func refreshIndicatorState(model: TFYSwiftIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)

        backgroundColor = indicatorColor(at: model.currentSelectedIndex)
    }

    open override func contentScrollViewDidScroll(model: TFYSwiftIndicatorTransitionParams) {
        super.contentScrollViewDidScroll(model: model)

        guard canHandleTransition(model: model) else {
            return
        }

        guard
            let leftColor = indicatorColor(at: model.leftIndex),
            let rightColor = indicatorColor(at: model.rightIndex)
        else {
            return
        }

        backgroundColor = TFYSwiftViewTool.interpolateColor(from: leftColor, to: rightColor, percent: model.percent)
    }

    open override func selectItem(model: TFYSwiftIndicatorSelectedParams) {
        super.selectItem(model: model)

        backgroundColor = indicatorColor(at: model.currentSelectedIndex)
    }

}
