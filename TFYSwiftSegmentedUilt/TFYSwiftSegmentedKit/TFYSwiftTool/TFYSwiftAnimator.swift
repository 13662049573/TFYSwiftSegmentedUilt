//
//  TFYSwiftAnimator.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import Foundation
import UIKit

/// 基于 `CADisplayLink` 的轻量动画驱动器。
///
/// 相较于 UIView.animate：
/// - 能在任意时刻通过 `progressClosure` 取到 0~1 的插值，方便驱动自定义属性。
/// - 支持前后台切换：App 进入后台会自动暂停 `displayLink` 以避免跳帧；回到前台会基于暂停时的剩余进度续播。
/// - 在 iOS 15+ / ProMotion（120Hz）设备上使用 `preferredFrameRateRange`，默认维持稳定 60~120Hz。
/// - 线程约束：CADisplayLink、UIApplication 通知均要求主线程，调用方必须在主线程使用。
///   未来升级 Swift 6 语言模式时建议整体标注 `@MainActor`（目前为兼容 Swift 5 call site 暂缓）。
open class TFYSwiftAnimator {
    /// 动画时长（秒）。<= 0 会直接触发完成回调。
    open var duration: TimeInterval = 0.25
    /// 每帧进度回调，参数范围 [0, 1]。
    open var progressClosure: ((CGFloat) -> Void)?
    /// 动画完成回调（正常结束或 `stop()` 被调用都会触发一次）。
    open var completedClosure: (() -> Void)?

    /// ProMotion 相关：期望的帧率范围。默认 60~120Hz，首选 120Hz。
    /// 在非 ProMotion 设备上系统会裁剪到硬件可支持的帧率。
    open var preferredFrameRateRange: CAFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 120, preferred: 120)

    private var displayLink: CADisplayLink?
    private var firstTimestamp: CFTimeInterval?
    /// 累计已经播放的进度（0~1）。进入后台暂停后，恢复时从该值继续。
    private var accumulatedProgress: CGFloat = 0
    private var hasStarted = false
    private var isPaused = false

    private var willResignObserver: NSObjectProtocol?
    private var didBecomeActiveObserver: NSObjectProtocol?

    public init() {}

    deinit {
        if let willResignObserver {
            NotificationCenter.default.removeObserver(willResignObserver)
        }
        if let didBecomeActiveObserver {
            NotificationCenter.default.removeObserver(didBecomeActiveObserver)
        }
        displayLink?.invalidate()
    }

    open func start() {
        guard duration > 0 else {
            finishAnimation(shouldComplete: true)
            return
        }
        // 重入保护：若正在播放则忽略，保留原进度。
        if hasStarted { return }
        hasStarted = true
        accumulatedProgress = 0
        firstTimestamp = nil
        isPaused = false
        attachApplicationObservers()
        makeDisplayLinkIfNeeded()
        displayLink?.isPaused = false
    }

    open func stop() {
        finishAnimation(shouldComplete: hasStarted)
    }

    // MARK: - Display Link

    private func makeDisplayLinkIfNeeded() {
        if displayLink != nil { return }
        let link = CADisplayLink(target: TFYSwiftWeakTarget(target: self), selector: #selector(TFYSwiftWeakTarget.forward(sender:)))
        link.preferredFrameRateRange = preferredFrameRateRange
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    @objc fileprivate func processDisplayLink(sender: CADisplayLink) {
        guard !isPaused else { return }
        let startTimestamp = firstTimestamp ?? sender.timestamp
        firstTimestamp = startTimestamp
        let elapsed = sender.timestamp - startTimestamp
        let rawPercent = CGFloat(elapsed / duration)
        // 与已积累的进度叠加（前后台恢复后继续播）。
        let percent = min(max(0, rawPercent) + accumulatedProgress, 1)
        if percent >= 1 {
            finishAnimation(shouldComplete: true)
        } else {
            progressClosure?(percent)
        }
    }

    private func finishAnimation(shouldComplete: Bool) {
        if shouldComplete {
            progressClosure?(1)
        }
        displayLink?.invalidate()
        displayLink = nil
        firstTimestamp = nil
        accumulatedProgress = 0
        detachApplicationObservers()
        if shouldComplete {
            completedClosure?()
        }
        hasStarted = false
        isPaused = false
    }

    // MARK: - Background handling

    private func attachApplicationObservers() {
        if willResignObserver != nil { return }
        willResignObserver = NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.pauseForBackground()
        }
        didBecomeActiveObserver = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.resumeFromBackground()
        }
    }

    private func detachApplicationObservers() {
        if let willResignObserver {
            NotificationCenter.default.removeObserver(willResignObserver)
        }
        if let didBecomeActiveObserver {
            NotificationCenter.default.removeObserver(didBecomeActiveObserver)
        }
        willResignObserver = nil
        didBecomeActiveObserver = nil
    }

    private func pauseForBackground() {
        guard hasStarted, let link = displayLink else { return }
        isPaused = true
        // 把已经播放的进度累计起来；下次从 accumulatedProgress 继续。
        if let start = firstTimestamp {
            let played = CGFloat((link.timestamp - start) / duration)
            accumulatedProgress = min(max(0, accumulatedProgress + played), 1)
        }
        firstTimestamp = nil
        link.isPaused = true
    }

    private func resumeFromBackground() {
        guard hasStarted, isPaused, let link = displayLink else { return }
        isPaused = false
        firstTimestamp = nil
        link.isPaused = false
    }
}

/// 打破 CADisplayLink 对 target 的强引用，避免 animator 释放不掉。
private final class TFYSwiftWeakTarget {
    weak var target: TFYSwiftAnimator?
    init(target: TFYSwiftAnimator) {
        self.target = target
    }
    @objc func forward(sender: CADisplayLink) {
        target?.processDisplayLink(sender: sender)
    }
}
