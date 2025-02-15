//
//  TFYSwiftMixcellDataSource.swift
//  TFYSwiftView
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit


/// 该示例主要用于展示cell的自定义组合。就像使用UITableView一样，注册不同的cell class，为不同的cell赋值。
/// 当你的需求需要处理不同类型的cell时，可以参考这里的逻辑。但是数据源这一块就需要你自己处理了。
/// 多种cell混用时，不建议处理cell之间元素的过渡。所以该示例也没有处理滚动过渡。
class TFYSwiftMixcellDataSource: TFYSwiftBaseDataSource {

    override func reloadData(selectedIndex: Int) {
        super.reloadData(selectedIndex: selectedIndex)

        let titleModel = TFYSwiftTitleItemModel()
        titleModel.title = "我只是title"
        dataSource.append(titleModel)

        let titleImageModel = TFYSwiftTitleImageItemModel()
        titleImageModel.title = "图片"
        titleImageModel.normalImageInfo = "dog"
        titleImageModel.imageSize = CGSize(width: 20, height: 20)
        dataSource.append(titleImageModel)

        let numberModel = TFYSwiftNumberItemModel()
        numberModel.title = "数字"
        numberModel.number = 33
        numberModel.numberString = "33"
        numberModel.numberWidthIncrement = 10
        dataSource.append(numberModel)

        let dotModel = TFYSwiftDotItemModel()
        dotModel.title = "红点"
        dotModel.dotState = true
        dotModel.dotSize = CGSize(width: 10, height: 10)
        dotModel.dotCornerRadius = 5
        dataSource.append(dotModel)

        for (index, model) in (dataSource as! [TFYSwiftTitleItemModel]).enumerated() {
            if index == selectedIndex {
                model.isSelected = true
                model.titleCurrentColor = model.titleSelectedColor
                break
            }
        }
    }

    override func preferredSegmentedView(_ segmentedView: TFYSwiftView, widthForItemAt index: Int) -> CGFloat {
        //根据不同的cell类型返回对应的cell宽度
        var otherWidth: CGFloat = 0
        var title: String?
        var titleNormalFont: UIFont?
        if let itemModel = dataSource[index] as? TFYSwiftTitleItemModel {
            title = itemModel.title
            titleNormalFont = itemModel.titleNormalFont
        }else if let itemModel = dataSource[index] as? TFYSwiftTitleImageItemModel {
            title = itemModel.title
            titleNormalFont = itemModel.titleNormalFont
            otherWidth += itemModel.titleImageSpacing + itemModel.imageSize.width
        }else if let itemModel = dataSource[index] as? TFYSwiftNumberItemModel {
            title = itemModel.title
            titleNormalFont = itemModel.titleNormalFont
        }else if let itemModel = dataSource[index] as? TFYSwiftDotItemModel {
            title = itemModel.title
            titleNormalFont = itemModel.titleNormalFont
        }

        let textWidth = NSString(string: title!).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: segmentedView.bounds.size.height), options: NSStringDrawingOptions.init(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), attributes: [NSAttributedString.Key.font : titleNormalFont!], context: nil).size.width
        let itemWidth = CGFloat(ceilf(Float(textWidth))) + itemWidthIncrement + otherWidth
        return itemWidth
    }

    //MARK: - TFYSwiftViewDataSource
    override func registerCellClass(in segmentedView: TFYSwiftView) {
        segmentedView.collectionView.register(TFYSwiftTitleCell.self, forCellWithReuseIdentifier: "titleCell")
        segmentedView.collectionView.register(TFYSwiftTitleImageCell.self, forCellWithReuseIdentifier: "titleImageCell")
        segmentedView.collectionView.register(TFYSwiftNumberCell.self, forCellWithReuseIdentifier: "numberCell")
        segmentedView.collectionView.register(TFYSwiftDotCell.self, forCellWithReuseIdentifier: "dotCell")
    }

    override func segmentedView(_ segmentedView: TFYSwiftView, cellForItemAt index: Int) -> TFYSwiftBaseCell {
        var cell:TFYSwiftBaseCell?
        if dataSource[index] is TFYSwiftTitleImageItemModel {
            cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "titleImageCell", at: index)
        }else if dataSource[index] is TFYSwiftNumberItemModel {
            cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "numberCell", at: index)
        }else if dataSource[index] is TFYSwiftDotItemModel {
            cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "dotCell", at: index)
        }else if dataSource[index] is TFYSwiftTitleItemModel {
            cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "titleCell", at: index)
        }
        return cell!
    }

    //针对不同的cell处理选中态和未选中态的刷新
    override func refreshItemModel(_ segmentedView: TFYSwiftView, currentSelectedItemModel: TFYSwiftBaseItemModel, willSelectedItemModel: TFYSwiftBaseItemModel, selectedType: TFYSwiftViewItemSelectedType) {
        super.refreshItemModel(segmentedView, currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)

        guard let myCurrentSelectedItemModel = currentSelectedItemModel as? TFYSwiftTitleItemModel, let myWilltSelectedItemModel = willSelectedItemModel as? TFYSwiftTitleItemModel else {
            return
        }

        myCurrentSelectedItemModel.titleCurrentColor = myCurrentSelectedItemModel.titleNormalColor

        myWilltSelectedItemModel.titleCurrentColor = myWilltSelectedItemModel.titleSelectedColor
    }
}
