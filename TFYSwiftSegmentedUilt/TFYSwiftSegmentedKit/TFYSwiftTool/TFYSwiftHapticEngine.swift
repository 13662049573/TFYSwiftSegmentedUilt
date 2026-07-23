//
//  TFYSwiftHapticEngine.swift
//  TFYSwiftSegmentedKit
//
//  Tiny wrapper around UISelectionFeedbackGenerator with a guard rail for
//  `UIAccessibility.shouldReduceMotion` and a cached generator to avoid
//  re-preparing on every selection change (prepare() is expensive).
//

import UIKit

@MainActor
public final class TFYSwiftHapticEngine {

    public static let shared = TFYSwiftHapticEngine()

    /// 是否启用触感。受 reduce motion / low power mode 影响（调用方可主动 toggle）。
    public var isEnabled: Bool = true

    private let selection = UISelectionFeedbackGenerator()
    private let impactLight = UIImpactFeedbackGenerator(style: .light)

    public init() {
        selection.prepare()
    }

    /// 选中切换时触发的轻量反馈。点击/滚动吸附都使用这种反馈。
    public func selectionChanged() {
        guard isEnabled else { return }
        if UIAccessibility.isReduceMotionEnabled { return }
        selection.selectionChanged()
        selection.prepare()
    }

    /// 较强烈的反馈，用于 long-press / context menu 触发。
    public func impact() {
        guard isEnabled else { return }
        if UIAccessibility.isReduceMotionEnabled { return }
        impactLight.impactOccurred()
        impactLight.prepare()
    }
}
