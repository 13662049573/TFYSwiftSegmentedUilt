//
//  TFYSwiftTitleAttributeCell.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

open class TFYSwiftTitleAttributeCell: TFYSwiftBaseCell {
    open var titleLabel = UILabel()

    open override func commonInit() {
        super.commonInit()

        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        let centerX = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
        contentView.addConstraint(centerX)
        let centerY = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
        contentView.addConstraint(centerY)
    }

    open override func reloadData(itemModel: TFYSwiftBaseItemModel, selectedType: TFYSwiftViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let myItemModel = itemModel as? TFYSwiftTitleAttributeItemModel else {
            return
        }

        titleLabel.numberOfLines = myItemModel.titleNumberOfLines
        if myItemModel.isSelected && myItemModel.selectedAttributedTitle != nil {
            titleLabel.attributedText = myItemModel.selectedAttributedTitle
        }else {
            titleLabel.attributedText = myItemModel.attributedTitle
        }
        titleLabel.textAlignment = .center
    }
}

