//
//  TFYSwiftTitleImageItemModel.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

open class TFYSwiftTitleImageItemModel: TFYSwiftTitleItemModel {
    open var titleImageType: TFYSwiftTitleImageType = .rightImage
    open var normalImageInfo: String?
    open var selectedImageInfo: String?
    open var loadImageClosure: LoadImageClosure?
    open var imageSize: CGSize = CGSize.zero
    open var titleImageSpacing: CGFloat = 0
    open var isImageZoomEnabled: Bool = false
    open var imageNormalZoomScale: CGFloat = 0
    open var imageCurrentZoomScale: CGFloat = 0
    open var imageSelectedZoomScale: CGFloat = 0
}

