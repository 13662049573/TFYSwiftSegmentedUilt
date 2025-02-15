//
//  TFYSwiftDotDataSource.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

open class TFYSwiftDotDataSource: TFYSwiftTitleDataSource {
    /// 数量需要和titles一致，控制红点是否显示
    open var dotStates = [Bool]()
    /// 红点的size
    open var dotSize = CGSize(width: 10, height: 10)
    /// 红点的圆角值，TFYSwiftViewAutomaticDimension等于dotSize.height/2
    open var dotCornerRadius: CGFloat = TFYSwiftViewAutomaticDimension
    /// 红点的颜色
    open var dotColor = UIColor.red
    /// dotView的默认位置是center在titleLabel的右上角，可以通过dotOffset控制X、Y轴的偏移
    open var dotOffset: CGPoint = CGPoint.zero

    open override func preferredItemModelInstance() -> TFYSwiftBaseItemModel {
        return TFYSwiftDotItemModel()
    }

    open override func preferredRefreshItemModel(_ itemModel: TFYSwiftBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let itemModel = itemModel as? TFYSwiftDotItemModel else {
            return
        }

        itemModel.dotOffset = dotOffset
        itemModel.dotState = dotStates[index]
        itemModel.dotColor = dotColor
        itemModel.dotSize = dotSize
        if dotCornerRadius == TFYSwiftViewAutomaticDimension {
            itemModel.dotCornerRadius = dotSize.height/2
        }else {
            itemModel.dotCornerRadius = dotCornerRadius
        }
    }

    //MARK: - TFYSwiftViewDataSource
    open override func registerCellClass(in segmentedView: TFYSwiftView) {
        segmentedView.collectionView.register(TFYSwiftDotCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: TFYSwiftView, cellForItemAt index: Int) -> TFYSwiftBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }
}

