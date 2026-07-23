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

public extension TFYSwiftViewRTLCompatible where Self: UIView {
    
    /// 根据当前视图（或窗口）的布局方向返回是否需要 RTL。
    /// 优先使用 `effectiveUserInterfaceLayoutDirection`，避免依赖全局 `UIView.appearance()`。
    func segmentedViewShouldRTLLayout() -> Bool {
        if effectiveUserInterfaceLayoutDirection == .rightToLeft {
            return true
        }
        if let window = window ?? UIApplication.shared.tfy_firstKeyWindow {
            return window.effectiveUserInterfaceLayoutDirection == .rightToLeft
        }
        return UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
    }
    
    /// 在RTL布局下水平翻转当前视图
    /// - Parameter view: 需要翻转的视图
    func segmentedView(horizontalFlipForView view: UIView?) {
        view?.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
}

private extension UIApplication {
    var tfy_firstKeyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }
    }
}

public extension TFYSwiftViewRTLCompatible {
    
    /// 无 `UIView` 上下文时的降级：读取 trait 集合默认布局方向。
    func segmentedViewShouldRTLLayout() -> Bool {
        UIView.userInterfaceLayoutDirection(for: .unspecified) == .rightToLeft
            || UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
    
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

