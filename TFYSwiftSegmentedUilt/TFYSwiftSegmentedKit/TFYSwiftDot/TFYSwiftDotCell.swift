//
//  TFYSwiftDotCell.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

open class TFYSwiftDotCell: TFYSwiftTitleCell {
    open var dotView = UIView()

    open override func commonInit() {
        super.commonInit()

        contentView.addSubview(dotView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let myItemModel = itemModel as? TFYSwiftDotItemModel else {
            return
        }

        dotView.center = CGPoint(x: titleLabel.frame.maxX + myItemModel.dotOffset.x, y: titleLabel.frame.minY + myItemModel.dotOffset.y)
    }

    open override func reloadData(itemModel: TFYSwiftBaseItemModel, selectedType: TFYSwiftViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let myItemModel = itemModel as? TFYSwiftDotItemModel else {
            return
        }

        dotView.backgroundColor = myItemModel.dotColor
        dotView.bounds = CGRect(x: 0, y: 0, width: myItemModel.dotSize.width, height: myItemModel.dotSize.height)
        dotView.isHidden = !myItemModel.dotState
        dotView.layer.cornerRadius = myItemModel.dotCornerRadius
    }
}
