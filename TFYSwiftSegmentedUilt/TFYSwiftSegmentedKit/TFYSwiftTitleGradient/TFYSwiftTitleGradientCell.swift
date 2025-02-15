//
//  TFYSwiftTitleGradientCell.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

open class TFYSwiftTitleGradientCell: TFYSwiftTitleCell {
    public let gradientLayer = CAGradientLayer()
    private var canStartSelectedAnimation: Bool = false

    open override func commonInit() {
        super.commonInit()

        titleLabel.removeFromSuperview()
        maskTitleLabel.removeFromSuperview()

        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor]
        contentView.layer.addSublayer(gradientLayer)
        gradientLayer.mask = titleLabel.layer
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = titleLabel.frame
        CATransaction.commit()
        titleLabel.frame = gradientLayer.bounds
    }

    open override func reloadData(itemModel: TFYSwiftBaseItemModel, selectedType: TFYSwiftViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType)

        guard let myItemModel = itemModel as? TFYSwiftTitleGradientItemModel else {
            return
        }

        if myItemModel.isSelectedAnimable && canStartSelectedAnimation(itemModel: myItemModel, selectedType: selectedType) {
            let closure: TFYSwiftCellSelectedAnimationClosure = {[weak self] (percent) in
                if myItemModel.isSelected {
                    myItemModel.titleCurrentGradientColors = TFYSwiftViewTool.interpolateColors(from: myItemModel.titleNormalGradientColors, to: myItemModel.titleSelectedGradientColors, percent: percent)
                }else {
                    myItemModel.titleCurrentGradientColors = TFYSwiftViewTool.interpolateColors(from: myItemModel.titleSelectedGradientColors, to: myItemModel.titleNormalGradientColors, percent: percent)
                }
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                self?.gradientLayer.colors = myItemModel.titleCurrentGradientColors
                CATransaction.commit()
                self?.setNeedsLayout()
                self?.layoutIfNeeded()
            }
            appendSelectedAnimationClosure(closure: closure)
            canStartSelectedAnimation = true
            startSelectedAnimationIfNeeded(itemModel: myItemModel, selectedType: selectedType)
            canStartSelectedAnimation = false
        }else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            gradientLayer.startPoint = myItemModel.titleGradientStartPoint
            gradientLayer.endPoint = myItemModel.titleGradientEndPoint
            gradientLayer.colors = myItemModel.titleCurrentGradientColors
            CATransaction.commit()
        }
    }

    open override func startSelectedAnimationIfNeeded(itemModel: TFYSwiftBaseItemModel, selectedType: TFYSwiftViewItemSelectedType) {
        if canStartSelectedAnimation {
            super.startSelectedAnimationIfNeeded(itemModel: itemModel, selectedType: selectedType)
        }
    }
}

