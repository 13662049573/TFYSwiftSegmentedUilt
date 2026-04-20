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

// MARK: - TFYSwiftPagingContainer (SwiftUI ViewBuilder 分页容器)

/// SwiftUI 风格的分页容器：顶部是 `TFYSwiftSegmentedView`，下方是一组 SwiftUI 页面。
/// 页面通过 `ViewBuilder` 声明，会被依次装载到 UIScrollView 上，整体与 SwiftUI 的
/// 响应式布局配合得更自然，不再需要手动配 `TFYSwiftListContainerView` 与
/// `TFYSwiftViewListContainer` 协议。
///
/// Usage:
/// ```swift
/// @State private var index = 0
/// TFYSwiftPagingContainer(
///     titles: ["Home", "Trending", "Library"],
///     selectedIndex: $index
/// ) {
///     HomePage()
///     TrendingPage()
///     LibraryPage()
/// }
/// ```
@available(iOS 15.0, *)
public struct TFYSwiftPagingContainer<Pages: View>: View {
    @Binding private var selectedIndex: Int
    private let titles: [String]
    private let segmentedHeight: CGFloat
    private let showsIndicator: Bool
    private let customizer: TFYSwiftSegmentedView.Customizer?
    private let pages: Pages

    public init(titles: [String],
                selectedIndex: Binding<Int>,
                segmentedHeight: CGFloat = 44,
                showsIndicator: Bool = true,
                customizer: TFYSwiftSegmentedView.Customizer? = nil,
                @ViewBuilder pages: () -> Pages) {
        self.titles = titles
        self._selectedIndex = selectedIndex
        self.segmentedHeight = segmentedHeight
        self.showsIndicator = showsIndicator
        self.customizer = customizer
        self.pages = pages()
    }

    public var body: some View {
        VStack(spacing: 0) {
            TFYSwiftSegmentedView(titles: titles,
                                  selectedIndex: $selectedIndex,
                                  showsIndicator: showsIndicator,
                                  customizer: customizer)
                .frame(height: segmentedHeight)
            TabView(selection: $selectedIndex) {
                _VariadicView.Tree(PagesLayout()) {
                    pages
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }

    private struct PagesLayout: _VariadicView_UnaryViewRoot {
        func body(children: _VariadicView.Children) -> some View {
            ForEach(Array(children.enumerated()), id: \.offset) { offset, child in
                child.tag(offset)
            }
        }
    }
}

#endif
