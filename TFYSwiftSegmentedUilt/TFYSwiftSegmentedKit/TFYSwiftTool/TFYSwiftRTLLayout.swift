//
//  TFYSwiftRTLLayout.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

public protocol TFYSwiftViewRTLCompatible: AnyObject {
    func segmentedViewShouldRTLLayout() -> Bool
    func segmentedView(horizontalFlipForView view: UIView?)
}

public extension TFYSwiftViewRTLCompatible {
    
    /// 根据当前系统布局方式返回是否需要RTL布局
    func segmentedViewShouldRTLLayout() -> Bool {
        return UIView.userInterfaceLayoutDirection(for: UIView.appearance().semanticContentAttribute) == .rightToLeft
    }
    
    /// 在RTL布局下水平翻转当前视图
    /// - Parameter view: 需要翻转的视图
    func segmentedView(horizontalFlipForView view: UIView?) {
        view?.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
}

class TFYSwiftRTLCollectionCell: UICollectionViewCell, TFYSwiftViewRTLCompatible {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        if segmentedViewShouldRTLLayout() {
            segmentedView(horizontalFlipForView: self)
            segmentedView(horizontalFlipForView: contentView)
        }
    }
    
}

