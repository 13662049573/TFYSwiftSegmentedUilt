//
//  TFYSwiftListContainerBase.swift
//  TFYSwiftSegmentedKit
//
//  Unified protocol surface that both `TFYSwiftListContainerView` (generic)
//  and `TFYSwiftPagingListContainerView` (paging-specific) conform to. New
//  callers should accept this protocol directly so behavior remains identical
//  regardless of which concrete type is used.
//
//  v2.0 migration note:
//  - Keep both concrete implementations for full binary/source compatibility.
//  - Public types expose new nested aliases that point back to this protocol.
//  - A follow-up 2.x release may fold the two into a single concrete class.
//

import UIKit

/// 列表容器共享的协议。`TFYSwiftListContainerView` 与 `TFYSwiftPagingListContainerView` 都应遵守它。
@MainActor
public protocol TFYSwiftListContainerBase: UIView {

    /// 数据源数量更新时调用，触发所有 list 视图重新生成。
    func reloadData()

    /// 当前容器的滚动视图（横向分页 / collectionView），供 `TFYSwiftView` 做 contentScrollView 绑定。
    func contentScrollView() -> UIScrollView

    /// 默认选中的 list 位置。
    var defaultSelectedIndex: Int { get set }
}

/// 已在 1.x 存在的两种具体实现的统一别名。
/// 推荐新代码使用 `TFYSwiftListContainerBase` 协议参数类型，而不是具体类，以便未来版本合并时零成本迁移。
public typealias TFYSwiftAnyListContainer = TFYSwiftListContainerBase
