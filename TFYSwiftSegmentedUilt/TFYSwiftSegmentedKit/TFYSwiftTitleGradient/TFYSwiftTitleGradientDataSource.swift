//
//  TFYSwiftTitleGradientDataSource.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

open class TFYSwiftTitleGradientDataSource: TFYSwiftTitleDataSource {
    /// title普通状态下的渐变colors
    open var titleNormalGradientColors: [CGColor] = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.cgColor]
    /// title选中状态下的渐变colors
    open var titleSelectedGradientColors: [CGColor] = [UIColor(red: 18/255.0, green: 194/255.0, blue: 233/255.0, alpha: 1).cgColor, UIColor(red: 196/255.0, green: 113/255.0, blue: 237/255.0, alpha: 1).cgColor, UIColor(red: 246/255.0, green: 79/255.0, blue: 89/255.0, alpha: 1).cgColor]
    /// title渐变的StartPoint
    open var titleGradientStartPoint: CGPoint = CGPoint(x: 0, y: 0)
    /// title渐变的EndPoint
    open var titleGradientEndPoint: CGPoint = CGPoint(x: 1, y: 0)

    open override func preferredItemModelInstance() -> TFYSwiftBaseItemModel {
        return TFYSwiftTitleGradientItemModel()
    }

    open override func preferredRefreshItemModel(_ itemModel: TFYSwiftBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let itemModel = itemModel as? TFYSwiftTitleGradientItemModel else {
            return
        }

        itemModel.titleGradientStartPoint = titleGradientStartPoint
        itemModel.titleGradientEndPoint = titleGradientEndPoint
        itemModel.titleNormalGradientColors = titleNormalGradientColors
        itemModel.titleSelectedGradientColors = titleSelectedGradientColors
        if index == selectedIndex {
            itemModel.titleCurrentGradientColors = itemModel.titleSelectedGradientColors
        }else {
            itemModel.titleCurrentGradientColors = itemModel.titleNormalGradientColors
        }
    }

    //MARK: - TFYSwiftViewDataSource
    open override func registerCellClass(in segmentedView: TFYSwiftView) {
        segmentedView.collectionView.register(TFYSwiftTitleGradientCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: TFYSwiftView, cellForItemAt index: Int) -> TFYSwiftBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }

    open override func refreshItemModel(_ segmentedView: TFYSwiftView, leftItemModel: TFYSwiftBaseItemModel, rightItemModel: TFYSwiftBaseItemModel, percent: CGFloat) {
        super.refreshItemModel(segmentedView, leftItemModel: leftItemModel, rightItemModel: rightItemModel, percent: percent)

        guard let leftModel = leftItemModel as? TFYSwiftTitleGradientItemModel, let rightModel = rightItemModel as? TFYSwiftTitleGradientItemModel else {
            return
        }

        if isTitleColorGradientEnabled && isItemTransitionEnabled {
            leftModel.titleCurrentGradientColors = TFYSwiftViewTool.interpolateColors(from: leftModel.titleSelectedGradientColors, to: leftModel.titleNormalGradientColors, percent: percent)
            rightModel.titleCurrentGradientColors = TFYSwiftViewTool.interpolateColors(from: rightModel.titleNormalGradientColors, to: rightModel.titleSelectedGradientColors, percent: percent)
        }
    }

    open override func refreshItemModel(_ segmentedView: TFYSwiftView, currentSelectedItemModel: TFYSwiftBaseItemModel, willSelectedItemModel: TFYSwiftBaseItemModel, selectedType: TFYSwiftViewItemSelectedType) {
        super.refreshItemModel(segmentedView, currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)

        guard let myCurrentSelectedItemModel = currentSelectedItemModel as? TFYSwiftTitleGradientItemModel, let myWillSelectedItemModel = willSelectedItemModel as? TFYSwiftTitleGradientItemModel else {
            return
        }

        myCurrentSelectedItemModel.titleCurrentGradientColors = myCurrentSelectedItemModel.titleNormalGradientColors
        myWillSelectedItemModel.titleCurrentGradientColors = myWillSelectedItemModel.titleSelectedGradientColors
    }
}

