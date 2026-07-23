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

// MARK: - Pages builder（公开 API，避免依赖私有 `_VariadicView`）

@available(iOS 15.0, *)
@resultBuilder
public enum TFYSwiftPagingPagesBuilder {
    public static func buildExpression<V: View>(_ expression: V) -> AnyView {
        AnyView(expression)
    }

    public static func buildBlock(_ components: AnyView...) -> [AnyView] {
        Array(components)
    }

    public static func buildArray(_ components: [[AnyView]]) -> [AnyView] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [AnyView]?) -> [AnyView] {
        component ?? []
    }

    public static func buildEither(first component: [AnyView]) -> [AnyView] {
        component
    }

    public static func buildEither(second component: [AnyView]) -> [AnyView] {
        component
    }
}

// MARK: - TFYSwiftPagingContainer (SwiftUI 分页容器)

/// SwiftUI 风格的分页容器：顶部是 `TFYSwiftSegmentedView`，下方是一组 SwiftUI 页面。
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
public struct TFYSwiftPagingContainer: View {
    @Binding private var selectedIndex: Int
    private let titles: [String]
    private let segmentedHeight: CGFloat
    private let showsIndicator: Bool
    private let customizer: TFYSwiftSegmentedView.Customizer?
    private let pages: [AnyView]

    public init(titles: [String],
                selectedIndex: Binding<Int>,
                segmentedHeight: CGFloat = 44,
                showsIndicator: Bool = true,
                customizer: TFYSwiftSegmentedView.Customizer? = nil,
                @TFYSwiftPagingPagesBuilder pages: () -> [AnyView]) {
        self.titles = titles
        self._selectedIndex = selectedIndex
        self.segmentedHeight = segmentedHeight
        self.showsIndicator = showsIndicator
        self.customizer = customizer
        self.pages = pages()
    }

    /// 显式传入页面数组的便捷初始化。
    public init(titles: [String],
                selectedIndex: Binding<Int>,
                segmentedHeight: CGFloat = 44,
                showsIndicator: Bool = true,
                customizer: TFYSwiftSegmentedView.Customizer? = nil,
                pages: [AnyView]) {
        self.titles = titles
        self._selectedIndex = selectedIndex
        self.segmentedHeight = segmentedHeight
        self.showsIndicator = showsIndicator
        self.customizer = customizer
        self.pages = pages
    }

    public var body: some View {
        VStack(spacing: 0) {
            TFYSwiftSegmentedView(titles: titles,
                                  selectedIndex: $selectedIndex,
                                  showsIndicator: showsIndicator,
                                  customizer: customizer)
                .frame(height: segmentedHeight)
            TabView(selection: $selectedIndex) {
                ForEach(Array(pages.enumerated()), id: \.offset) { offset, page in
                    page.tag(offset)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

#endif
