//
//  TFYSwiftViewEventHandlers.swift
//  TFYSwiftSegmentedKit
//
//  2.0 新增：提供面向闭包的事件接口，作为 `TFYSwiftViewDelegate` 的补集，方便
//  Swift / SwiftUI 客户端以更简洁的方式订阅事件，且与现有 delegate 完全共存。
//  两者的回调时机相同（同步派发），可一起使用。
//
//  同时提供 Combine Publisher（iOS 13+）以及一个 `async` 版本的 `selectItem(at:animated:)`，
//  使得调用方可以通过 `await view.selectItem(at: 2)` 等待一次动画完成。
//

import Combine
import UIKit

/// 事件闭包集合。设置任意子字段都只是额外订阅，不会替换或阻断现有 `delegate` 回调。
public struct TFYSwiftViewEventHandlers {
    /// 任意方式（点击 / 滚动 / 代码）触发的选中回调。
    public var didSelect: ((_ segmentedView: TFYSwiftView, _ index: Int) -> Void)?

    /// 点击选中时触发，在 `didSelect` 之前发生。
    public var didClickSelect: ((_ segmentedView: TFYSwiftView, _ index: Int) -> Void)?

    /// 滚动 PagingView 过渡后，index 落定时触发。
    public var didScrollSelect: ((_ segmentedView: TFYSwiftView, _ index: Int) -> Void)?

    /// 左右滑动中，从 baseIndex 到 targetIndex 的连续进度。
    public var scrollingProgress: ((_ segmentedView: TFYSwiftView, _ from: Int, _ to: Int, _ percent: CGFloat) -> Void)?

    public init(didSelect: ((_ segmentedView: TFYSwiftView, _ index: Int) -> Void)? = nil,
                didClickSelect: ((_ segmentedView: TFYSwiftView, _ index: Int) -> Void)? = nil,
                didScrollSelect: ((_ segmentedView: TFYSwiftView, _ index: Int) -> Void)? = nil,
                scrollingProgress: ((_ segmentedView: TFYSwiftView, _ from: Int, _ to: Int, _ percent: CGFloat) -> Void)? = nil) {
        self.didSelect = didSelect
        self.didClickSelect = didClickSelect
        self.didScrollSelect = didScrollSelect
        self.scrollingProgress = scrollingProgress
    }
}

// MARK: - Storage

private enum TFYSwiftViewEventKeys {
    static var handlers: UInt8 = 0
    static var selectedIndexSubject: UInt8 = 0
    static var scrollingProgressSubject: UInt8 = 0
}

extension TFYSwiftView {

    /// 事件闭包集合。可多次设置，始终使用最后一次赋值的快照。
    public var eventHandlers: TFYSwiftViewEventHandlers {
        get {
            if let v = objc_getAssociatedObject(self, &TFYSwiftViewEventKeys.handlers) as? TFYSwiftViewEventHandlers {
                return v
            }
            let fresh = TFYSwiftViewEventHandlers()
            objc_setAssociatedObject(self, &TFYSwiftViewEventKeys.handlers, fresh, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return fresh
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftViewEventKeys.handlers, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 提供 selectedIndex 变化的 Publisher（初始值订阅时会立刻发送当前值）。
    @available(iOS 13.0, tvOS 13.0, *)
    public var selectedIndexPublisher: AnyPublisher<Int, Never> {
        let subject: CurrentValueSubject<Int, Never>
        if let existing = objc_getAssociatedObject(self, &TFYSwiftViewEventKeys.selectedIndexSubject) as? CurrentValueSubject<Int, Never> {
            subject = existing
        } else {
            subject = CurrentValueSubject<Int, Never>(selectedIndex)
            objc_setAssociatedObject(self, &TFYSwiftViewEventKeys.selectedIndexSubject, subject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return subject.eraseToAnyPublisher()
    }

    /// 提供实时滚动进度（from, to, percent）的 Publisher。
    @available(iOS 13.0, tvOS 13.0, *)
    public var scrollingProgressPublisher: AnyPublisher<(from: Int, to: Int, percent: CGFloat), Never> {
        let subject: PassthroughSubject<(from: Int, to: Int, percent: CGFloat), Never>
        if let existing = objc_getAssociatedObject(self, &TFYSwiftViewEventKeys.scrollingProgressSubject) as? PassthroughSubject<(from: Int, to: Int, percent: CGFloat), Never> {
            subject = existing
        } else {
            subject = PassthroughSubject<(from: Int, to: Int, percent: CGFloat), Never>()
            objc_setAssociatedObject(self, &TFYSwiftViewEventKeys.scrollingProgressSubject, subject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return subject.eraseToAnyPublisher()
    }

    /// 异步版本的 `selectItemAt(index:animated:)`。调用方可以用 `await` 等待过渡动画结束。
    ///
    /// 动画时长等同于 `dataSource?.selectedAnimationDuration`；若关闭动画则立即返回。
    @available(iOS 13.0, tvOS 13.0, *)
    public func selectItem(at index: Int, animated: Bool = true) async {
        selectItemAt(index: index, animated: animated)
        guard animated, let duration = dataSource?.selectedAnimationDuration, duration > 0 else { return }
        let ns = UInt64(duration * 1_000_000_000)
        try? await Task.sleep(nanoseconds: ns)
    }

    // MARK: Internal dispatchers (invoked from TFYSwiftView at existing callback points)
    @_spi(TFYSwiftEvents)
    public func tfy_emit_didSelect(index: Int) {
        eventHandlers.didSelect?(self, index)
        if #available(iOS 13.0, tvOS 13.0, *) {
            (objc_getAssociatedObject(self, &TFYSwiftViewEventKeys.selectedIndexSubject) as? CurrentValueSubject<Int, Never>)?.send(index)
        }
    }

    @_spi(TFYSwiftEvents)
    public func tfy_emit_didClickSelect(index: Int) {
        eventHandlers.didClickSelect?(self, index)
    }

    @_spi(TFYSwiftEvents)
    public func tfy_emit_didScrollSelect(index: Int) {
        eventHandlers.didScrollSelect?(self, index)
    }

    @_spi(TFYSwiftEvents)
    public func tfy_emit_scrollingProgress(from: Int, to: Int, percent: CGFloat) {
        eventHandlers.scrollingProgress?(self, from, to, percent)
        if #available(iOS 13.0, tvOS 13.0, *) {
            (objc_getAssociatedObject(self, &TFYSwiftViewEventKeys.scrollingProgressSubject) as? PassthroughSubject<(from: Int, to: Int, percent: CGFloat), Never>)?.send((from, to, percent))
        }
    }
}
