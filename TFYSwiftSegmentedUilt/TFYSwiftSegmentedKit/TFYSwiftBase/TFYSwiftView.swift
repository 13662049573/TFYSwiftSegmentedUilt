//
//  TFYSwiftView.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

public let TFYSwiftViewAutomaticDimension: CGFloat = -1

/// 选中item时的类型
///
/// - unknown: 不是选中
/// - code: 通过代码调用方法`func selectItemAt(index: Int)`选中
/// - click: 通过点击item选中
/// - scroll: 通过滚动到item选中
public enum TFYSwiftViewItemSelectedType {
    case unknown
    case code
    case click
    case scroll
}

public protocol TFYSwiftViewDataSource: AnyObject {
    var isItemWidthZoomEnabled: Bool { get }
    var selectedAnimationDuration: TimeInterval { get }
    var itemSpacing: CGFloat { get }
    var isItemSpacingAverageEnabled: Bool { get }

    func reloadData(selectedIndex: Int)

    /// 返回数据源数组，数组元素必须是TFYSwiftBaseItemModel及其子类
    ///
    /// - Parameter segmentedView: TFYSwiftView
    /// - Returns: 数据源数组
    func itemDataSource(in segmentedView: TFYSwiftView) -> [TFYSwiftBaseItemModel]

    /// 返回index对应item的宽度，等同于cell的宽度。
    ///
    /// - Parameters:
    ///   - segmentedView: TFYSwiftView
    ///   - index: 目标index
    /// - Returns: item的宽度
    func segmentedView(_ segmentedView: TFYSwiftView, widthForItemAt index: Int) -> CGFloat

    /// 返回index对应item的content宽度，等同于cell上面内容的宽度。与上面的代理方法不同，需要注意辨别。部分使用场景下，cell的宽度比较大，但是内容的宽度比较小。这个时候指示器又需要和item的content等宽。所以，添加了此代理方法。
    /// - Parameters:
    ///   - segmentedView: TFYSwiftView
    ///   - index: 目标index
    func segmentedView(_ segmentedView: TFYSwiftView, widthForItemContentAt index: Int) -> CGFloat

    /// 注册cell class
    ///
    /// - Parameter segmentedView: TFYSwiftView
    func registerCellClass(in segmentedView: TFYSwiftView)

    /// 返回index对应的cell
    ///
    /// - Parameters:
    ///   - segmentedView: TFYSwiftView
    ///   - index: 目标index
    /// - Returns: TFYSwiftBaseCell及其子类
    func segmentedView(_ segmentedView: TFYSwiftView, cellForItemAt index: Int) -> TFYSwiftBaseCell

    /// 根据当前选中的selectedIndex，刷新目标index的itemModel
    ///
    /// - Parameters:
    ///   - itemModel: TFYSwiftBaseItemModel
    ///   - index: 目标index
    ///   - selectedIndex: 当前选中的index
    func refreshItemModel(_ segmentedView: TFYSwiftView, _ itemModel: TFYSwiftBaseItemModel, at index: Int, selectedIndex: Int)

    /// item选中的时候调用。当前选中的currentSelectedItemModel状态需要更新为未选中；将要选中的willSelectedItemModel状态需要更新为选中。
    ///
    /// - Parameters:
    ///   - currentSelectedItemModel: 当前选中的itemModel
    ///   - willSelectedItemModel: 将要选中的itemModel
    ///   - selectedType: 选中的类型
    func refreshItemModel(_ segmentedView: TFYSwiftView, currentSelectedItemModel: TFYSwiftBaseItemModel, willSelectedItemModel: TFYSwiftBaseItemModel, selectedType: TFYSwiftViewItemSelectedType)

    /// 左右滚动过渡时调用。根据当前的从左到右的百分比，刷新leftItemModel和rightItemModel
    ///
    /// - Parameters:
    ///   - leftItemModel: 相对位置在左边的itemModel
    ///   - rightItemModel: 相对位置在右边的itemModel
    ///   - percent: 从左到右的百分比
    func refreshItemModel(_ segmentedView: TFYSwiftView, leftItemModel: TFYSwiftBaseItemModel, rightItemModel: TFYSwiftBaseItemModel, percent: CGFloat)
}

/// 为什么会把选中代理分为三个，因为有时候只关心点击选中的，有时候只关心滚动选中的，有时候只关心选中。所以具体情况，使用对应方法。
public protocol TFYSwiftViewDelegate: AnyObject {
    /// 点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，而不关心具体是点击还是滚动选中的情况。
    ///
    /// - Parameters:
    ///   - segmentedView: TFYSwiftView
    ///   - index: 选中的index
    func segmentedView(_ segmentedView: TFYSwiftView, didSelectedItemAt index: Int)

    /// 点击选中的情况才会调用该方法
    ///
    /// - Parameters:
    ///   - segmentedView: TFYSwiftView
    ///   - index: 选中的index
    func segmentedView(_ segmentedView: TFYSwiftView, didClickSelectedItemAt index: Int)

    /// 滚动选中的情况才会调用该方法
    ///
    /// - Parameters:
    ///   - segmentedView: TFYSwiftView
    ///   - index: 选中的index
    func segmentedView(_ segmentedView: TFYSwiftView, didScrollSelectedItemAt index: Int)

    /// 正在滚动中的回调
    ///
    /// - Parameters:
    ///   - segmentedView: TFYSwiftView
    ///   - leftIndex: 正在滚动中，相对位置处于左边的index
    ///   - rightIndex: 正在滚动中，相对位置处于右边的index
    ///   - percent: 从左往右计算的百分比
    func segmentedView(_ segmentedView: TFYSwiftView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat)


    /// 是否允许点击选中目标index的item
    ///
    /// - Parameters:
    ///   - segmentedView: TFYSwiftView
    ///   - index: 目标index
    func segmentedView(_ segmentedView: TFYSwiftView, canClickItemAt index: Int) -> Bool
}

/// 提供TFYSwiftViewDelegate的默认实现，这样对于遵从TFYSwiftViewDelegate的类来说，所有代理方法都是可选实现的。
public extension TFYSwiftViewDelegate {
    func segmentedView(_ segmentedView: TFYSwiftView, didSelectedItemAt index: Int) { }
    func segmentedView(_ segmentedView: TFYSwiftView, didClickSelectedItemAt index: Int) { }
    func segmentedView(_ segmentedView: TFYSwiftView, didScrollSelectedItemAt index: Int) { }
    func segmentedView(_ segmentedView: TFYSwiftView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) { }
    func segmentedView(_ segmentedView: TFYSwiftView, canClickItemAt index: Int) -> Bool { return true }
}

