//
//  TFYSwiftScrollDelegateMultiplexer.swift
//  TFYSwiftSegmentedKit
//
//  A lightweight UIScrollViewDelegate multiplexer used to replace repeated
//  KVO add/remove cycles on child list scroll views in paging scenarios.
//
//  Why not KVO:
//  Adding/removing KVO observers on a high-frequency code path (e.g. every
//  didEndDisplaying list view) triggers visible jank on ProMotion devices.
//  A delegate multiplexer keeps all listeners attached to the child
//  UIScrollView and forwards events synchronously without runtime-observation
//  churn.
//

import Foundation
import UIKit
import ObjectiveC.runtime

/// 轻量级的 `UIScrollViewDelegate` 复用器：为同一个 `UIScrollView` 同时挂多个观察者。
///
/// 用法：
/// ```swift
/// let mux = TFYSwiftScrollDelegateMultiplexer()
/// mux.install(on: listScrollView, preserveExistingDelegate: true)
/// mux.addObserver(self)
/// ```
/// - Note: multiplexer 会把自身设为 `scrollView.delegate`；原 delegate 会被保留并作为第一个 observer。
///         multiplexer 本身不持有 scrollView 的强引用，observer 使用 weak-table，避免保留环。
@MainActor
public final class TFYSwiftScrollDelegateMultiplexer: NSObject, UIScrollViewDelegate {

    private var observers = NSHashTable<AnyObject>.weakObjects()
    private weak var attachedScrollView: UIScrollView?

    public override init() {
        super.init()
    }

    /// 将 multiplexer 安装到目标 scrollView。
    /// - Parameters:
    ///   - scrollView: 目标 UIScrollView
    ///   - preserveExistingDelegate: 是否保留已有 delegate（保留则加入 observer 列表）
    public func install(on scrollView: UIScrollView, preserveExistingDelegate: Bool = true) {
        attachedScrollView = scrollView
        if preserveExistingDelegate, let existing = scrollView.delegate, existing !== self {
            observers.add(existing as AnyObject)
        }
        scrollView.delegate = self
    }

    /// 从 scrollView 卸载（通常无需手动调用；scrollView 释放后 multiplexer 也会被释放）。
    public func uninstall() {
        if attachedScrollView?.delegate === self {
            attachedScrollView?.delegate = nil
        }
        attachedScrollView = nil
        observers.removeAllObjects()
    }

    public func addObserver(_ observer: UIScrollViewDelegate) {
        observers.add(observer as AnyObject)
    }

    public func removeObserver(_ observer: UIScrollViewDelegate) {
        observers.remove(observer as AnyObject)
    }

    // MARK: - UIScrollViewDelegate forwarders
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for obs in observers.allObjects {
            (obs as? UIScrollViewDelegate)?.scrollViewDidScroll?(scrollView)
        }
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        for obs in observers.allObjects {
            (obs as? UIScrollViewDelegate)?.scrollViewWillBeginDragging?(scrollView)
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        for obs in observers.allObjects {
            (obs as? UIScrollViewDelegate)?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for obs in observers.allObjects {
            (obs as? UIScrollViewDelegate)?.scrollViewDidEndDecelerating?(scrollView)
        }
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        for obs in observers.allObjects {
            (obs as? UIScrollViewDelegate)?.scrollViewDidEndScrollingAnimation?(scrollView)
        }
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                           withVelocity velocity: CGPoint,
                                           targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // forwardingTarget 可能把带 inout 指针的方法转丢；multiplexer 显式转发更稳。
        for obs in observers.allObjects {
            (obs as? UIScrollViewDelegate)?.scrollViewWillEndDragging?(
                scrollView,
                withVelocity: velocity,
                targetContentOffset: targetContentOffset
            )
        }
    }

    // Default implementations forward `responds(to:)` so UIKit sees only the
    // selectors at least one observer implements. This avoids paying the cost
    // of sending events to observers that don't care.
    public override func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) { return true }
        for obs in observers.allObjects where (obs as AnyObject).responds(to: aSelector) {
            return true
        }
        return false
    }

    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        // willEndDragging 已显式实现，避免指针参数转发异常。
        if aSelector == #selector(scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)) {
            return nil
        }
        for obs in observers.allObjects where (obs as AnyObject).responds(to: aSelector) {
            return obs
        }
        return nil
    }
}
