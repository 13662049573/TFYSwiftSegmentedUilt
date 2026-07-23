//
//  TFYSwiftBaseItemModel.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import Foundation
import UIKit

open class TFYSwiftBaseItemModel {
    open var index: Int = 0
    /// 当前数据源的总 item 数量。由 `TFYSwiftBaseDataSource.reloadData(selectedIndex:)` 自动刷新，
    /// 方便 cell 在 VoiceOver 下读出 "Tab X of N"。
    open var totalItemCount: Int = 0
    open var isSelected: Bool = false
    open var itemWidth: CGFloat = 0
    /// 指示器视图Frame转换到cell
    open var indicatorConvertToItemFrame: CGRect = CGRect.zero
    open var isItemTransitionEnabled: Bool = true
    open var isSelectedAnimable: Bool = false
    open var selectedAnimationDuration: TimeInterval = 0
    /// 是否正在进行过渡动画
    open var isTransitionAnimating: Bool = false
    open var isItemWidthZoomEnabled: Bool = false
    open var itemWidthNormalZoomScale: CGFloat = 0
    open var itemWidthCurrentZoomScale: CGFloat = 0
    open var itemWidthSelectedZoomScale: CGFloat = 0
    /// VoiceOver 读出 "双击切换" 的 hint；数据源可按需覆盖。
    open var accessibilityHintText: String? = nil
    /// 角标配置；由 `TFYSwiftBaseDataSource.badges` 在 reload 时写入，cell 在 `reloadData` / layout 时应用。
    open var badgeConfiguration: TFYSwiftBadgeConfiguration? = nil
    /// 是否可交互选中。`false` 时点击被忽略，cell 会以 `disabledAlpha` 变淡。
    open var isItemEnabled: Bool = true
    /// 禁用态透明度。默认 0.4。
    open var disabledAlpha: CGFloat = 0.4

    public init() {
    }
}

