//
//  TFYSwiftNumberCell.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

open class TFYSwiftNumberCell: TFYSwiftTitleCell {
    public let numberLabel = UILabel()

    open override func commonInit() {
        super.commonInit()

        numberLabel.isHidden = true
        numberLabel.textAlignment = .center
        numberLabel.layer.masksToBounds = true
        contentView.addSubview(numberLabel)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let myItemModel = itemModel as? TFYSwiftNumberItemModel else {
            return
        }

        numberLabel.sizeToFit()
        let height = myItemModel.numberHeight
        numberLabel.layer.cornerRadius = height/2
        numberLabel.bounds.size = CGSize(width: numberLabel.bounds.size.width + myItemModel.numberWidthIncrement, height: height)
        numberLabel.center = CGPoint(x: titleLabel.frame.maxX + myItemModel.numberOffset.x, y: titleLabel.frame.minY + myItemModel.numberOffset.y)
    }

    open override func reloadData(itemModel: TFYSwiftBaseItemModel, selectedType: TFYSwiftViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let myItemModel = itemModel as? TFYSwiftNumberItemModel else {
            return
        }

        numberLabel.backgroundColor = myItemModel.numberBackgroundColor
        numberLabel.textColor = myItemModel.numberTextColor
        numberLabel.text = myItemModel.numberString
        numberLabel.font = myItemModel.numberFont
        numberLabel.isHidden = myItemModel.number == 0

        setNeedsLayout()
    }
}

