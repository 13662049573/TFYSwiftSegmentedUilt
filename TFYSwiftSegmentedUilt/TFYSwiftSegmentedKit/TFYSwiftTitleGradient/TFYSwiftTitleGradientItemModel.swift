//
//  TFYSwiftTitleGradientItemModel.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

open class TFYSwiftTitleGradientItemModel: TFYSwiftTitleItemModel {
    open var titleNormalGradientColors: [CGColor] = [CGColor]()
    open var titleCurrentGradientColors: [CGColor] = [CGColor]()
    open var titleSelectedGradientColors: [CGColor] = [CGColor]()
    open var titleGradientStartPoint: CGPoint = CGPoint.zero
    open var titleGradientEndPoint: CGPoint = CGPoint.zero
}