/// 内部会自己找到父UIViewController，然后将其automaticallyAdjustsScrollViewInsets设置为false，这一点请知晓。
open class TFYSwiftView: UIView, TFYSwiftViewRTLCompatible {
    open weak var dataSource: TFYSwiftViewDataSource? {
        didSet {
            dataSource?.registerCellClass(in: self)
            dataSource?.reloadData(selectedIndex: selectedIndex)
        }
    }
    open weak var delegate: TFYSwiftViewDelegate?
    open private(set) var collectionView: TFYSwiftCollectionView!
    open var contentScrollView: UIScrollView? {
        didSet {
            if oldValue !== contentScrollView {
                contentScrollObservation?.invalidate()
                contentScrollObservation = nil
                contentScrollDelegateMux?.uninstall()
                contentScrollDelegateMux = nil
                oldValue?.scrollsToTop = true
            }
            contentScrollView?.scrollsToTop = false
            observeContentScrollViewIfNeeded()
        }
    }
    public var listContainer: TFYSwiftViewListContainer? = nil {
        didSet {
            listContainer?.defaultSelectedIndex = defaultSelectedIndex
            contentScrollView = listContainer?.contentScrollView()
        }
    }
    /// indicators的元素必须是遵从TFYSwiftIndicatorProtocol协议的UIView及其子类
    open var indicators = [TFYSwiftIndicatorProtocol]() {
        didSet {
            collectionView.indicators = indicators
        }
    }
    /// 初始化或者reloadData之前设置，用于指定默认的index。
    /// 非法负值会被自动 clamp 为 0；超出 item 数量的 index 会在 reloadData 中再次 clamp。
    open var defaultSelectedIndex: Int = 0 {
        didSet {
            if defaultSelectedIndex < 0 {
                defaultSelectedIndex = 0
                return
            }
            selectedIndex = defaultSelectedIndex
            if listContainer != nil {
                listContainer?.defaultSelectedIndex = defaultSelectedIndex
            }
        }
    }
    open private(set) var selectedIndex: Int = 0
    /// 整体内容的左边距，默认TFYSwiftViewAutomaticDimension（等于itemSpacing）
    open var contentEdgeInsetLeft: CGFloat = TFYSwiftViewAutomaticDimension
    /// 整体内容的右边距，默认TFYSwiftViewAutomaticDimension（等于itemSpacing）
    open var contentEdgeInsetRight: CGFloat = TFYSwiftViewAutomaticDimension
    /// 点击切换的时候，contentScrollView的切换是否需要动画
    open var isContentScrollViewClickTransitionAnimationEnabled: Bool = true
    /// 再次点击已选中 item 时是否允许取消选中（隐藏指示器、清除选中态）。默认 false。
    open var allowsDeselection: Bool = false
    /// 点击仅触发回调、不改变选中态（类似 `UISegmentedControl` momentary）。默认 false。
    open var isMomentary: Bool = false
    /// 左侧附属视图（筛选 / 返回等），会挤压 `collectionView` 可用宽度。
    open var leadingAccessoryView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let leadingAccessoryView {
                addSubview(leadingAccessoryView)
            }
            setNeedsLayout()
        }
    }
    /// 右侧附属视图（更多 / 搜索等）。
    open var trailingAccessoryView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let trailingAccessoryView {
                addSubview(trailingAccessoryView)
            }
            setNeedsLayout()
        }
    }
    /// 附属视图与 `collectionView` 之间的间距。
    open var accessorySpacing: CGFloat = 8
    /// 滑动是否禁止
    open var isScrollEnabled:Bool = true {
        didSet {
            self.collectionView.isScrollEnabled = isScrollEnabled
        }
    }
    /// 是否启用 UICollectionView 预取（默认 false，保持历史默认行为）。
    /// 大多数业务下 item 数量有限、宽度动态变化，关闭预取可以避免无谓刷新；
    /// 若 item 非常多且稳定，可按需打开以提升首屏显示。
    open var isPrefetchingEnabled: Bool = false {
        didSet {
            collectionView.isPrefetchingEnabled = isPrefetchingEnabled
        }
    }
    /// KVO 联动过渡时的最小变化阈值（百分比）。小于该值的微小偏移变化会被忽略，降低高频重绘压力。
    /// 默认 `0.001`，在 ProMotion 设备上过滤亚像素抖动；设为 `0` 可恢复逐帧回调。
    open var contentScrollViewTransitionEpsilon: CGFloat = 0.001

    /// 是否在 reloadData 阶段使用 `UICollectionViewDiffableDataSource` 作为底层驱动（默认 false）。
    ///
    /// 启用后内部会将 `collectionView.dataSource` 切换为一个只读的 diffable snapshot，cellProvider
    /// 仍会走 `TFYSwiftViewDataSource` 的 `cellForItemAt`，以保持现有 cell 注册和样式兼容。
    /// 如遇兼容性问题，可动态 toggle 到 false 回退到旧的 `UICollectionViewDataSource` 路径。
    ///
    /// 注意：当前版本 diffable 仅用于替代 reloadData 的“段位刷新”，所有自定义 frame/insets 仍由
    /// `TFYSwiftViewFlowLayout`/`TFYSwiftView` 自身计算。
    open var isDiffableDataSourceEnabled: Bool = false {
        didSet {
            guard oldValue != isDiffableDataSourceEnabled else { return }
            tfy_installDiffableDataSourceIfNeeded()
            reloadData()
        }
    }

    private enum TFYSwiftDiffableSection: Int, Hashable { case main }
    private var diffableDataSource: UICollectionViewDiffableDataSource<TFYSwiftDiffableSection, Int>?

    /// 是否启用点击/滚动吸附切换时的触感反馈（`UISelectionFeedbackGenerator`）。默认 false。
    open var isHapticEnabled: Bool = false

    /// 是否尊重 `UIAccessibility.isReduceMotionEnabled`：启用后，在系统 Reduce Motion 场景会
    /// 自动将 `contentScrollView` 切换动画禁用，并把指示器的默认 `scrollAnimationDuration` 设为 0。
    /// 默认 true，符合 iOS HIG 建议。
    open var isRespectReduceMotionEnabled: Bool = true

    /// 是否启用 Context Menu（长按菜单）。需同时设置 `contextMenuProvider`。
    open var isContextMenuEnabled: Bool = false

    /// Context Menu 生成器；返回 nil 表示该 index 不展示菜单。
    ///
    /// 示例：
    /// ```swift
    /// segmentedView.isContextMenuEnabled = true
    /// segmentedView.contextMenuProvider = { index, model in
    ///     UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
    ///         UIMenu(title: "", children: [
    ///             UIAction(title: "Pin", image: UIImage(systemName: "pin")) { _ in /* ... */ }
    ///         ])
    ///     }
    /// }
    /// ```
    public var contextMenuProvider: ((_ index: Int, _ itemModel: TFYSwiftBaseItemModel) -> UIContextMenuConfiguration?)? = nil

    /// 是否启用 cell 的拖拽重排。启用后用户长按一个分段并拖动即可调整顺序，拖放结束时
    /// 会回调 `didReorderItem`，业务方需要同步更新自己的数据源并 `reloadData()`。
    ///
    /// - Important: 底层使用 `UICollectionView.beginInteractiveMovementForItem(at:)` 系列 API，
    ///              要求数据源最终也要产生与重排一致的顺序，否则下一次 reloadData 会回退。
    open var isReorderingEnabled: Bool = false {
        didSet {
            guard oldValue != isReorderingEnabled else { return }
            collectionView.reorderingCadence = .immediate
            installReorderGestureIfNeeded()
            reorderLongPressGesture?.isEnabled = isReorderingEnabled
        }
    }

    /// 长按触发拖拽的最小时长（秒）。默认 0.35，业务方可按需调整。
    open var reorderMinimumPressDuration: TimeInterval = 0.35 {
        didSet { reorderLongPressGesture?.minimumPressDuration = reorderMinimumPressDuration }
    }

    /// 拖拽重排结束后的回调：`(fromIndex, toIndex)`。
    public var didReorderItem: ((_ fromIndex: Int, _ toIndex: Int) -> Void)? = nil

    private weak var reorderLongPressGesture: UILongPressGestureRecognizer?

    private var itemDataSource = [TFYSwiftBaseItemModel]()
    private var innerItemSpacing: CGFloat = 0
    private var lastContentOffset: CGPoint = CGPoint.zero
    private var contentScrollObservation: NSKeyValueObservation?
    /// 正在滚动中的目标index。用于处理正在滚动列表的时候，立即点击item，会导致界面显示异常。
    private var scrollingTargetIndex: Int = -1
    private var isFirstLayoutSubviews = true
    /// 当前是否处于“已取消选中”状态（`allowsDeselection`）。
    private var isSelectionCleared = false
    /// 代码/点击驱动 `contentScrollView.setContentOffset` 期间屏蔽 KVO 联动，
    /// 避免跨多页动画中途误选中（尤其是中间有禁用 item 时指示器被“吃掉”）。
    private var suppressContentScrollCallback = false
    /// 转发 contentScrollView 的 willEndDragging，用于把禁用页的停靠目标改写到最近可选项。
    private var contentScrollDelegateMux: TFYSwiftScrollDelegateMultiplexer?

    // MARK: - 布局缓存
    // 累积 item 起始 x 偏移缓存：itemStartXCache[i] = item i 的左边界（含 contentInset）
    // 仅在 reloadData 或 innerItemSpacing / itemWidth 发生变化时刷新，保证 getItemFrameAt 为 O(1)。
    private var itemStartXCache: [CGFloat] = []
    private var totalContentWidthCache: CGFloat = 0
    private var lastTransitionProgress: CGFloat = -1

    deinit {
        contentScrollObservation?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = TFYSwiftCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TFYSwiftViewInnerEmptyCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPrefetchingEnabled = isPrefetchingEnabled
        collectionView.contentInsetAdjustmentBehavior = .never
        if segmentedViewShouldRTLLayout() {
            collectionView.semanticContentAttribute = .forceLeftToRight
            segmentedView(horizontalFlipForView: collectionView)
        }
        addSubview(collectionView)

        // Dynamic Type：系统字号变化时自动重排。数据源开启 `isTitleDynamicTypeEnabled` 才实际影响字号，
        // 但 reload 是无损操作，放在基类里对所有数据源都安全。
        // 文本宽度缓存与字号强绑定，必须在同一回调里失效，避免截断。
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tfy_handleContentSizeCategoryDidChange),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }

    @objc private func tfy_handleContentSizeCategoryDidChange() {
        TFYSwiftTextMeasure.shared.invalidate()
        // superview 还没挂载时不急着刷新，避免不必要的 layout。
        guard superview != nil, dataSource != nil else { return }
        reloadData()
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        // 早期 iOS 版本（< 11）需要关闭父 VC 的 automaticallyAdjustsScrollViewInsets 以避免 inset 偏移。
        // 本库最低支持 iOS 15，因此保留空实现仅用于未来扩展钩子。
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        //部分使用者为了适配不同的手机屏幕尺寸，TFYSwiftView的宽高比要求保持一样。所以它的高度就会因为不同宽度的屏幕而不一样。计算出来的高度，有时候会是位数很长的浮点数，如果把这个高度设置给UICollectionView就会触发内部的一个错误。所以，为了规避这个问题，在这里对高度统一向下取整。
        //如果向下取整导致了你的页面异常，请自己重新设置TFYSwiftView的高度，保证为整数即可。
        let height = floor(bounds.size.height)
        var collectionX: CGFloat = 0
        var collectionWidth = bounds.size.width

        if let leading = leadingAccessoryView {
            let size = leading.bounds.size == .zero
                ? leading.systemLayoutSizeFitting(CGSize(width: UIView.layoutFittingCompressedSize.width,
                                                        height: height))
                : leading.bounds.size
            let w = size.width > 0 ? size.width : height
            leading.frame = CGRect(x: 0, y: 0, width: w, height: height)
            collectionX = w + accessorySpacing
            collectionWidth -= collectionX
        }
        if let trailing = trailingAccessoryView {
            let size = trailing.bounds.size == .zero
                ? trailing.systemLayoutSizeFitting(CGSize(width: UIView.layoutFittingCompressedSize.width,
                                                         height: height))
                : trailing.bounds.size
            let w = size.width > 0 ? size.width : height
            trailing.frame = CGRect(x: bounds.size.width - w, y: 0, width: w, height: height)
            collectionWidth -= (w + accessorySpacing)
        }
        collectionWidth = max(collectionWidth, 0)
        let targetFrame = CGRect(x: collectionX, y: 0, width: collectionWidth, height: height)
        if isFirstLayoutSubviews {
            isFirstLayoutSubviews = false
            collectionView.frame = targetFrame
            reloadDataWithoutListContainer()
        }else {
            if collectionView.frame != targetFrame {
                collectionView.frame = targetFrame
                rebuildItemStartXCache()
                collectionView.collectionViewLayout.invalidateLayout()
                // 仅失效布局；避免 bounds 变化时整表 reloadData 造成闪烁与多余 cell 重建。
                if !indicators.isEmpty, !isSelectionCleared, itemDataSource.indices.contains(selectedIndex) {
                    let selectedItemFrame = getSelectedItemFrameAt(index: selectedIndex)
                    let contentWidth = currentItemContentWidth(at: selectedIndex)
                    let params = TFYSwiftIndicatorSelectedParams(
                        currentSelectedIndex: selectedIndex,
                        currentSelectedItemFrame: selectedItemFrame,
                        selectedType: .unknown,
                        currentItemContentWidth: contentWidth,
                        collectionViewContentSize: CGSize(width: totalContentWidthCache, height: bounds.size.height)
                    )
                    for indicator in indicators {
                        indicator.refreshIndicatorState(model: params)
                    }
                }
            }
        }
    }

    //MARK: - Public
    /// 从复用池中出队一个 `TFYSwiftBaseCell` 子类实例。
    /// - Note: 历史版本在类型不匹配时直接 `fatalError`，在生产环境会导致崩溃。
    ///   现改为 `assertionFailure` + 降级返回一个空壳 `TFYSwiftBaseCell`，
    ///   同时补发一条控制台日志，便于开发者在 Debug 包中排查。
    public final func dequeueReusableCell(withReuseIdentifier identifier: String, at index: Int) -> TFYSwiftBaseCell {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let baseCell = cell as? TFYSwiftBaseCell {
            return baseCell
        }
        assertionFailure("[TFYSwiftSegmentedKit] Cell(identifier: \(identifier)) 必须是 TFYSwiftBaseCell 的子类。收到: \(type(of: cell))。请检查 registerCellClass(in:) 实现。")
        #if DEBUG
        print("[TFYSwiftSegmentedKit][WARN] dequeueReusableCell fallback at index=\(index), identifier=\(identifier)")
        #endif
        // 生产环境降级：返回一个临时的空壳 cell，避免整个列表崩溃
        return TFYSwiftBaseCell(frame: cell.frame)
    }

    open func reloadData() {
        reloadDataWithoutListContainer()
        listContainer?.reloadData()
    }

    /// 过渡过程中 item 宽度变化时调用：重建起点缓存，并尽量只失效相关 item 的布局。
    /// - Parameter indices: 宽度发生变化的 item 索引；为空时整表失效。
    open func invalidateItemLayout(at indices: [Int]) {
        rebuildItemStartXCache()
        let paths = indices
            .filter { itemDataSource.indices.contains($0) }
            .map { IndexPath(item: $0, section: 0) }
        if paths.isEmpty {
            collectionView.collectionViewLayout.invalidateLayout()
            return
        }
        let context = UICollectionViewFlowLayoutInvalidationContext()
        context.invalidateItems(at: paths)
        context.invalidateFlowLayoutDelegateMetrics = true
        collectionView.collectionViewLayout.invalidateLayout(with: context)
    }

    open func reloadDataWithoutListContainer() {
        let signpost = TFYSwiftDiagnostics.shared.beginSignpost(name: "reloadData", message: "selected=\(selectedIndex)")
        defer { TFYSwiftDiagnostics.shared.endSignpost(name: "reloadData", id: signpost) }
        dataSource?.reloadData(selectedIndex: selectedIndex)
        itemDataSource = dataSource?.itemDataSource(in: self) ?? []

        guard !itemDataSource.isEmpty else {
            selectedIndex = 0
            lastContentOffset = .zero
            lastTransitionProgress = -1
            itemStartXCache = []
            totalContentWidthCache = 0
            indicators.forEach { $0.isHidden = true }
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.reloadData()
            contentScrollView?.setContentOffset(.zero, animated: false)
            return
        }

        if !itemDataSource.indices.contains(selectedIndex) {
            let clampedDefaultIndex = min(max(defaultSelectedIndex, 0), itemDataSource.count - 1)
            defaultSelectedIndex = clampedDefaultIndex
            selectedIndex = clampedDefaultIndex
        }

        innerItemSpacing = dataSource?.itemSpacing ?? 0
        var totalItemWidth: CGFloat = 0
        var totalContentWidth: CGFloat = getContentEdgeInsetLeft()
        let availableWidth = collectionView.bounds.width > 0 ? collectionView.bounds.width : bounds.size.width
        let useEqualWidth = (dataSource as? TFYSwiftBaseDataSource)?.itemWidthMode == .equal
            && availableWidth > 0
            && !itemDataSource.isEmpty
        let equalWidth: CGFloat = {
            guard useEqualWidth else { return 0 }
            let count = CGFloat(itemDataSource.count)
            let spacingTotal = innerItemSpacing * max(count - 1, 0)
            let insetTotal = getContentEdgeInsetLeft() + getContentEdgeInsetRight()
            return max((availableWidth - spacingTotal - insetTotal) / count, 0)
        }()

        for (index, itemModel) in itemDataSource.enumerated() {
            itemModel.index = index
            if useEqualWidth {
                itemModel.itemWidth = equalWidth
            } else {
                itemModel.itemWidth = (dataSource?.segmentedView(self, widthForItemAt: index) ?? 0)
                if dataSource?.isItemWidthZoomEnabled == true {
                    itemModel.itemWidth *= itemModel.itemWidthCurrentZoomScale
                }
            }
            itemModel.isSelected = !isSelectionCleared && (index == selectedIndex)
            totalItemWidth += itemModel.itemWidth
            if index == itemDataSource.count - 1 {
                totalContentWidth += itemModel.itemWidth + getContentEdgeInsetRight()
            }else {
                totalContentWidth += itemModel.itemWidth + innerItemSpacing
            }
        }

        if !useEqualWidth, dataSource?.isItemSpacingAverageEnabled == true && totalContentWidth < availableWidth {
            var itemSpacingCount = itemDataSource.count - 1
            var totalItemSpacingWidth = availableWidth - totalItemWidth
            if contentEdgeInsetLeft == TFYSwiftViewAutomaticDimension {
                itemSpacingCount += 1
            }else {
                totalItemSpacingWidth -= contentEdgeInsetLeft
            }
            if contentEdgeInsetRight == TFYSwiftViewAutomaticDimension {
                itemSpacingCount += 1
            }else {
                totalItemSpacingWidth -= contentEdgeInsetRight
            }
            if itemSpacingCount > 0 {
                innerItemSpacing = totalItemSpacingWidth / CGFloat(itemSpacingCount)
            }
        }

        // 一次遍历同时构建累积起点缓存 + 计算总内容宽度 + 当前选中 item 的 frame 数据
        rebuildItemStartXCache()
        totalContentWidth = totalContentWidthCache

        var selectedItemFrameX = getContentEdgeInsetLeft()
        var selectedItemWidth: CGFloat = 0
        if let startX = itemStartXCache[safe: selectedIndex], let model = itemDataSource[safe: selectedIndex] {
            selectedItemFrameX = startX
            selectedItemWidth = model.itemWidth
        }

        let minX: CGFloat = 0
        let maxX = totalContentWidth - bounds.size.width
        let targetX = selectedItemFrameX - bounds.size.width/2 + selectedItemWidth/2
        collectionView.setContentOffset(CGPoint(x: max(min(maxX, targetX), minX), y: 0), animated: false)

        if let contentScrollView {
            if contentScrollView.frame.equalTo(CGRect.zero) &&
                contentScrollView.superview != nil {
                //某些情况系统会出现TFYSwiftView先布局，contentScrollView后布局。就会导致下面指定defaultSelectedIndex失效，所以发现contentScrollView的frame为zero时，强行触发其父视图链里面已经有frame的一个父视图的layoutSubviews方法。
                //比如TFYSwiftListContainerView会将contentScrollView包裹起来使用，该情况需要TFYSwiftListContainerView.superView触发布局更新
                var parentView = contentScrollView.superview
                while parentView != nil && parentView?.frame.equalTo(CGRect.zero) == true {
                    parentView = parentView?.superview
                }
                parentView?.setNeedsLayout()
                parentView?.layoutIfNeeded()
            }

            let targetOffsetX = CGFloat(selectedIndex) * contentScrollView.bounds.size.width
            contentScrollView.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: false)
        }

        for indicator in indicators {
            if itemDataSource.isEmpty || isSelectionCleared {
                indicator.isHidden = true
            }else {
                indicator.isHidden = false
                let selectedItemFrame = getItemFrameAt(index: selectedIndex)
                let indicatorParams = TFYSwiftIndicatorSelectedParams(currentSelectedIndex: selectedIndex,
                                                                         currentSelectedItemFrame: selectedItemFrame,
                                                                         selectedType: .unknown,
                                                                         currentItemContentWidth: dataSource?.segmentedView(self, widthForItemContentAt: selectedIndex) ?? 0,
                                                                         collectionViewContentSize: CGSize(width: totalContentWidth, height: bounds.size.height))
                indicator.refreshIndicatorState(model: indicatorParams)

                if indicator.isIndicatorConvertToItemFrameEnabled {
                    var indicatorConvertToItemFrame = indicator.frame
                    indicatorConvertToItemFrame.origin.x -= selectedItemFrame.origin.x
                    itemDataSource[selectedIndex].indicatorConvertToItemFrame = indicatorConvertToItemFrame
                }
            }
        }
        collectionView.collectionViewLayout.invalidateLayout()
        if isDiffableDataSourceEnabled, let diff = diffableDataSource {
            var snapshot = NSDiffableDataSourceSnapshot<TFYSwiftDiffableSection, Int>()
            snapshot.appendSections([.main])
            snapshot.appendItems(Array(0..<itemDataSource.count), toSection: .main)
            diff.apply(snapshot, animatingDifferences: false)
        } else {
            collectionView.reloadData()
        }
    }

    /// 安装或卸载 diffable data source。切换后 collectionView.dataSource 会在两个实现间切换。
    private func tfy_installDiffableDataSourceIfNeeded() {
        if isDiffableDataSourceEnabled {
            if diffableDataSource != nil { return }
            let diff = UICollectionViewDiffableDataSource<TFYSwiftDiffableSection, Int>(collectionView: collectionView) { [weak self] (_, indexPath, index) -> UICollectionViewCell? in
                guard let self = self else { return nil }
                guard let ds = self.dataSource, index < self.itemDataSource.count else {
                    return self.collectionView.dequeueReusableCell(withReuseIdentifier: "TFYSwiftViewInnerEmptyCell", for: indexPath)
                }
                let cell = ds.segmentedView(self, cellForItemAt: index)
                let itemModel = self.itemDataSource[index]
                cell.reloadData(itemModel: itemModel, selectedType: .unknown)
                return cell
            }
            self.diffableDataSource = diff
            collectionView.dataSource = diff
        } else {
            self.diffableDataSource = nil
            collectionView.dataSource = self
        }
    }

    /// 当前分段数量。
    open var itemCount: Int {
        return itemDataSource.count
    }

    /// 判断index是否在当前数据范围内。
    open func isValidIndex(_ index: Int) -> Bool {
        return itemDataSource.indices.contains(index)
    }

    /// 获取指定index的itemModel，越界时返回nil。
    open func itemModel(at index: Int) -> TFYSwiftBaseItemModel? {
        return itemDataSource[safe: index]
    }

    /// 获取当前可见的cell，未显示或越界时返回nil。
    open func visibleCell(at index: Int) -> TFYSwiftBaseCell? {
        guard isValidIndex(index) else { return nil }
        return collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? TFYSwiftBaseCell
    }

    open func reloadItem(at index: Int) {
        guard index >= 0 && index < itemDataSource.count else {
            return
        }

        let didUpdateWidth = refreshItem(at: index, selectedType: .unknown)
        if didUpdateWidth {
            collectionView.collectionViewLayout.invalidateLayout()
            centerCollectionView(on: selectedIndex, animated: false)
        }
    }

    /// 批量刷新指定index的itemModel和可见cell，自动过滤重复及越界index。
    open func reloadItems(at indexes: [Int]) {
        let validIndexes = Array(Set(indexes.filter { isValidIndex($0) })).sorted()
        guard !validIndexes.isEmpty else { return }

        var didUpdateWidth = false
        validIndexes.forEach { index in
            didUpdateWidth = refreshItem(at: index, selectedType: .unknown) || didUpdateWidth
        }
        if didUpdateWidth {
            collectionView.collectionViewLayout.invalidateLayout()
            centerCollectionView(on: selectedIndex, animated: false)
        }
    }

    /// 将当前选中item滚动到可视区域中间。
    open func scrollToSelectedItem(animated: Bool = true) {
        centerCollectionView(on: selectedIndex, animated: animated)
    }

    /// 代码选中指定index
    /// 如果要同时触发列表容器对应index的列表加载，请再调用`listContainerView.didClickSelectedItem(at: index)`方法
    ///
    /// - Parameter index: 目标index
    open func selectItemAt(index: Int) {
        selectItemAt(index: index, selectedType: .code)
    }

    /// 代码选中指定index，并可控制内部滚动动画。
    open func selectItemAt(index: Int, animated: Bool) {
        selectItemAt(index: index, selectedType: .code, collectionViewAnimated: animated, contentScrollViewAnimated: animated)
    }

    //MARK: - Private
    private func clickSelectItemAt(index: Int) {
        guard delegate?.segmentedView(self, canClickItemAt: index) != false else {
            return
        }
        guard itemDataSource[safe: index]?.isItemEnabled != false else {
            return
        }
        selectItemAt(index: index, selectedType: .click)
    }

    private func scrollSelectItemAt(index: Int) {
        // 停靠瞬间 contentOffset 与 lastContentOffset 几乎相等，delta≈0 会误判方向；
        // 优先用真实位移，否则用「落地页相对当前选中」推断滑动意图。
        let offsetDelta = (contentScrollView?.contentOffset.x ?? lastContentOffset.x) - lastContentOffset.x
        let direction: Int
        if abs(offsetDelta) > 0.5 {
            direction = offsetDelta > 0 ? 1 : -1
        } else if index != selectedIndex {
            direction = index > selectedIndex ? 1 : -1
        } else if scrollingTargetIndex >= 0 {
            direction = scrollingTargetIndex >= selectedIndex ? 1 : -1
        } else {
            direction = 0
        }

        // 禁用页：只跳到滑动方向上「相邻」的启用项，避免一次跨过关注落到推荐。
        let target: Int
        if itemDataSource.indices.contains(index), itemDataSource[index].isItemEnabled {
            target = index
        } else {
            target = adjacentEnabledIndex(from: selectedIndex, direction: direction)
                ?? nearestEnabledIndex(around: index, scrollDelta: CGFloat(direction))
                ?? index
        }

        let needsContentSnap: Bool = {
            guard let contentScrollView, contentScrollView.bounds.width > 0 else { return false }
            let currentPage = Int(round(contentScrollView.contentOffset.x / contentScrollView.bounds.width))
            return currentPage != target || target != index
        }()
        if needsContentSnap {
            tfy_snapContentScroll(to: target, animated: false)
        }
        if target == selectedIndex && !isSelectionCleared {
            tfy_refreshSelectedPresentation(at: target)
            scrollingTargetIndex = -1
            return
        }
        selectItemAt(index: target, selectedType: .scroll)
    }

    /// 清除当前选中态（配合 `allowsDeselection`）。
    open func clearSelection() {
        guard !isSelectionCleared, itemDataSource.indices.contains(selectedIndex) else {
            isSelectionCleared = true
            indicators.forEach { $0.isHidden = true }
            return
        }
        let model = itemDataSource[selectedIndex]
        model.isSelected = false
        if let cell = collectionView.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) as? TFYSwiftBaseCell {
            cell.reloadData(itemModel: model, selectedType: .code)
        }
        indicators.forEach { $0.isHidden = true }
        isSelectionCleared = true
    }

    /// 从 `from` 起沿 direction 找下一个启用项（只走一步，不跨多个启用项）。
    private func adjacentEnabledIndex(from index: Int, direction: Int) -> Int? {
        guard direction != 0 else { return nil }
        if direction > 0 {
            for i in (index + 1)..<itemDataSource.count where itemDataSource[i].isItemEnabled {
                return i
            }
        } else {
            for i in stride(from: index - 1, through: 0, by: -1) where itemDataSource[i].isItemEnabled {
                return i
            }
        }
        return nil
    }

    /// - Parameter scrollDelta: >0 表示向右翻页（更高 index），优先选右侧可选项。
    private func nearestEnabledIndex(around index: Int, scrollDelta: CGFloat = 0) -> Int? {
        guard itemDataSource.indices.contains(index) else { return nil }
        if itemDataSource[index].isItemEnabled { return index }

        if scrollDelta > 0 {
            for i in (index + 1)..<itemDataSource.count where itemDataSource[i].isItemEnabled {
                return i
            }
            for i in stride(from: index - 1, through: 0, by: -1) where itemDataSource[i].isItemEnabled {
                return i
            }
        } else if scrollDelta < 0 {
            for i in stride(from: index - 1, through: 0, by: -1) where itemDataSource[i].isItemEnabled {
                return i
            }
            for i in (index + 1)..<itemDataSource.count where itemDataSource[i].isItemEnabled {
                return i
            }
        } else {
            for distance in 1..<itemDataSource.count {
                let left = index - distance
                let right = index + distance
                if itemDataSource.indices.contains(left), itemDataSource[left].isItemEnabled {
                    return left
                }
                if itemDataSource.indices.contains(right), itemDataSource[right].isItemEnabled {
                    return right
                }
            }
        }
        return nil
    }

    /// 把内容列表吸附到指定页（用于跳过禁用项）。
    private func tfy_snapContentScroll(to index: Int, animated: Bool) {
        guard let contentScrollView, contentScrollView.bounds.width > 0 else { return }
        let targetX = CGFloat(index) * contentScrollView.bounds.width
        guard abs(contentScrollView.contentOffset.x - targetX) > 0.5 else { return }

        suppressContentScrollCallback = true
        // 正在拖/减速时直接 animated 跳页会被 UIKit 吃掉，先钉住当前 offset 打断惯性。
        if contentScrollView.isDragging || contentScrollView.isDecelerating {
            contentScrollView.setContentOffset(contentScrollView.contentOffset, animated: false)
        }
        contentScrollView.setContentOffset(CGPoint(x: targetX, y: 0), animated: animated)
        lastContentOffset = CGPoint(x: targetX, y: 0)
        lastTransitionProgress = CGFloat(index)
        listContainer?.didClickSelectedItem(at: index)

        if animated {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.suppressContentScrollCallback = false
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.suppressContentScrollCallback = false
            }
        }
    }

    /// 强制把标题栏选中态 / 指示器拉回指定已启用项（不改 selectedIndex）。
    private func tfy_refreshSelectedPresentation(at index: Int) {
        guard itemDataSource.indices.contains(index) else { return }
        // 滑动半途的 percent 会改写左右 item 的颜色/缩放，这里整页刷回正常选中态。
        for (i, model) in itemDataSource.enumerated() {
            dataSource?.refreshItemModel(self, model, at: i, selectedIndex: index)
            model.isSelected = (i == index)
            if let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? TFYSwiftBaseCell {
                cell.reloadData(itemModel: model, selectedType: .scroll)
            }
        }
        tfy_pinIndicators(to: index)
    }

    private func selectItemAt(index: Int, selectedType: TFYSwiftViewItemSelectedType, collectionViewAnimated: Bool = true, contentScrollViewAnimated: Bool? = nil) {
        guard index >= 0 && index < itemDataSource.count else {
            return
        }
        guard itemDataSource[index].isItemEnabled || selectedType == .scroll || selectedType == .code else {
            return
        }

        // Momentary：只回调，不改变选中态 / 列表偏移。
        if isMomentary && selectedType == .click {
            if isHapticEnabled {
                TFYSwiftHapticEngine.shared.selectionChanged()
            }
            delegate?.segmentedView(self, didClickSelectedItemAt: index)
            tfy_emit_didClickSelect(index: index)
            delegate?.segmentedView(self, didSelectedItemAt: index)
            tfy_emit_didSelect(index: index)
            return
        }

        // 触发触感反馈：仅在 index 真正发生变化，且用户启用了开关时触发。
        if isHapticEnabled && (index != selectedIndex || isSelectionCleared) {
            TFYSwiftHapticEngine.shared.selectionChanged()
        }

        if index == selectedIndex && !isSelectionCleared {
            if selectedType == .click && allowsDeselection {
                clearSelection()
                return
            }
            if selectedType == .code {
                listContainer?.didClickSelectedItem(at: index)
            }else if selectedType == .click {
                delegate?.segmentedView(self, didClickSelectedItemAt: index)
                tfy_emit_didClickSelect(index: index)
                listContainer?.didClickSelectedItem(at: index)
            }else if selectedType == .scroll {
                // 跨禁用页滑动后 selectedIndex 可能已提前更新，但指示器仍停在禁用项。
                tfy_refreshSelectedPresentation(at: index)
                delegate?.segmentedView(self, didScrollSelectedItemAt: index)
                tfy_emit_didScrollSelect(index: index)
            }
            delegate?.segmentedView(self, didSelectedItemAt: index)
            tfy_emit_didSelect(index: index)
            scrollingTargetIndex = -1
            return
        }

        // 从 cleared 状态重新选中同一 index：当作正常选中流程。
        if isSelectionCleared && index == selectedIndex {
            isSelectionCleared = false
            itemDataSource[index].isSelected = true
            if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? TFYSwiftBaseCell {
                cell.reloadData(itemModel: itemDataSource[index], selectedType: selectedType)
            }
            let selectedItemFrame = getSelectedItemFrameAt(index: index)
            let params = TFYSwiftIndicatorSelectedParams(
                currentSelectedIndex: index,
                currentSelectedItemFrame: selectedItemFrame,
                selectedType: selectedType,
                currentItemContentWidth: currentItemContentWidth(at: index),
                collectionViewContentSize: CGSize(width: totalContentWidthCache, height: bounds.size.height)
            )
            for indicator in indicators {
                indicator.isHidden = false
                indicator.selectItem(model: params)
            }
            tfy_setContentScrollOffset(to: index, selectedType: selectedType, animated: contentScrollViewAnimated)
            if selectedType == .code {
                listContainer?.didClickSelectedItem(at: index)
            } else if selectedType == .click {
                delegate?.segmentedView(self, didClickSelectedItemAt: index)
                tfy_emit_didClickSelect(index: index)
                listContainer?.didClickSelectedItem(at: index)
            }
            delegate?.segmentedView(self, didSelectedItemAt: index)
            tfy_emit_didSelect(index: index)
            return
        }

        isSelectionCleared = false

        guard
            let currentSelectedItemModel = itemDataSource[safe: selectedIndex],
            let willSelectedItemModel = itemDataSource[safe: index]
        else {
            return
        }
        dataSource?.refreshItemModel(self, currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)

        let currentSelectedCell = collectionView.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) as? TFYSwiftBaseCell
        currentSelectedCell?.reloadData(itemModel: currentSelectedItemModel, selectedType: selectedType)

        let willSelectedCell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? TFYSwiftBaseCell
        willSelectedCell?.reloadData(itemModel: willSelectedItemModel, selectedType: selectedType)

        if scrollingTargetIndex != -1, scrollingTargetIndex != index, let scrollingTargetItemModel = itemDataSource[safe: scrollingTargetIndex] {
            scrollingTargetItemModel.isSelected = false
            dataSource?.refreshItemModel(self, currentSelectedItemModel: scrollingTargetItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)
            let scrollingTargetCell = collectionView.cellForItem(at: IndexPath(item: scrollingTargetIndex, section: 0)) as? TFYSwiftBaseCell
            scrollingTargetCell?.reloadData(itemModel: scrollingTargetItemModel, selectedType: selectedType)
        }

        if dataSource?.isItemWidthZoomEnabled == true {
            if selectedType == .click || selectedType == .code {
                //延时为了解决cellwidth变化，点击最后几个cell，scrollToItem会出现位置偏移bu。需要等cellWidth动画渐变结束后再滚动到index的cell位置。
                let selectedAnimationDurationInMilliseconds = Int((dataSource?.selectedAnimationDuration ?? 0)*1000)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(selectedAnimationDurationInMilliseconds)) { [weak self] in
                    self?.centerCollectionView(on: index, animated: collectionViewAnimated)
                }
            }else if selectedType == .scroll {
                //滚动选中的直接处理
                centerCollectionView(on: index, animated: collectionViewAnimated)
            }
        }else {
            centerCollectionView(on: index, animated: collectionViewAnimated)
        }

        tfy_setContentScrollOffset(to: index, selectedType: selectedType, animated: contentScrollViewAnimated)

        selectedIndex = index

        let currentSelectedItemFrame = getSelectedItemFrameAt(index: selectedIndex)
        for indicator in indicators {
            indicator.isHidden = false
            let indicatorParams = TFYSwiftIndicatorSelectedParams(currentSelectedIndex: selectedIndex,
                                                                     currentSelectedItemFrame: currentSelectedItemFrame,
                                                                     selectedType: selectedType,
                                                                     currentItemContentWidth: dataSource?.segmentedView(self, widthForItemContentAt: selectedIndex) ?? 0,
                                                                     collectionViewContentSize: nil)
            // scroll 选中用 refresh 硬钉位置，避免跨禁用页后 selectItem 只改 x 仍留在错误位置。
            if selectedType == .scroll {
                indicator.refreshIndicatorState(model: indicatorParams)
            } else {
                indicator.selectItem(model: indicatorParams)
            }

            if indicator.isIndicatorConvertToItemFrameEnabled {
                var indicatorConvertToItemFrame = indicator.frame
                indicatorConvertToItemFrame.origin.x -= currentSelectedItemFrame.origin.x
                itemDataSource[selectedIndex].indicatorConvertToItemFrame = indicatorConvertToItemFrame
                willSelectedCell?.reloadData(itemModel: willSelectedItemModel, selectedType: selectedType)
            }
        }

        scrollingTargetIndex = -1
        if selectedType == .code {
            listContainer?.didClickSelectedItem(at: index)
        }else if selectedType == .click {
            delegate?.segmentedView(self, didClickSelectedItemAt: index)
            tfy_emit_didClickSelect(index: index)
            listContainer?.didClickSelectedItem(at: index)
        }else if selectedType == .scroll {
            delegate?.segmentedView(self, didScrollSelectedItemAt: index)
            tfy_emit_didScrollSelect(index: index)
        }
        delegate?.segmentedView(self, didSelectedItemAt: index)
        tfy_emit_didSelect(index: index)
    }

    /// 程序化切换分页时屏蔽 contentOffset KVO，防止跨页动画中间态改写选中。
    private func tfy_setContentScrollOffset(to index: Int,
                                            selectedType: TFYSwiftViewItemSelectedType,
                                            animated contentScrollViewAnimated: Bool?) {
        guard let contentScrollView,
              (selectedType == .click || selectedType == .code),
              contentScrollView.bounds.size.width > 0 else { return }

        var animated = contentScrollViewAnimated ?? isContentScrollViewClickTransitionAnimationEnabled
        if isRespectReduceMotionEnabled && UIAccessibility.isReduceMotionEnabled {
            animated = false
        }

        suppressContentScrollCallback = true
        contentScrollView.setContentOffset(
            CGPoint(x: contentScrollView.bounds.size.width * CGFloat(index), y: 0),
            animated: animated
        )
        lastContentOffset = contentScrollView.contentOffset
        lastTransitionProgress = CGFloat(index)

        if animated {
            let duration = indicators.map(\.scrollAnimationDuration).max() ?? 0.25
            DispatchQueue.main.asyncAfter(deadline: .now() + max(duration, 0.25) + 0.05) { [weak self] in
                guard let self else { return }
                self.suppressContentScrollCallback = false
                self.lastContentOffset = contentScrollView.contentOffset
                self.lastTransitionProgress = CGFloat(index)
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.suppressContentScrollCallback = false
            }
        }
    }

    @discardableResult
    private func refreshItem(at index: Int, selectedType: TFYSwiftViewItemSelectedType) -> Bool {
        guard let itemModel = itemDataSource[safe: index] else {
            return false
        }

        let oldWidth = itemModel.itemWidth
        dataSource?.refreshItemModel(self, itemModel, at: index, selectedIndex: selectedIndex)
        itemModel.index = index
        itemModel.isSelected = (index == selectedIndex)
        var newWidth = dataSource?.segmentedView(self, widthForItemAt: index) ?? oldWidth
        if dataSource?.isItemWidthZoomEnabled == true {
            newWidth *= itemModel.itemWidthCurrentZoomScale
        }
        itemModel.itemWidth = newWidth

        let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? TFYSwiftBaseCell
        cell?.reloadData(itemModel: itemModel, selectedType: selectedType)
        let didChange = abs(newWidth - oldWidth) > CGFloat.ulpOfOne
        if didChange {
            rebuildItemStartXCache()
        }
        return didChange
    }

    /// 重新构建 `itemStartXCache` 与 `totalContentWidthCache`。
    /// 在 reloadData / item 宽度变化 / innerItemSpacing 变化时调用。
    private func rebuildItemStartXCache() {
        let count = itemDataSource.count
        guard count > 0 else {
            itemStartXCache = []
            totalContentWidthCache = 0
            return
        }
        var cache = [CGFloat](repeating: 0, count: count)
        var x = getContentEdgeInsetLeft()
        for (index, itemModel) in itemDataSource.enumerated() {
            cache[index] = x
            if index == count - 1 {
                x += itemModel.itemWidth + getContentEdgeInsetRight()
            } else {
                x += itemModel.itemWidth + innerItemSpacing
            }
        }
        itemStartXCache = cache
        totalContentWidthCache = x
    }

    /// O(1) 获取 item 的 frame，如果正在进行动画并开启了宽度缩放，
    /// 会基于 dataSource 的目标宽度 + 缩放比例临时纠正（避免动画过程中的抖动显示）。
    private func getItemFrameAt(index: Int) -> CGRect {
        guard itemDataSource.indices.contains(index),
              let startX = itemStartXCache[safe: index] else {
            return .zero
        }
        let itemModel = itemDataSource[index]
        var width: CGFloat
        if itemModel.isTransitionAnimating && itemModel.isItemWidthZoomEnabled {
            let baseWidth = dataSource?.segmentedView(self, widthForItemAt: itemModel.index) ?? 0
            let scale = itemModel.isSelected ? itemModel.itemWidthSelectedZoomScale : itemModel.itemWidthNormalZoomScale
            width = baseWidth * scale
        } else {
            width = itemModel.itemWidth
        }
        return CGRect(x: startX, y: 0, width: width, height: bounds.size.height)
    }

    /// 计算"选中态下"的 item frame。
    /// 无宽度缩放时直接使用真实布局缓存（含 `itemWidthMode.equal`），避免 `widthForItemAt`（内容宽）
    /// 与 cell 实际宽度不一致导致指示器飞出可见区域。
    /// 开启宽度缩放时：假设先于 index 的 item 回归 normal 宽度，目标 item 按 selectedZoom 放大。
    private func getSelectedItemFrameAt(index: Int) -> CGRect {
        guard itemDataSource.indices.contains(index) else {
            return .zero
        }
        if dataSource?.isItemWidthZoomEnabled != true {
            return getItemFrameAt(index: index)
        }
        var x = getContentEdgeInsetLeft()
        for i in 0..<index {
            let rawWidth = dataSource?.segmentedView(self, widthForItemAt: i) ?? 0
            x += rawWidth + innerItemSpacing
        }
        let selectedItemModel = itemDataSource[index]
        let width: CGFloat
        if selectedItemModel.isItemWidthZoomEnabled {
            let rawWidth = dataSource?.segmentedView(self, widthForItemAt: selectedItemModel.index) ?? 0
            width = rawWidth * selectedItemModel.itemWidthSelectedZoomScale
        } else {
            width = selectedItemModel.itemWidth
        }
        return CGRect(x: x, y: 0, width: width, height: collectionView.bounds.size.height)
    }

    private func getContentEdgeInsetLeft() -> CGFloat {
        if contentEdgeInsetLeft == TFYSwiftViewAutomaticDimension {
            return innerItemSpacing
        }else {
            return contentEdgeInsetLeft
        }
    }

    private func getContentEdgeInsetRight() -> CGFloat {
        if contentEdgeInsetRight == TFYSwiftViewAutomaticDimension {
            return innerItemSpacing
        }else {
            return contentEdgeInsetRight
        }
    }

    private func observeContentScrollViewIfNeeded() {
        guard let contentScrollView else {
            contentScrollDelegateMux?.uninstall()
            contentScrollDelegateMux = nil
            contentScrollObservation?.invalidate()
            contentScrollObservation = nil
            return
        }

        if contentScrollObservation == nil {
            contentScrollObservation = contentScrollView.observe(\.contentOffset, options: [.new]) { [weak self, weak contentScrollView] _, change in
                guard
                    let self,
                    let contentScrollView,
                    let contentOffset = change.newValue
                else {
                    return
                }

                self.handleContentScrollViewDidScroll(in: contentScrollView, contentOffset: contentOffset)
            }
        }

        // 已正确挂上 mux 时只确保自己在观察者列表；避免 uninstall 把 ListContainer delegate 清掉。
        if let mux = contentScrollDelegateMux, contentScrollView.delegate === mux {
            mux.addObserver(self)
            return
        }

        // 保留 ListContainer 原有 delegate，并追加 willEndDragging / didEndDecelerating 以跳过禁用页。
        let mux = TFYSwiftScrollDelegateMultiplexer()
        mux.install(on: contentScrollView, preserveExistingDelegate: true)
        mux.addObserver(self)
        contentScrollDelegateMux = mux
    }

    /// 若内容页停在禁用项上，强制弹到滑动方向最近的可选项。
    private func tfy_ensureContentNotOnDisabledPage(scrollDelta: CGFloat = 0) {
        guard let contentScrollView, contentScrollView.bounds.width > 0, !itemDataSource.isEmpty else {
            // 即使内容已在启用页，也钉一次指示器（兜底跨禁用页残留）。
            if itemDataSource.indices.contains(selectedIndex), itemDataSource[selectedIndex].isItemEnabled {
                tfy_pinIndicators(to: selectedIndex)
            }
            return
        }
        let page = Int(round(contentScrollView.contentOffset.x / contentScrollView.bounds.width))
        if itemDataSource.indices.contains(page), !itemDataSource[page].isItemEnabled {
            let target = nearestEnabledIndex(around: page, scrollDelta: scrollDelta) ?? page
            guard target != page else { return }
            tfy_snapContentScroll(to: target, animated: false)
            if target == selectedIndex && !isSelectionCleared {
                tfy_refreshSelectedPresentation(at: target)
                scrollingTargetIndex = -1
            } else {
                selectItemAt(index: target, selectedType: .scroll)
            }
            return
        }
        if itemDataSource.indices.contains(selectedIndex), itemDataSource[selectedIndex].isItemEnabled {
            tfy_pinIndicators(to: selectedIndex)
        }
    }

    /// 把内容滚动进度映射到「仅启用项」之间的过渡，避免指示器停在禁用项上。
    /// 例如进度 1→3（中间 2 禁用）时，指示器在 1 与 3 的 frame 之间插值。
    private func mapProgressToEnabledTransition(_ progress: CGFloat) -> (left: Int, right: Int, percent: CGFloat)? {
        let enabled = itemDataSource.indices.filter { itemDataSource[$0].isItemEnabled }
        guard let first = enabled.first, let last = enabled.last else { return nil }
        let p = max(0, min(CGFloat(itemDataSource.count - 1), progress))
        if p <= CGFloat(first) { return (first, first, 0) }
        if p >= CGFloat(last) { return (last, last, 0) }

        for i in 0..<(enabled.count - 1) {
            let left = enabled[i]
            let right = enabled[i + 1]
            if p >= CGFloat(left) && p <= CGFloat(right) {
                let span = CGFloat(right - left)
                let percent = span > 0 ? (p - CGFloat(left)) / span : 0
                return (left, right, min(1, max(0, percent)))
            }
        }
        return (last, last, 0)
    }

    private func handleContentScrollViewDidScroll(in contentScrollView: UIScrollView, contentOffset: CGPoint) {
        // 程序化 setContentOffset 期间完全屏蔽，避免跨多页动画误改 selectedIndex。
        if suppressContentScrollCallback {
            lastContentOffset = contentOffset
            return
        }
        // 仅在 tracking/decelerating 场景参与联动，避免 setContentOffset 动画期间误触发。
        guard contentScrollView.isTracking || contentScrollView.isDecelerating else {
            return
        }

        let pageWidth = contentScrollView.bounds.size.width
        guard pageWidth > 0, !itemDataSource.isEmpty else {
            return
        }

        var progress = contentOffset.x/pageWidth
        if Int(progress) > itemDataSource.count - 1 || progress < 0 {
            return
        }
        if contentOffset.x == 0 && selectedIndex == 0 && lastContentOffset.x == 0 {
            lastContentOffset = contentOffset
            return
        }

        let maxContentOffsetX = max(contentScrollView.contentSize.width - pageWidth, 0)
        if contentOffset.x == maxContentOffsetX && selectedIndex == itemDataSource.count - 1 && lastContentOffset.x == maxContentOffsetX {
            lastContentOffset = contentOffset
            return
        }

        progress = max(0, min(CGFloat(itemDataSource.count - 1), progress))
        let baseIndex = Int(floor(progress))
        let remainderProgress = progress - CGFloat(baseIndex)

        // Epsilon 节流：仅在进度变化超过阈值，或者跨越整数 index 边界时继续处理。
        if contentScrollViewTransitionEpsilon > 0,
           lastTransitionProgress >= 0,
           Int(floor(lastTransitionProgress)) == baseIndex,
           abs(progress - lastTransitionProgress) < contentScrollViewTransitionEpsilon,
           remainderProgress != 0 {
            lastContentOffset = contentOffset
            return
        }

        // 整页停靠：按原始页处理（禁用页会在 scrollSelectItemAt 里吸附走开）。
        if remainderProgress == 0 {
            scrollSelectItemAt(index: baseIndex)
            if itemDataSource.indices.contains(selectedIndex),
               itemDataSource[selectedIndex].isItemEnabled {
                tfy_pinIndicators(to: selectedIndex)
            }
            lastContentOffset = contentOffset
            lastTransitionProgress = progress
            return
        }

        // 内容页落在禁用项上：禁止指示器插值。
        // 手指拖动中不抢 contentOffset（过早吸附容易带着惯性冲过「关注」落到「推荐」）；
        // 减速时再跳到滑动方向上的相邻启用页。
        if !itemDataSource[baseIndex].isItemEnabled {
            let direction = progress > CGFloat(selectedIndex) ? 1 : -1
            let target = adjacentEnabledIndex(from: selectedIndex, direction: direction)
                ?? nearestEnabledIndex(around: baseIndex, scrollDelta: CGFloat(direction))
                ?? selectedIndex

            if contentScrollView.isTracking {
                tfy_pinIndicators(to: target)
                lastContentOffset = contentOffset
                lastTransitionProgress = progress
                return
            }

            if Int(round(contentOffset.x / pageWidth)) != target || target != selectedIndex {
                tfy_snapContentScroll(to: target, animated: false)
                if target == selectedIndex && !isSelectionCleared {
                    tfy_refreshSelectedPresentation(at: target)
                } else {
                    selectItemAt(index: target, selectedType: .scroll)
                }
            } else {
                tfy_pinIndicators(to: target)
            }
            lastContentOffset = contentScrollView.contentOffset
            lastTransitionProgress = CGFloat(selectedIndex)
            return
        }

        // 过渡态：指示器 / 标题渐变只在启用项之间插值。
        guard let transition = mapProgressToEnabledTransition(progress) else {
            lastContentOffset = contentOffset
            return
        }
        let leftIndex = transition.left
        let rightIndex = transition.right
        let transitionPercent = transition.percent

        if abs(progress - CGFloat(selectedIndex)) > 1 {
            // 只推进到相邻启用项，不能用 progress 映射的 leftIndex（可能直接掉到推荐）。
            let direction = progress < CGFloat(selectedIndex) ? -1 : 1
            let targetIndex = adjacentEnabledIndex(from: selectedIndex, direction: direction)
                ?? (direction < 0 ? leftIndex : rightIndex)
            scrollSelectItemAt(index: targetIndex)
            tfy_pinIndicators(to: selectedIndex)
            lastContentOffset = contentScrollView.contentOffset
            lastTransitionProgress = CGFloat(selectedIndex)
            return
        }
        scrollingTargetIndex = (selectedIndex == leftIndex) ? rightIndex : leftIndex

        let leftItemFrame = getItemFrameAt(index: leftIndex)
        let rightItemFrame = getItemFrameAt(index: rightIndex)
        let indicatorParams = TFYSwiftIndicatorTransitionParams(currentSelectedIndex: selectedIndex,
                                                               leftIndex: leftIndex,
                                                               leftItemFrame: leftItemFrame,
                                                               leftItemContentWidth: currentItemContentWidth(at: leftIndex),
                                                               rightIndex: rightIndex,
                                                               rightItemFrame: rightItemFrame,
                                                               rightItemContentWidth: currentItemContentWidth(at: rightIndex),
                                                               percent: transitionPercent)

        if leftIndex != rightIndex {
            dataSource?.refreshItemModel(self, leftItemModel: itemDataSource[leftIndex], rightItemModel: itemDataSource[rightIndex], percent: transitionPercent)
        }

        for indicator in indicators {
            indicator.contentScrollViewDidScroll(model: indicatorParams)
            if indicator.isIndicatorConvertToItemFrameEnabled {
                var leftIndicatorConvertToItemFrame = indicator.frame
                leftIndicatorConvertToItemFrame.origin.x -= leftItemFrame.origin.x
                itemDataSource[leftIndex].indicatorConvertToItemFrame = leftIndicatorConvertToItemFrame

                var rightIndicatorConvertToItemFrame = indicator.frame
                rightIndicatorConvertToItemFrame.origin.x -= rightItemFrame.origin.x
                itemDataSource[rightIndex].indicatorConvertToItemFrame = rightIndicatorConvertToItemFrame
            }
        }

        let leftCell = collectionView.cellForItem(at: IndexPath(item: leftIndex, section: 0)) as? TFYSwiftBaseCell
        leftCell?.reloadData(itemModel: itemDataSource[leftIndex], selectedType: .unknown)

        let rightCell = collectionView.cellForItem(at: IndexPath(item: rightIndex, section: 0)) as? TFYSwiftBaseCell
        rightCell?.reloadData(itemModel: itemDataSource[rightIndex], selectedType: .unknown)

        delegate?.segmentedView(self, scrollingFrom: leftIndex, to: rightIndex, percent: transitionPercent)
        tfy_emit_scrollingProgress(from: leftIndex, to: rightIndex, percent: transitionPercent)

        lastContentOffset = contentOffset
        lastTransitionProgress = progress
    }

    /// 把指示器硬钉到指定选中项（使用 refreshIndicatorState，避免 selectItem 只改 x/width 的残留）。
    private func tfy_pinIndicators(to index: Int) {
        guard itemDataSource.indices.contains(index) else { return }
        let selectedItemFrame = getSelectedItemFrameAt(index: index)
        let params = TFYSwiftIndicatorSelectedParams(
            currentSelectedIndex: index,
            currentSelectedItemFrame: selectedItemFrame,
            selectedType: .scroll,
            currentItemContentWidth: currentItemContentWidth(at: index),
            collectionViewContentSize: CGSize(width: totalContentWidthCache, height: bounds.size.height)
        )
        for indicator in indicators {
            indicator.isHidden = false
            indicator.refreshIndicatorState(model: params)
        }
    }

    private func currentItemContentWidth(at index: Int) -> CGFloat {
        dataSource?.segmentedView(self, widthForItemContentAt: index) ?? 0
    }

    private func centerCollectionView(on index: Int, animated: Bool) {
        guard itemDataSource.indices.contains(index) else { return }
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
    }
}

