//
//  TFYSwiftTitleDynamicConfiguration.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

public protocol TFYSwiftTitleDynamicConfiguration: NSObject {
    func titleNumberOfLines(at index: Int) -> Int
    func titleNormalColor(at index: Int) -> UIColor
    func titleSelectedColor(at index: Int) -> UIColor
    func titleNormalFont(at index: Int) -> UIFont
    func titleSelectedFont(at index: Int) -> UIFont?
}

