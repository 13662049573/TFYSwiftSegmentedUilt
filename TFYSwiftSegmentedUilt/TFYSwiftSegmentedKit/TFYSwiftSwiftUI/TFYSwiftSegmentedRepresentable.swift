//
//  TFYSwiftSegmentedRepresentable.swift
//  TFYSwiftSegmentedKit
//
//  SwiftUI wrapper around `TFYSwiftView` so the segmented control can be used
//  directly in a SwiftUI view hierarchy. The wrapper intentionally only exposes
//  the most common title-driven path (`TFYSwiftTitleDataSource`) and the
//  selected-index binding to keep the API surface minimal; anything more
//  advanced can drop down to `TFYSwiftView` and still be embedded via
//  `UIViewRepresentable`.
//

import SwiftUI
import UIKit

#if canImport(SwiftUI)

/// SwiftUI wrapper exposing a title-only segmented control backed by
/// `TFYSwiftView` + `TFYSwiftTitleDataSource` + `TFYSwiftIndicatorLineView`.
///
/// Usage:
/// ```swift
/// @State private var index = 0
/// TFYSwiftSegmentedView(
///     titles: ["Home", "Trending", "Library"],
///     selectedIndex: $index
/// )
/// .frame(height: 44)
/// ```
@available(iOS 15.0, *)
public struct TFYSwiftSegmentedView: UIViewRepresentable {

    public typealias Customizer = (TFYSwiftView, TFYSwiftTitleDataSource) -> Void

    public let titles: [String]
    @Binding public var selectedIndex: Int
    public let showsIndicator: Bool
    public let customizer: Customizer?

    /// - Parameters:
    ///   - titles: 标题数组
    ///   - selectedIndex: 双向绑定的选中索引
    ///   - showsIndicator: 是否附带默认的下划线指示器，默认开启
    ///   - customizer: 可选闭包；在 dataSource / view 构建完成后回调，允许调用方进一步定制颜色、字体、指示器等。
    public init(
        titles: [String],
        selectedIndex: Binding<Int>,
        showsIndicator: Bool = true,
        customizer: Customizer? = nil
    ) {
        self.titles = titles
        self._selectedIndex = selectedIndex
        self.showsIndicator = showsIndicator
        self.customizer = customizer
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> TFYSwiftView {
        let view = TFYSwiftView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let dataSource = TFYSwiftTitleDataSource()
        dataSource.titles = titles
        dataSource.isTitleDynamicTypeEnabled = true
        context.coordinator.dataSource = dataSource

        view.delegate = context.coordinator
        view.dataSource = dataSource

        if showsIndicator {
            let indicator = TFYSwiftIndicatorLineView()
            view.indicators = [indicator]
        }

        let clamped = max(0, min(selectedIndex, max(titles.count - 1, 0)))
        view.defaultSelectedIndex = clamped

        customizer?(view, dataSource)
        return view
    }

    public func updateUIView(_ uiView: TFYSwiftView, context: Context) {
        guard let dataSource = context.coordinator.dataSource else { return }

        if dataSource.titles != titles {
            dataSource.titles = titles
            customizer?(uiView, dataSource)
            uiView.reloadData()
        }

        let clamped = max(0, min(selectedIndex, max(titles.count - 1, 0)))
        if clamped != context.coordinator.lastReportedIndex {
            context.coordinator.lastReportedIndex = clamped
            uiView.selectItemAt(index: clamped, animated: true)
        }
    }

    public final class Coordinator: NSObject, TFYSwiftViewDelegate {
        fileprivate var parent: TFYSwiftSegmentedView
        fileprivate var dataSource: TFYSwiftTitleDataSource?
        fileprivate var lastReportedIndex: Int = -1

        init(_ parent: TFYSwiftSegmentedView) {
            self.parent = parent
        }

        public func segmentedView(_ segmentedView: TFYSwiftView, didSelectedItemAt index: Int) {
            guard index != lastReportedIndex else { return }
            lastReportedIndex = index
            // 回主线程异步，避免 SwiftUI 在 layout 阶段更新 state 触发警告。
            DispatchQueue.main.async { [weak self] in
                self?.parent.selectedIndex = index
            }
        }
    }
}

#endif