extension TFYSwiftView: UIScrollViewDelegate {
    /// 松手时若系统准备停在禁用页，改写到滑动方向上「相邻」的启用页（只跳一步）。
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                          withVelocity velocity: CGPoint,
                                          targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView === contentScrollView,
              scrollView.bounds.width > 0,
              !itemDataSource.isEmpty else { return }

        let pageWidth = scrollView.bounds.width
        var page = Int((targetContentOffset.pointee.x / pageWidth).rounded())
        page = max(0, min(itemDataSource.count - 1, page))
        guard itemDataSource.indices.contains(page),
              !itemDataSource[page].isItemEnabled else { return }

        // velocity.x > 0：向更高 contentOffset / 更大 index 翻页
        let direction: Int
        if abs(velocity.x) > 0.01 {
            direction = velocity.x > 0 ? 1 : -1
        } else {
            let delta = targetContentOffset.pointee.x - scrollView.contentOffset.x
            direction = delta >= 0 ? 1 : -1
        }
        let target = adjacentEnabledIndex(from: selectedIndex, direction: direction)
            ?? nearestEnabledIndex(around: page, scrollDelta: CGFloat(direction))
        guard let target else { return }
        targetContentOffset.pointee.x = CGFloat(target) * pageWidth
    }

    /// 兜底：惯性结束后若仍停在禁用页（willEndDragging 未生效时），立即弹开。
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView === contentScrollView else { return }
        tfy_ensureContentNotOnDisabledPage()
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView === contentScrollView, !decelerate else { return }
        tfy_ensureContentNotOnDisabledPage()
    }
}

