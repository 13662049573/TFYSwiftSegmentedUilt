//
//  TFYSwiftTitleAttributeDataSource.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

open class TFYSwiftTitleAttributeDataSource: TFYSwiftBaseDataSource {
    /// 富文本title数组
    open var attributedTitles = [NSAttributedString]()
    /// 选中时的富文本，可选。如果要使用确保count与attributedTitles一致。
    open var selectedAttributedTitles: [NSAttributedString]?
    /// 如果将TFYSwiftView嵌套进UITableView的cell，每次重用的时候，TFYSwiftView进行reloadData时，会重新计算所有的title宽度。所以该应用场景，需要UITableView的cellModel缓存titles的文字宽度，再通过该闭包方法返回给TFYSwiftView。
    open var widthForTitleClosure: ((NSAttributedString)->(CGFloat))?
    /// title的numberOfLines
    open var titleNumberOfLines: Int = 2

    open override func preferredItemModelInstance() -> TFYSwiftBaseItemModel {
        return TFYSwiftTitleAttributeItemModel()
    }

    open override func preferredItemCount() -> Int {
        return attributedTitles.count
    }

    open override func preferredRefreshItemModel(_ itemModel: TFYSwiftBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let myItemModel = itemModel as? TFYSwiftTitleAttributeItemModel else {
            return
        }

        myItemModel.attributedTitle = attributedTitles[index]
        myItemModel.selectedAttributedTitle = selectedAttributedTitles?[index]
        myItemModel.textWidth = widthForTitle(myItemModel.attributedTitle, selectedTitle: myItemModel.selectedAttributedTitle)
        myItemModel.titleNumberOfLines = titleNumberOfLines
    }

    open func widthForTitle(_ title: NSAttributedString?, selectedTitle: NSAttributedString?) -> CGFloat {
        let attriText = selectedTitle != nil ? selectedTitle : title
        guard let text = attriText else {
            return 0
        }
        if widthForTitleClosure != nil {
            return widthForTitleClosure!(text)
        }else {
            let textWidth = text.boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: NSStringDrawingOptions.init(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), context: nil).size.width
            return CGFloat(ceilf(Float(textWidth)))
        }
    }

    /// 因为该方法会被频繁调用，所以应该在`preferredRefreshItemModel( _ itemModel: TFYSwiftBaseItemModel, at index: Int, selectedIndex: Int)`方法里面，根据数据源计算好文字宽度，然后缓存起来。该方法直接使用已经计算好的文字宽度即可。
    open override func preferredSegmentedView(_ segmentedView: TFYSwiftView, widthForItemAt index: Int) -> CGFloat {
        var width: CGFloat = 0
        if itemWidth == TFYSwiftViewAutomaticDimension {
            let myItemModel = dataSource[index] as! TFYSwiftTitleAttributeItemModel
            width = myItemModel.textWidth + itemWidthIncrement
        }else {
            width = itemWidth + itemWidthIncrement
        }
        return width
    }

    //MARK: - TFYSwiftViewDataSource
    open override func registerCellClass(in segmentedView: TFYSwiftView) {
        segmentedView.collectionView.register(TFYSwiftTitleAttributeCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: TFYSwiftView, cellForItemAt index: Int) -> TFYSwiftBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }
}

