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

// MARK: - TFYSwiftListPagingContainer（真实 ListContainer 联动）

/// 使用 `TFYSwiftView` + `TFYSwiftListContainerView` 的 SwiftUI 分页容器。
/// 与 `TFYSwiftPagingContainer`（TabView 门面）不同，滑动时指示器进度与 UIKit 路径一致，并支持懒加载列表。
///
/// Usage:
/// ```swift
/// TFYSwiftListPagingContainer(titles: titles, selectedIndex: $index) { index in
///     Text("Page \(index)")
/// }
/// ```
@available(iOS 15.0, *)
public struct TFYSwiftListPagingContainer<Page: View>: UIViewControllerRepresentable {
    @Binding public var selectedIndex: Int
    public let titles: [String]
    public let segmentedHeight: CGFloat
    public let showsIndicator: Bool
    public let customizer: TFYSwiftSegmentedView.Customizer?
    public let pageBuilder: (Int) -> Page

    public init(titles: [String],
                selectedIndex: Binding<Int>,
                segmentedHeight: CGFloat = 44,
                showsIndicator: Bool = true,
                customizer: TFYSwiftSegmentedView.Customizer? = nil,
                @ViewBuilder page: @escaping (Int) -> Page) {
        self.titles = titles
        self._selectedIndex = selectedIndex
        self.segmentedHeight = segmentedHeight
        self.showsIndicator = showsIndicator
        self.customizer = customizer
        self.pageBuilder = page
    }

    public func makeUIViewController(context: Context) -> TFYSwiftListPagingHostController<Page> {
        TFYSwiftListPagingHostController(
            titles: titles,
            selectedIndex: selectedIndex,
            segmentedHeight: segmentedHeight,
            showsIndicator: showsIndicator,
            customizer: customizer,
            pageBuilder: pageBuilder
        )
    }

    public func updateUIViewController(_ uiViewController: TFYSwiftListPagingHostController<Page>, context: Context) {
        uiViewController.onIndexChange = { index in
            DispatchQueue.main.async {
                selectedIndex = index
            }
        }
        uiViewController.update(titles: titles,
                                selectedIndex: selectedIndex,
                                showsIndicator: showsIndicator,
                                customizer: customizer,
                                pageBuilder: pageBuilder)
    }
}

@available(iOS 15.0, *)
public final class TFYSwiftListPagingHostController<Page: View>: UIViewController,
                                                                  TFYSwiftListContainerViewDataSource,
                                                                  TFYSwiftViewDelegate {
    private let segmentedView = TFYSwiftView()
    private let dataSource = TFYSwiftTitleDataSource()
    private lazy var listContainerView = TFYSwiftListContainerView(dataSource: self)
    private var titles: [String]
    private var segmentedHeight: CGFloat
    private var showsIndicator: Bool
    private var customizer: TFYSwiftSegmentedView.Customizer?
    private var pageBuilder: (Int) -> Page
    private var lastAppliedIndex: Int = -1
    var onIndexChange: ((Int) -> Void)?

    public init(titles: [String],
                selectedIndex: Int,
                segmentedHeight: CGFloat,
                showsIndicator: Bool,
                customizer: TFYSwiftSegmentedView.Customizer?,
                pageBuilder: @escaping (Int) -> Page) {
        self.titles = titles
        self.segmentedHeight = segmentedHeight
        self.showsIndicator = showsIndicator
        self.customizer = customizer
        self.pageBuilder = pageBuilder
        super.init(nibName: nil, bundle: nil)
        dataSource.titles = titles
        dataSource.isTitleDynamicTypeEnabled = true
        segmentedView.dataSource = dataSource
        segmentedView.delegate = self
        segmentedView.defaultSelectedIndex = max(0, min(selectedIndex, max(titles.count - 1, 0)))
        if showsIndicator {
            segmentedView.indicators = [TFYSwiftIndicatorLineView()]
        }
        customizer?(segmentedView, dataSource)
        segmentedView.listContainer = listContainerView
    }

    required public init?(coder: NSCoder) { fatalError() }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(segmentedView)
        view.addSubview(listContainerView)
        listContainerView.isScrollEnabled = true
        segmentedView.reloadData()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let top = view.safeAreaInsets.top
        segmentedView.frame = CGRect(x: 0, y: top, width: view.bounds.width, height: segmentedHeight)
        listContainerView.frame = CGRect(x: 0,
                                         y: segmentedView.frame.maxY,
                                         width: view.bounds.width,
                                         height: view.bounds.height - segmentedView.frame.maxY)
    }

    func update(titles: [String],
                selectedIndex: Int,
                showsIndicator: Bool,
                customizer: TFYSwiftSegmentedView.Customizer?,
                pageBuilder: @escaping (Int) -> Page) {
        self.pageBuilder = pageBuilder
        self.customizer = customizer
        self.showsIndicator = showsIndicator
        if self.titles != titles {
            self.titles = titles
            dataSource.titles = titles
            customizer?(segmentedView, dataSource)
            segmentedView.reloadData()
            listContainerView.reloadData()
        }
        let clamped = max(0, min(selectedIndex, max(titles.count - 1, 0)))
        if clamped != lastAppliedIndex && clamped != segmentedView.selectedIndex {
            lastAppliedIndex = clamped
            segmentedView.selectItemAt(index: clamped, animated: true)
        }
    }

    public func numberOfLists(in listContainerView: TFYSwiftListContainerView) -> Int {
        titles.count
    }

    public func listContainerView(_ listContainerView: TFYSwiftListContainerView,
                                  initListAt index: Int) -> TFYSwiftListContainerViewListDelegate {
        // 不要在这里 addChild：ListContainer 会把返回的 UIViewController
        // 正确地挂到 containerVC 下。提前挂到 self 会导致滑动初始化时
        // UIHostingController 父子层级冲突闪退。
        return TFYSwiftHostingListController(rootView: pageBuilder(index))
    }

    public func segmentedView(_ segmentedView: TFYSwiftView, didSelectedItemAt index: Int) {
        lastAppliedIndex = index
        onIndexChange?(index)
    }
}

/// 作为 ListContainer 子 VC 的 SwiftUI 页面壳：自身可被 `addChild`，
/// 内部再托管 `UIHostingController`，保证 view 层级与 VC 父子一致。
@available(iOS 15.0, *)
private final class TFYSwiftHostingListController<Page: View>: UIViewController,
                                                                TFYSwiftListContainerViewListDelegate {
    private let host: UIHostingController<Page>

    init(rootView: Page) {
        self.host = UIHostingController(rootView: rootView)
        super.init(nibName: nil, bundle: nil)
        host.view.backgroundColor = .clear
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        addChild(host)
        host.view.frame = view.bounds
        host.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(host.view)
        host.didMove(toParent: self)
    }

    func listView() -> UIView { view }
}

#endif