extension TFYSwiftView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemDataSource.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = dataSource?.segmentedView(self, cellForItemAt: indexPath.item), let itemModel = itemDataSource[safe: indexPath.item] {
            cell.reloadData(itemModel: itemModel, selectedType: .unknown)
            return cell
        }else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "TFYSwiftViewInnerEmptyCell", for: indexPath)
        }
    }
}

extension TFYSwiftView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard itemDataSource.indices.contains(indexPath.item) else { return }
        var isTransitionAnimating = false
        for itemModel in itemDataSource {
            if itemModel.isTransitionAnimating {
                isTransitionAnimating = true
                break
            }
        }
        if !isTransitionAnimating {
            //当前没有正在过渡的item，才允许点击选中
            clickSelectItemAt(index: indexPath.item)
        }
    }

    /// Context Menu 钩子：外部通过 `contextMenuProvider` 闭包返回一个 `UIContextMenuConfiguration`
    /// 即可启用标题的长按菜单。返回 nil 表示该 item 不展示菜单。
    public func collectionView(_ collectionView: UICollectionView,
                                contextMenuConfigurationForItemAt indexPath: IndexPath,
                                point: CGPoint) -> UIContextMenuConfiguration? {
        guard isContextMenuEnabled, let provider = contextMenuProvider else { return nil }
        guard itemDataSource.indices.contains(indexPath.item) else { return nil }
        return provider(indexPath.item, itemDataSource[indexPath.item])
    }

    public func collectionView(_ collectionView: UICollectionView,
                                canMoveItemAt indexPath: IndexPath) -> Bool {
        return isReorderingEnabled
    }

    public func collectionView(_ collectionView: UICollectionView,
                                moveItemAt sourceIndexPath: IndexPath,
                                to destinationIndexPath: IndexPath) {
        guard isReorderingEnabled,
              itemDataSource.indices.contains(sourceIndexPath.item),
              itemDataSource.indices.contains(destinationIndexPath.item) else { return }
        let moved = itemDataSource.remove(at: sourceIndexPath.item)
        itemDataSource.insert(moved, at: destinationIndexPath.item)
        // 更新 selectedIndex 跟随拖拽目标，避免高亮错位。
        if selectedIndex == sourceIndexPath.item {
            selectedIndex = destinationIndexPath.item
        } else if sourceIndexPath.item < selectedIndex, destinationIndexPath.item >= selectedIndex {
            selectedIndex -= 1
        } else if sourceIndexPath.item > selectedIndex, destinationIndexPath.item <= selectedIndex {
            selectedIndex += 1
        }
        rebuildItemStartXCacheAfterReorder()
        if let baseDS = dataSource as? TFYSwiftBaseDataSource {
            baseDS.didReorderItem(from: sourceIndexPath.item, to: destinationIndexPath.item)
        }
        didReorderItem?(sourceIndexPath.item, destinationIndexPath.item)
    }

    /// 拖拽重排后重建起点缓存并刷新指示器，避免 `getItemFrameAt` 读到陈旧 x。
    private func rebuildItemStartXCacheAfterReorder() {
        for (i, model) in itemDataSource.enumerated() { model.index = i }
        rebuildItemStartXCache()
        collectionView.collectionViewLayout.invalidateLayout()
        if itemDataSource.indices.contains(selectedIndex) {
            let selectedItemFrame = getSelectedItemFrameAt(index: selectedIndex)
            let contentWidth = currentItemContentWidth(at: selectedIndex)
            let params = TFYSwiftIndicatorSelectedParams(
                currentSelectedIndex: selectedIndex,
                currentSelectedItemFrame: selectedItemFrame,
                selectedType: .code,
                currentItemContentWidth: contentWidth,
                collectionViewContentSize: CGSize(width: totalContentWidthCache, height: bounds.size.height)
            )
            for indicator in indicators {
                indicator.selectItem(model: params)
            }
        }
    }

    // MARK: - Interactive reorder (long press)

    private func installReorderGestureIfNeeded() {
        guard reorderLongPressGesture == nil else { return }
        let gr = UILongPressGestureRecognizer(target: self,
                                              action: #selector(tfy_handleReorderLongPress(_:)))
        gr.minimumPressDuration = reorderMinimumPressDuration
        gr.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(gr)
        reorderLongPressGesture = gr
    }

    @objc private func tfy_handleReorderLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard isReorderingEnabled else {
            if gesture.state == .began { gesture.state = .cancelled }
            return
        }
        switch gesture.state {
        case .began:
            let location = gesture.location(in: collectionView)
            guard let indexPath = collectionView.indexPathForItem(at: location) else { return }
            if !collectionView.beginInteractiveMovementForItem(at: indexPath) {
                gesture.state = .cancelled
            }
        case .changed:
            var location = gesture.location(in: collectionView)
            // 横向 segmented 只关心 X 方向跟手，Y 锁死防止乱跳。
            location.y = collectionView.bounds.midY
            collectionView.updateInteractiveMovementTargetPosition(location)
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}

extension TFYSwiftView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: getContentEdgeInsetLeft(), bottom: 0, right: getContentEdgeInsetRight())
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let itemModel = itemDataSource[safe: indexPath.item] {
            return CGSize(width: itemModel.itemWidth, height: collectionView.bounds.size.height)
        } else {
            return .zero
        }
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return innerItemSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return innerItemSpacing
    }
}
