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
    /// 默认 0，完全保留历史行为；调大（例如 0.002）可降低 ProMotion 设备下的 CPU 占用。
    open var contentScrollViewTransitionEpsilon: CGFloat = 0

    private var itemDataSource = [TFYSwiftBaseItemModel]()
    private var innerItemSpacing: CGFloat = 0
    private var lastContentOffset: CGPoint = CGPoint.zero
    private var contentScrollObservation: NSKeyValueObservation?
    /// 正在滚动中的目标index。用于处理正在滚动列表的时候，立即点击item，会导致界面显示异常。
    private var scrollingTargetIndex: Int = -1
    private var isFirstLayoutSubviews = true

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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tfy_handleContentSizeCategoryDidChange),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
        // 共享文本宽度缓存与字号强绑定，字号变更后必须失效，否则会继续返回旧宽度导致截断。
        NotificationCenter.default.addObserver(
            forName: UIContentSizeCategory.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                TFYSwiftTextMeasure.shared.invalidate()
            }
    }

    @objc private func tfy_handleContentSizeCategoryDidChange() {
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
        let targetFrame = CGRect(x: 0, y: 0, width: bounds.size.width, height: floor(bounds.size.height))
        if isFirstLayoutSubviews {
            isFirstLayoutSubviews = false
            collectionView.frame = targetFrame
            reloadDataWithoutListContainer()
        }else {
            if collectionView.frame != targetFrame {
                collectionView.frame = targetFrame
                collectionView.collectionViewLayout.invalidateLayout()
                collectionView.reloadData()
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

    open func reloadDataWithoutListContainer() {
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
        for (index, itemModel) in itemDataSource.enumerated() {
            itemModel.index = index
            itemModel.itemWidth = (dataSource?.segmentedView(self, widthForItemAt: index) ?? 0)
            if dataSource?.isItemWidthZoomEnabled == true {
                itemModel.itemWidth *= itemModel.itemWidthCurrentZoomScale
            }
            itemModel.isSelected = (index == selectedIndex)
            totalItemWidth += itemModel.itemWidth
            if index == itemDataSource.count - 1 {
                totalContentWidth += itemModel.itemWidth + getContentEdgeInsetRight()
            }else {
                totalContentWidth += itemModel.itemWidth + innerItemSpacing
            }
        }

        if dataSource?.isItemSpacingAverageEnabled == true && totalContentWidth < bounds.size.width {
            var itemSpacingCount = itemDataSource.count - 1
            var totalItemSpacingWidth = bounds.size.width - totalItemWidth
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
            if itemDataSource.isEmpty {
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
        collectionView.reloadData()
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
        selectItemAt(index: index, selectedType: .click)
    }

    private func scrollSelectItemAt(index: Int) {
        selectItemAt(index: index, selectedType: .scroll)
    }

    private func selectItemAt(index: Int, selectedType: TFYSwiftViewItemSelectedType, collectionViewAnimated: Bool = true, contentScrollViewAnimated: Bool? = nil) {
        guard index >= 0 && index < itemDataSource.count else {
            return
        }

        if index == selectedIndex {
            if selectedType == .code {
                listContainer?.didClickSelectedItem(at: index)
            }else if selectedType == .click {
                delegate?.segmentedView(self, didClickSelectedItemAt: index)
                listContainer?.didClickSelectedItem(at: index)
            }else if selectedType == .scroll {
                delegate?.segmentedView(self, didScrollSelectedItemAt: index)
            }
            delegate?.segmentedView(self, didSelectedItemAt: index)
            scrollingTargetIndex = -1
            return
        }

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

        if let contentScrollView, (selectedType == .click || selectedType == .code), contentScrollView.bounds.size.width > 0 {
            let animated = contentScrollViewAnimated ?? isContentScrollViewClickTransitionAnimationEnabled
            contentScrollView.setContentOffset(CGPoint(x: contentScrollView.bounds.size.width*CGFloat(index), y: 0), animated: animated)
        }

        selectedIndex = index

        let currentSelectedItemFrame = getSelectedItemFrameAt(index: selectedIndex)
        for indicator in indicators {
            let indicatorParams = TFYSwiftIndicatorSelectedParams(currentSelectedIndex: selectedIndex,
                                                                     currentSelectedItemFrame: currentSelectedItemFrame,
                                                                     selectedType: selectedType,
                                                                     currentItemContentWidth: dataSource?.segmentedView(self, widthForItemContentAt: selectedIndex) ?? 0,
                                                                     collectionViewContentSize: nil)
            indicator.selectItem(model: indicatorParams)

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
            listContainer?.didClickSelectedItem(at: index)
        }else if selectedType == .scroll {
            delegate?.segmentedView(self, didScrollSelectedItemAt: index)
        }
        delegate?.segmentedView(self, didSelectedItemAt: index)
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
    /// 语义与旧版本一致：假设先于 index 的 item 回归到 dataSource 提供的原始宽度（即 normalZoom = 1 的视觉），
    /// 目标 item 按 `itemWidthSelectedZoomScale` 放大。主要在 `selectItemAt` 结束后用于定位指示器。
    /// 由于单次调用 O(n) 可接受，这里不使用累积缓存，避免状态耦合。
    private func getSelectedItemFrameAt(index: Int) -> CGRect {
        guard itemDataSource.indices.contains(index) else {
            return .zero
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
        return CGRect(x: x, y: 0, width: width, height: bounds.size.height)
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
        guard let contentScrollView else { return }

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

    private func handleContentScrollViewDidScroll(in contentScrollView: UIScrollView, contentOffset: CGPoint) {
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
        let rightIndex = min(baseIndex + 1, itemDataSource.count - 1)

        // Epsilon 节流：仅在进度变化超过阈值，或者跨越整数 index 边界时继续处理。
        if contentScrollViewTransitionEpsilon > 0,
           lastTransitionProgress >= 0,
           Int(floor(lastTransitionProgress)) == baseIndex,
           abs(progress - lastTransitionProgress) < contentScrollViewTransitionEpsilon,
           remainderProgress != 0 {
            lastContentOffset = contentOffset
            return
        }

        let leftItemFrame = getItemFrameAt(index: baseIndex)
        let rightItemFrame = getItemFrameAt(index: rightIndex)
        let indicatorParams = TFYSwiftIndicatorTransitionParams(currentSelectedIndex: selectedIndex,
                                                               leftIndex: baseIndex,
                                                               leftItemFrame: leftItemFrame,
                                                               leftItemContentWidth: currentItemContentWidth(at: baseIndex),
                                                               rightIndex: rightIndex,
                                                               rightItemFrame: rightItemFrame,
                                                               rightItemContentWidth: currentItemContentWidth(at: rightIndex),
                                                               percent: remainderProgress)

        if remainderProgress == 0 {
            if !(lastContentOffset.x == contentOffset.x && selectedIndex == baseIndex) {
                scrollSelectItemAt(index: baseIndex)
            }
            lastContentOffset = contentOffset
            lastTransitionProgress = progress
            return
        }

        guard rightIndex < itemDataSource.count else {
            lastContentOffset = contentOffset
            return
        }

        if abs(progress - CGFloat(selectedIndex)) > 1 {
            let targetIndex = progress < CGFloat(selectedIndex) ? rightIndex : baseIndex
            scrollSelectItemAt(index: targetIndex)
        }
        scrollingTargetIndex = (selectedIndex == baseIndex) ? rightIndex : baseIndex

        dataSource?.refreshItemModel(self, leftItemModel: itemDataSource[baseIndex], rightItemModel: itemDataSource[rightIndex], percent: remainderProgress)

        for indicator in indicators {
            indicator.contentScrollViewDidScroll(model: indicatorParams)
            if indicator.isIndicatorConvertToItemFrameEnabled {
                var leftIndicatorConvertToItemFrame = indicator.frame
                leftIndicatorConvertToItemFrame.origin.x -= leftItemFrame.origin.x
                itemDataSource[baseIndex].indicatorConvertToItemFrame = leftIndicatorConvertToItemFrame

                var rightIndicatorConvertToItemFrame = indicator.frame
                rightIndicatorConvertToItemFrame.origin.x -= rightItemFrame.origin.x
                itemDataSource[rightIndex].indicatorConvertToItemFrame = rightIndicatorConvertToItemFrame
            }
        }

        let leftCell = collectionView.cellForItem(at: IndexPath(item: baseIndex, section: 0)) as? TFYSwiftBaseCell
        leftCell?.reloadData(itemModel: itemDataSource[baseIndex], selectedType: .unknown)

        let rightCell = collectionView.cellForItem(at: IndexPath(item: rightIndex, section: 0)) as? TFYSwiftBaseCell
        rightCell?.reloadData(itemModel: itemDataSource[rightIndex], selectedType: .unknown)

        delegate?.segmentedView(self, scrollingFrom: baseIndex, to: rightIndex, percent: remainderProgress)

        lastContentOffset = contentOffset
        lastTransitionProgress = progress
    }

    private func currentItemContentWidth(at index: Int) -> CGFloat {
        dataSource?.segmentedView(self, widthForItemContentAt: index) ?? 0
    }

    private func centerCollectionView(on index: Int, animated: Bool) {
        guard itemDataSource.indices.contains(index) else { return }
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
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
