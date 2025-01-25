//
//  TFYSwiftTitleImageDataSource.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

public enum TFYSwiftTitleImageType {
    case topImage
    case leftImage
    case bottomImage
    case rightImage
    case onlyImage
    case onlyTitle
    case backgroundImage
}

open class TFYSwiftTitleImageDataSource: TFYSwiftTitleDataSource {
    open var titleImageType: TFYSwiftTitleImageType = .rightImage
    /// 数量需要和item的数量保持一致。可以是ImageName或者图片网络地址
    open var normalImageInfos: [String]?
    /// 数量需要和item的数量保持一致。可以是ImageName或者图片网络地址。如果不赋值，选中时就不会处理图片切换。
    open var selectedImageInfos: [String]?
    /// 内部默认通过UIImage(named:)加载图片。如果传递的是图片网络地址或者想自己处理图片加载逻辑，可以通过该闭包处理。
    open var loadImageClosure: LoadImageClosure?
    /// 图片尺寸
    open var imageSize: CGSize = CGSize(width: 20, height: 20)
    /// title和image之间的间隔
    open var titleImageSpacing: CGFloat = 5
    /// 是否开启图片缩放
    open var isImageZoomEnabled: Bool = false
    /// 图片缩放选中时的scale
    open var imageSelectedZoomScale: CGFloat = 1.2

    open override func preferredItemModelInstance() -> TFYSwiftBaseItemModel {
        return TFYSwiftTitleImageItemModel()
    }

    open override func preferredRefreshItemModel(_ itemModel: TFYSwiftBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let itemModel = itemModel as? TFYSwiftTitleImageItemModel else {
            return
        }

        itemModel.titleImageType = titleImageType
        itemModel.normalImageInfo = normalImageInfos?[index]
        itemModel.selectedImageInfo = selectedImageInfos?[index]
        itemModel.loadImageClosure = loadImageClosure
        itemModel.imageSize = imageSize
        itemModel.isImageZoomEnabled = isImageZoomEnabled
        itemModel.imageNormalZoomScale = 1
        itemModel.imageSelectedZoomScale = imageSelectedZoomScale
        itemModel.titleImageSpacing = titleImageSpacing
        if index == selectedIndex {
            itemModel.imageCurrentZoomScale = itemModel.imageSelectedZoomScale
        }else {
            itemModel.imageCurrentZoomScale = itemModel.imageNormalZoomScale
        }
    }

    open override func preferredSegmentedView(_ segmentedView: TFYSwiftView, widthForItemAt index: Int) -> CGFloat {
        var width = super.preferredSegmentedView(segmentedView, widthForItemAt: index)
        if itemWidth == TFYSwiftViewAutomaticDimension {
            switch titleImageType {
            case .leftImage, .rightImage:
                width += titleImageSpacing + imageSize.width
            case .topImage, .bottomImage:
                width = max(width, imageSize.width)
            case .onlyImage:
                width = imageSize.width
            case .onlyTitle:
                break
            case .backgroundImage:
                width = max(width, imageSize.width)
            }
        }
        return width
    }

    public override func segmentedView(_ segmentedView: TFYSwiftView, widthForItemContentAt index: Int) -> CGFloat {
        var width = super.segmentedView(segmentedView, widthForItemContentAt: index)
        switch titleImageType {
        case .leftImage, .rightImage:
            width += titleImageSpacing + imageSize.width
        case .topImage, .bottomImage:
            width = max(width, imageSize.width)
        case .onlyImage:
            width = imageSize.width
        case .onlyTitle:
            break
        case .backgroundImage:
            width = max(width, imageSize.width)
        }
        return width
    }

    //MARK: - TFYSwiftViewDataSource
    open override func registerCellClass(in segmentedView: TFYSwiftView) {
        segmentedView.collectionView.register(TFYSwiftTitleImageCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: TFYSwiftView, cellForItemAt index: Int) -> TFYSwiftBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }

    open override func refreshItemModel(_ segmentedView: TFYSwiftView, leftItemModel: TFYSwiftBaseItemModel, rightItemModel: TFYSwiftBaseItemModel, percent: CGFloat) {
        super.refreshItemModel(segmentedView, leftItemModel: leftItemModel, rightItemModel: rightItemModel, percent: percent)

        guard let leftModel = leftItemModel as? TFYSwiftTitleImageItemModel, let rightModel = rightItemModel as? TFYSwiftTitleImageItemModel else {
            return
        }
        if isImageZoomEnabled && isItemTransitionEnabled {
            leftModel.imageCurrentZoomScale = TFYSwiftViewTool.interpolate(from: imageSelectedZoomScale, to: 1, percent: CGFloat(percent))
            rightModel.imageCurrentZoomScale = TFYSwiftViewTool.interpolate(from: 1, to: imageSelectedZoomScale, percent: CGFloat(percent))
        }
    }

    open override func refreshItemModel(_ segmentedView: TFYSwiftView, currentSelectedItemModel: TFYSwiftBaseItemModel, willSelectedItemModel: TFYSwiftBaseItemModel, selectedType: TFYSwiftViewItemSelectedType) {
        super.refreshItemModel(segmentedView, currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)

        guard let myCurrentSelectedItemModel = currentSelectedItemModel as? TFYSwiftTitleImageItemModel, let myWillSelectedItemModel = willSelectedItemModel as? TFYSwiftTitleImageItemModel else {
            return
        }

        myCurrentSelectedItemModel.imageCurrentZoomScale = myCurrentSelectedItemModel.imageNormalZoomScale
        myWillSelectedItemModel.imageCurrentZoomScale = myWillSelectedItemModel.imageSelectedZoomScale
    }
}

