//
//  Modern2_0Demos.swift
//  TFYSwiftSegmentedUilt
//
//  TFYSwiftSegmentedKit 2.0 新能力的可运行 Demo 合集。
//  每个 ViewController 都可以独立 push 使用，配合 Modern2_0ListViewController 使用。
//
//  iOS 15+ / Swift 5.9+。
//

import Combine
import SwiftUI
import UIKit

// MARK: - 通用基座

/// 通用基类：`TFYSwiftView` 顶置 + 下方一个颜色页容器。
/// 所有 2.0 Demo 都以它为模板，避免复制粘贴。
class Modern2_0BaseViewController: UIViewController,
                                    TFYSwiftListContainerViewDataSource {
    let segmentedView = TFYSwiftView()
    var dataSourceStrongRef: TFYSwiftBaseDataSource?
    let titles = ["首页", "热门", "推荐啊上课不卡不卡", "收藏", "最近阿生机勃", "设置"]

    /// 子类可覆写：给 segmentedView 的容器一个背景色。
    /// 对 Blur 这类依赖"背后有东西可模糊"的指示器尤其重要。
    var segmentedBarBackgroundColor: UIColor { .systemBackground }

    lazy var listContainerView: TFYSwiftListContainerView = {
        TFYSwiftListContainerView(dataSource: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(segmentedView)
        view.addSubview(listContainerView)
        listContainerView.isScrollEnabled = true
        segmentedView.listContainer = listContainerView
        segmentedView.backgroundColor = segmentedBarBackgroundColor

        configure()
        segmentedView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topInset = view.safeAreaInsets.top
        segmentedView.frame = CGRect(x: 0,
                                     y: topInset,
                                     width: view.bounds.width,
                                     height: 50)
        listContainerView.frame = CGRect(x: 0,
                                         y: segmentedView.frame.maxY,
                                         width: view.bounds.width,
                                         height: view.bounds.height - segmentedView.frame.maxY)
    }

    /// 子类覆写：在 super.viewDidLoad 之前配置 dataSource / indicators / 事件。
    func configure() {
        let ds = TFYSwiftTitleDataSource()
        ds.titles = titles
        ds.titleNormalColor = .secondaryLabel
        ds.titleSelectedColor = .label
        ds.titleNormalFont = .systemFont(ofSize: 15)
        ds.titleSelectedFont = .systemFont(ofSize: 15, weight: .semibold)
        ds.isTitleZoomEnabled = true
        dataSourceStrongRef = ds
        segmentedView.dataSource = ds
        segmentedView.indicators = [TFYSwiftIndicatorLineView()]
    }

    // MARK: TFYSwiftListContainerViewDataSource

    func numberOfLists(in listContainerView: TFYSwiftListContainerView) -> Int {
        titles.count
    }

    func listContainerView(_ listContainerView: TFYSwiftListContainerView,
                           initListAt index: Int) -> TFYSwiftListContainerViewListDelegate {
        Modern2_0PageViewController(index: index, title: titles[safe: index] ?? "")
    }
}

/// 极简彩色页面，所有 demo 共用。
final class Modern2_0PageViewController: UIViewController,
                                         TFYSwiftListContainerViewListDelegate {
    let index: Int
    let pageTitle: String

    init(index: Int, title: String) {
        self.index = index
        self.pageTitle = title
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not supported") }

    override func viewDidLoad() {
        super.viewDidLoad()
        let hue = CGFloat(index) * 0.13
        view.backgroundColor = UIColor(hue: hue.truncatingRemainder(dividingBy: 1),
                                       saturation: 0.2,
                                       brightness: 0.97,
                                       alpha: 1)

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Page #\(index)  ·  \(pageTitle)"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        ])
    }

    func listView() -> UIView { view }
}

// MARK: - B. 性能与诊断

final class Modern2_0DiffableDataSourceViewController: Modern2_0BaseViewController {
    override func configure() {
        super.configure()
        segmentedView.isDiffableDataSourceEnabled = true

        let bar = UIBarButtonItem(title: "Toggle Diffable",
                                  style: .plain,
                                  target: self,
                                  action: #selector(toggle))
        navigationItem.rightBarButtonItem = bar
    }

    @objc private func toggle() {
        segmentedView.isDiffableDataSourceEnabled.toggle()
        let on = segmentedView.isDiffableDataSourceEnabled
        let alert = UIAlertController(title: "Diffable DataSource",
                                      message: on ? "已启用（snapshot 模式）" : "已关闭（reloadData 模式）",
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

final class Modern2_0DiagnosticsViewController: Modern2_0BaseViewController {
    override func configure() {
        super.configure()
        segmentedView.indicators = [TFYSwiftIndicatorLineView()]

        TFYSwiftDiagnostics.shared.isSignpostEnabled = true
        TFYSwiftDiagnostics.shared.isVerboseLoggingEnabled = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "输出日志",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(fire))
    }

    @objc private func fire() {
        TFYSwiftDiagnostics.shared.event(name: "Demo", message: "手动触发一次 event")
        let id = TFYSwiftDiagnostics.shared.beginSignpost(name: "Demo", message: "region-begin")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            TFYSwiftDiagnostics.shared.endSignpost(name: "Demo", id: id, message: "region-end")
        }
    }
}

// MARK: - C. 新指示器展示

final class Modern2_0IndicatorShowcaseViewController: Modern2_0BaseViewController {

    enum Kind { case capsule, elasticLine, blur, symbol }
    private let kind: Kind

    init(kind: Kind) {
        self.kind = kind
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override var segmentedBarBackgroundColor: UIColor {
        // Blur 需要一个"非纯白"的背景才能让毛玻璃效果被看见。
        kind == .blur ? .secondarySystemBackground : .systemBackground
    }

    override func configure() {
        let ds = TFYSwiftTitleDataSource()
        ds.titles = titles
        ds.isTitleColorGradientEnabled = true
        ds.titleNormalColor = .secondaryLabel
        ds.titleSelectedColor = .label
        ds.titleNormalFont = .systemFont(ofSize: 15)
        ds.titleSelectedFont = .systemFont(ofSize: 15, weight: .semibold)
        ds.itemSpacing = 8
        ds.isTitleZoomEnabled = true
        dataSourceStrongRef = ds
        segmentedView.dataSource = ds

        switch kind {
        case .capsule:
            let capsule = TFYSwiftIndicatorCapsuleView()
            capsule.indicatorHeight = 32
            capsule.indicatorWidthIncrement = 16
            capsule.indicatorColor = UIColor.systemBlue.withAlphaComponent(0.28)
            capsule.borderColor = .systemBlue
            capsule.borderWidth = 1.5
            capsule.shadowColor = UIColor.systemBlue
            capsule.shadowOffset = CGSize(width: 0, height: 2)
            capsule.shadowRadius = 4
            capsule.shadowOpacity = 0.30
            segmentedView.indicators = [capsule]

        case .elasticLine:
            let line = TFYSwiftIndicatorElasticLineView()
            line.indicatorWidth = TFYSwiftViewAutomaticDimension
            line.indicatorColor = .systemIndigo
            line.indicatorHeight = 3
            segmentedView.indicators = [line]

        case .blur:
            // 毛玻璃要想被"看见"：
            // 1. 背后需要有可被模糊的颜色（见 segmentedBarBackgroundColor）。
            // 2. 叠一层半透明 tint 作为兜底，确保纯色背景下也能看到胶囊轮廓。
            let blur = TFYSwiftIndicatorBlurView()
            blur.indicatorHeight = 34
            blur.indicatorWidthIncrement = 16
            blur.blurStyle = .systemMaterial
            blur.tintColor2 = UIColor.label.withAlphaComponent(0.08)
            segmentedView.indicators = [blur]

        case .symbol:
            // 仅演示 SF Symbol 指示器，避免叠加一根红色下划线造成视觉混乱。
            let symbol = TFYSwiftIndicatorSymbolView()
            symbol.symbolName = "circle.fill"
            symbol.symbolPointSize = 6
            symbol.symbolTintColor = .systemRed
            symbol.indicatorPosition = .bottom
            symbol.verticalOffset = 4
            segmentedView.indicators = [symbol]
        }
    }
}

// MARK: - C. 触感 + Reduce Motion

final class Modern2_0HapticReduceMotionViewController: Modern2_0BaseViewController {
    private let hapticSwitch = UISwitch()
    private let reduceSwitch = UISwitch()

    override func configure() {
        super.configure()
        segmentedView.isHapticEnabled = true
        segmentedView.isRespectReduceMotionEnabled = true

        let banner = makeBanner()
        view.addSubview(banner)

        banner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            banner.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func makeBanner() -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.backgroundColor = .tertiarySystemBackground
        stack.layer.cornerRadius = 12

        let hRow = makeRow(title: "isHapticEnabled", sw: hapticSwitch) { [weak self] in
            self?.segmentedView.isHapticEnabled = $0
        }
        hapticSwitch.isOn = true

        let rRow = makeRow(title: "isRespectReduceMotionEnabled", sw: reduceSwitch) { [weak self] in
            self?.segmentedView.isRespectReduceMotionEnabled = $0
        }
        reduceSwitch.isOn = true

        let hint = UILabel()
        hint.numberOfLines = 0
        hint.font = .systemFont(ofSize: 12)
        hint.textColor = .secondaryLabel
        hint.text = "切换分段时观察触感反馈；在系统设置→辅助功能中启用\"减弱动态效果\"后，会跳过 contentScrollView 过渡动画。"
        stack.addArrangedSubview(hRow)
        stack.addArrangedSubview(rRow)
        stack.addArrangedSubview(hint)
        return stack
    }

    private func makeRow(title: String, sw: UISwitch, change: @escaping (Bool) -> Void) -> UIView {
        let label = UILabel()
        label.text = title
        label.font = .monospacedSystemFont(ofSize: 13, weight: .medium)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        sw.addAction(UIAction { _ in change(sw.isOn) }, for: .valueChanged)

        let row = UIStackView(arrangedSubviews: [label, sw])
        row.axis = .horizontal
        row.spacing = 12
        return row
    }
}

// MARK: - C. Context Menu

final class Modern2_0ContextMenuViewController: Modern2_0BaseViewController {

    override func configure() {
        super.configure()
        segmentedView.isContextMenuEnabled = true
        segmentedView.contextMenuProvider = { [weak self] index, model in
            guard let self else { return nil }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let pin = UIAction(title: "置顶 \(self.titles[safe: index] ?? "")",
                                   image: UIImage(systemName: "pin.fill")) { _ in
                    self.toast("pin \(index)")
                }
                let share = UIAction(title: "分享",
                                     image: UIImage(systemName: "square.and.arrow.up")) { _ in
                    self.toast("share \(index)")
                }
                let close = UIAction(title: "关闭",
                                     image: UIImage(systemName: "xmark.circle"),
                                     attributes: .destructive) { _ in
                    self.toast("close \(index)")
                }
                return UIMenu(title: "标题#\(index)", children: [pin, share, close])
            }
        }
    }

    private func toast(_ s: String) {
        let alert = UIAlertController(title: s, message: nil, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - C. Drag-to-Reorder

final class Modern2_0ReorderViewController: Modern2_0BaseViewController {

    private lazy var titleDataSource: TFYSwiftTitleDataSource = {
        let ds = TFYSwiftTitleDataSource()
        ds.titles = titles
        ds.titleNormalColor = .secondaryLabel
        ds.titleSelectedColor = .label
        ds.titleNormalFont = .systemFont(ofSize: 15)
        ds.titleSelectedFont = .systemFont(ofSize: 15, weight: .semibold)
        return ds
    }()

    override func configure() {
        dataSourceStrongRef = titleDataSource
        segmentedView.dataSource = titleDataSource
        segmentedView.indicators = [TFYSwiftIndicatorLineView()]

        segmentedView.isReorderingEnabled = true
        segmentedView.didReorderItem = { [weak self] from, to in
            guard let self else { return }
            guard self.titleDataSource.titles.indices.contains(from),
                  self.titleDataSource.titles.indices.contains(to) else { return }
            let moved = self.titleDataSource.titles.remove(at: from)
            self.titleDataSource.titles.insert(moved, at: to)
            self.titleDataSource.reloadData(selectedIndex: self.segmentedView.selectedIndex)
            // 框架只重排 `itemDataSource`，不会动下面的内容容器——
            // 让 "内容跟随 tab" 需要业务方自己 reload listContainer。
            self.listContainerView.reloadData()
        }

        navigationItem.prompt = "长按拖动排序 · 放手后会回调 didReorderItem · 内容会随标题一起迁移"
    }

    // 基类的默认实现用的是常量 `titles` 数组，这里需要改成读 titleDataSource.titles，
    // 否则 reloadData 之后 pages 还是会按原始顺序装载。
    override func numberOfLists(in listContainerView: TFYSwiftListContainerView) -> Int {
        titleDataSource.titles.count
    }

    override func listContainerView(_ listContainerView: TFYSwiftListContainerView,
                                    initListAt index: Int) -> TFYSwiftListContainerViewListDelegate {
        let title = titleDataSource.titles[safe: index] ?? ""
        return Modern2_0PageViewController(index: index, title: title)
    }
}

// MARK: - C. Badge

final class Modern2_0BadgeViewController: Modern2_0BaseViewController {

    override func configure() {
        let ds = TFYSwiftTitleDataSource()
        ds.titles = titles
        ds.titleNormalColor = .secondaryLabel
        ds.titleSelectedColor = .label
        ds.titleNormalFont = .systemFont(ofSize: 15)
        ds.titleSelectedFont = .systemFont(ofSize: 15, weight: .semibold)
        ds.itemSpacing = 24
        ds.isTitleZoomEnabled = true
        ds.badges = titles.indices.map { i -> TFYSwiftBadgeConfiguration? in
            switch i % 3 {
            case 0:
                return TFYSwiftBadgeConfiguration(style: .dot, backgroundColor: .systemRed)
            case 1:
                return TFYSwiftBadgeConfiguration(style: .number(i + 3),
                                                 backgroundColor: .systemRed,
                                                 textColor: .white,
                                                 font: .systemFont(ofSize: 10, weight: .semibold))
            default:
                return TFYSwiftBadgeConfiguration(style: .text("NEW"),
                                                 backgroundColor: .systemOrange,
                                                 textColor: .white,
                                                 font: .systemFont(ofSize: 10, weight: .bold))
            }
        }
        dataSourceStrongRef = ds
        segmentedView.dataSource = ds
        segmentedView.indicators = [TFYSwiftIndicatorLineView()]
    }
}

// MARK: - C. 对比度校验

final class Modern2_0ContrastViewController: Modern2_0BaseViewController {

    private let resultLabel = UILabel()

    override func configure() {
        super.configure()

        let foreground = UIColor.white
        let background = UIColor.systemBlue
        let ratio = TFYSwiftViewTool.contrastRatio(foreground, background)
        TFYSwiftViewTool.warnIfContrastTooLow(foreground: foreground, background: background)

        resultLabel.text = String(format: "white vs systemBlue → %.2f : 1\nWCAG 正文≥4.5 · 大号字/图形≥3.0", Double(ratio))
        resultLabel.numberOfLines = 0
        resultLabel.font = .monospacedSystemFont(ofSize: 13, weight: .medium)
        resultLabel.textAlignment = .center
        resultLabel.textColor = .label
        resultLabel.backgroundColor = .secondarySystemBackground
        resultLabel.layer.cornerRadius = 10
        resultLabel.layer.masksToBounds = true
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultLabel)
        NSLayoutConstraint.activate([
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resultLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            resultLabel.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
}

// MARK: - D. EventHandlers 闭包式

final class Modern2_0EventHandlersViewController: Modern2_0BaseViewController {

    private let logView: UITextView = {
        let t = UITextView()
        t.isEditable = false
        t.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        t.backgroundColor = .secondarySystemBackground
        t.layer.cornerRadius = 10
        return t
    }()

    override func configure() {
        super.configure()
        segmentedView.eventHandlers = TFYSwiftViewEventHandlers(
            didSelect: { [weak self] _, index in
                self?.log("didSelect: \(index)")
            },
            didClickSelect: { [weak self] _, index in
                self?.log("didClickSelect: \(index)")
            },
            didScrollSelect: { [weak self] _, index in
                self?.log("didScrollSelect: \(index)")
            },
            scrollingProgress: { [weak self] _, from, to, percent in
                self?.log(String(format: "progress: %d→%d  %.2f", from, to, Double(percent)))
            })

        logView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logView)
        NSLayoutConstraint.activate([
            logView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            logView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            logView.heightAnchor.constraint(equalToConstant: 160),
            logView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
    }

    private func log(_ line: String) {
        let prefix = logView.text.isEmpty ? "" : "\n"
        logView.text.append(prefix + line)
        let range = NSRange(location: logView.text.count - 1, length: 1)
        logView.scrollRangeToVisible(range)
    }
}

// MARK: - D. Combine Publishers

final class Modern2_0CombineViewController: Modern2_0BaseViewController {

    private var bag = Set<AnyCancellable>()
    private let indexLabel = UILabel()
    private let progressLabel = UILabel()

    override func configure() {
        super.configure()

        segmentedView.selectedIndexPublisher
            .sink { [weak self] idx in
                self?.indexLabel.text = "selectedIndex = \(idx)"
            }
            .store(in: &bag)

        segmentedView.scrollingProgressPublisher
            .throttle(for: .milliseconds(32), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] tuple in
                self?.progressLabel.text = String(format: "progress: %d → %d  ·  %.2f",
                                                  tuple.from, tuple.to, Double(tuple.percent))
            }
            .store(in: &bag)

        [indexLabel, progressLabel].forEach {
            $0.font = .monospacedSystemFont(ofSize: 14, weight: .medium)
            $0.textColor = .label
            $0.textAlignment = .center
        }

        let stack = UIStackView(arrangedSubviews: [indexLabel, progressLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .secondarySystemBackground
        stack.layer.cornerRadius = 12
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
    }
}

// MARK: - D. async / await

final class Modern2_0AsyncSelectViewController: Modern2_0BaseViewController {

    override func configure() {
        super.configure()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Run",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(run))
    }

    @objc private func run() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            let sequence = [5, 2, 0, 3, 1]
            for idx in sequence {
                await self.segmentedView.selectItem(at: idx, animated: true)
                try? await Task.sleep(nanoseconds: 150_000_000)
            }
        }
    }
}

// MARK: - D. SwiftUI · TFYSwiftPagingContainer

final class Modern2_0SwiftUIContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let host = UIHostingController(rootView: Modern2_0SwiftUIDemo())
        addChild(host)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        host.didMove(toParent: self)
    }
}

private struct Modern2_0SwiftUIDemo: View {
    @State private var index = 0
    private let titles = ["首页", "热门", "推荐", "收藏", "设置"]

    var body: some View {
        TFYSwiftPagingContainer(titles: titles,
                                selectedIndex: $index,
                                segmentedHeight: 44,
                                customizer: { view, ds in
            ds.titleNormalColor = UIColor.secondaryLabel
            ds.titleSelectedColor = UIColor.label
            ds.titleNormalFont = .systemFont(ofSize: 15)
            ds.titleSelectedFont = .systemFont(ofSize: 15, weight: .semibold)
            let capsule = TFYSwiftIndicatorCapsuleView()
            capsule.indicatorColor = UIColor.systemBlue.withAlphaComponent(0.28)
            capsule.borderColor = .systemBlue
            capsule.borderWidth = 1.5
            capsule.indicatorHeight = 32
            capsule.indicatorWidthIncrement = 16
            view.indicators = [capsule]
        }) {
            Modern2_0SwiftUIPage(index: 0, title: titles[0])
            Modern2_0SwiftUIPage(index: 1, title: titles[1])
            Modern2_0SwiftUIPage(index: 2, title: titles[2])
            Modern2_0SwiftUIPage(index: 3, title: titles[3])
            Modern2_0SwiftUIPage(index: 4, title: titles[4])
        }
    }
}

private struct Modern2_0SwiftUIPage: View {
    let index: Int
    let title: String

    var body: some View {
        let hue = Double(index) * 0.13
        return ZStack {
            Color(hue: hue.truncatingRemainder(dividingBy: 1),
                  saturation: 0.2,
                  brightness: 0.97)
                .ignoresSafeArea()
            VStack(spacing: 12) {
                Text("SwiftUI Page #\(index)")
                    .font(.title2.weight(.semibold))
                Text(title)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - A. SwiftUI 仅标题条

final class Modern2_0SwiftUIBarViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let host = UIHostingController(rootView: Modern2_0SwiftUIBarDemo())
        addChild(host)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        host.didMove(toParent: self)
    }
}

private struct Modern2_0SwiftUIBarDemo: View {
    @State private var index = 0
    private let titles = ["发现", "关注", "同城", "直播"]

    var body: some View {
        VStack(spacing: 16) {
            TFYSwiftSegmentedView(titles: titles, selectedIndex: $index) { view, ds in
                ds.titleNormalColor = .secondaryLabel
                ds.titleSelectedColor = .systemPink
                ds.isTitleZoomEnabled = true
                let line = TFYSwiftIndicatorLineView()
                line.indicatorColor = .systemPink
                line.indicatorWidth = 20
                view.indicators = [line]
                view.isHapticEnabled = true
            }
            .frame(height: 44)

            Text("选中：\(titles[index]) (#\(index))")
                .font(.headline)
                .foregroundStyle(.primary)
            Spacer()
        }
        .padding(.top, 12)
    }
}

// MARK: - A. RTL

final class RTLSegmentedDemoViewController: Modern2_0BaseViewController {
    private let rtlTitles = ["الرئيسية", "رائج", "مفضل", "إعدادات"]

    override func configure() {
        view.semanticContentAttribute = .forceRightToLeft
        segmentedView.semanticContentAttribute = .forceRightToLeft

        let ds = TFYSwiftTitleDataSource()
        ds.titles = rtlTitles
        ds.titleNormalColor = .secondaryLabel
        ds.titleSelectedColor = .label
        ds.titleNormalFont = .systemFont(ofSize: 15)
        ds.titleSelectedFont = .systemFont(ofSize: 15, weight: .semibold)
        ds.isTitleColorGradientEnabled = true
        dataSourceStrongRef = ds
        segmentedView.dataSource = ds

        let indicator = TFYSwiftIndicatorLineView()
        indicator.indicatorColor = .systemTeal
        segmentedView.indicators = [indicator]
        segmentedView.isHapticEnabled = true
    }

    override func numberOfLists(in listContainerView: TFYSwiftListContainerView) -> Int {
        rtlTitles.count
    }

    override func listContainerView(_ listContainerView: TFYSwiftListContainerView,
                                    initListAt index: Int) -> TFYSwiftListContainerViewListDelegate {
        Modern2_0PageViewController(index: index, title: rtlTitles[safe: index] ?? "")
    }
}

// MARK: - A. PagingSmoothView

final class PagingSmoothDemoViewController: UIViewController {
    private var pagingView: TFYSwiftPagingSmoothView!
    private let titles = ["动态", "作品", "喜欢"]
    private lazy var segmentedDataSource: TFYSwiftTitleDataSource = {
        let ds = TFYSwiftTitleDataSource()
        ds.titles = titles
        ds.titleNormalColor = .secondaryLabel
        ds.titleSelectedColor = .label
        ds.isTitleZoomEnabled = true
        return ds
    }()
    private lazy var segmentedView: TFYSwiftView = {
        let view = TFYSwiftView()
        view.dataSource = segmentedDataSource
        view.isContentScrollViewClickTransitionAnimationEnabled = false
        let line = TFYSwiftIndicatorLineView()
        line.indicatorColor = .systemBlue
        line.indicatorWidth = 28
        view.indicators = [line]
        return view
    }()
    private lazy var headerView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemIndigo
        let label = UILabel()
        label.text = "Smooth Paging Header"
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: v.centerYAnchor)
        ])
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        pagingView = TFYSwiftPagingSmoothView(dataSource: self)
        pagingView.delegate = self
        view.addSubview(pagingView)
        segmentedView.listContainer = nil
        // Smooth 自己管理横向列表；手动同步选中态
        segmentedView.contentScrollView = pagingView.listCollectionView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pagingView.frame = view.bounds
    }
}

extension PagingSmoothDemoViewController: TFYSwiftPagingSmoothViewDataSource {
    func heightForPagingHeader(in pagingView: TFYSwiftPagingSmoothView) -> CGFloat { 180 }
    func viewForPagingHeader(in pagingView: TFYSwiftPagingSmoothView) -> UIView { headerView }
    func heightForPinHeader(in pagingView: TFYSwiftPagingSmoothView) -> CGFloat { 50 }
    func viewForPinHeader(in pagingView: TFYSwiftPagingSmoothView) -> UIView {
        segmentedView.backgroundColor = .systemBackground
        return segmentedView
    }
    func numberOfLists(in pagingView: TFYSwiftPagingSmoothView) -> Int { titles.count }
    func pagingView(_ pagingView: TFYSwiftPagingSmoothView, initListAtIndex index: Int) -> TFYSwiftPagingSmoothViewListViewDelegate {
        let list = SmoothDemoListView()
        list.dataSource = (0..<30).map { "Smooth List \(index) · Row \($0)" }
        return list
    }
}

extension PagingSmoothDemoViewController: TFYSwiftPagingSmoothViewDelegate {
    func pagingSmoothViewDidScroll(_ scrollView: UIScrollView) {}
}

private final class SmoothDemoListView: UIView, TFYSwiftPagingSmoothViewListViewDelegate, UITableViewDataSource, UITableViewDelegate {
    var dataSource: [String] = []
    private let tableView = UITableView(frame: .zero, style: .plain)

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        addSubview(tableView)
    }
    required init?(coder: NSCoder) { fatalError() }
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    func listView() -> UIView { self }
    func listScrollView() -> UIScrollView { tableView }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { dataSource.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
}

// MARK: - A. PagingListRefreshView

final class PagingListRefreshDemoViewController: UIViewController {
    private var pagingView: TFYSwiftPagingListRefreshView!
    private let titles = ["关注", "推荐", "附近"]
    private lazy var segmentedDataSource: TFYSwiftTitleDataSource = {
        let ds = TFYSwiftTitleDataSource()
        ds.titles = titles
        ds.titleNormalColor = .secondaryLabel
        ds.titleSelectedColor = .systemOrange
        ds.isTitleColorGradientEnabled = true
        return ds
    }()
    private lazy var segmentedView: TFYSwiftView = {
        let v = TFYSwiftView()
        v.dataSource = segmentedDataSource
        v.isContentScrollViewClickTransitionAnimationEnabled = false
        let line = TFYSwiftIndicatorLineView()
        line.indicatorColor = .systemOrange
        v.indicators = [line]
        return v
    }()
    private lazy var headerContainer: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 160))
        v.backgroundColor = .systemOrange.withAlphaComponent(0.85)
        let label = UILabel()
        label.text = "下拉刷新 Header"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: v.centerYAnchor)
        ])
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        pagingView = TFYSwiftPagingListRefreshView(delegate: self)
        view.addSubview(pagingView)
        segmentedView.listContainer = pagingView.listContainerView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pagingView.frame = view.bounds
    }
}

extension PagingListRefreshDemoViewController: TFYSwiftPagingViewDelegate {
    func tableHeaderViewHeight(in pagingView: TFYSwiftPagingView) -> Int { 160 }
    func tableHeaderView(in pagingView: TFYSwiftPagingView) -> UIView { headerContainer }
    func heightForPinSectionHeader(in pagingView: TFYSwiftPagingView) -> Int { 50 }
    func viewForPinSectionHeader(in pagingView: TFYSwiftPagingView) -> UIView {
        segmentedView.backgroundColor = .systemBackground
        return segmentedView
    }
    func numberOfLists(in pagingView: TFYSwiftPagingView) -> Int { titles.count }
    func pagingView(_ pagingView: TFYSwiftPagingView, initListAtIndex index: Int) -> TFYSwiftPagingViewListViewDelegate {
        let list = RefreshDemoListView()
        list.dataSource = (0..<40).map { "Refresh List \(index) · \($0)" }
        list.beginFirstRefresh()
        return list
    }
}

private final class RefreshDemoListView: UIView, TFYSwiftPagingViewListViewDelegate, UITableViewDataSource, UITableViewDelegate {
    var dataSource: [String] = []
    private var scrollCallback: ((UIScrollView) -> Void)?
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let refresh = UIRefreshControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        refresh.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = refresh
        addSubview(tableView)
    }
    required init?(coder: NSCoder) { fatalError() }
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    func beginFirstRefresh() { tableView.reloadData() }
    @objc private func onRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.refresh.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    func listView() -> UIView { self }
    func listScrollView() -> UIScrollView { tableView }
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) { scrollCallback = callback }
    func scrollViewDidScroll(_ scrollView: UIScrollView) { scrollCallback?(scrollView) }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { dataSource.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
}

// MARK: - A. Accessory / Equal / Enabled / ImageTypes / ListPaging

final class AccessoryChromeDemoViewController: Modern2_0BaseViewController {
    override func configure() {
        super.configure()
        let filter = UIButton(type: .system)
        filter.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        filter.frame = CGRect(x: 0, y: 0, width: 36, height: 44)
        filter.addTarget(self, action: #selector(onFilter), for: .touchUpInside)

        let more = UIButton(type: .system)
        more.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        more.frame = CGRect(x: 0, y: 0, width: 36, height: 44)
        more.addTarget(self, action: #selector(onMore), for: .touchUpInside)

        segmentedView.leadingAccessoryView = filter
        segmentedView.trailingAccessoryView = more
        segmentedView.accessorySpacing = 4
        segmentedView.indicators = [TFYSwiftIndicatorLineView()]
    }

    @objc private func onFilter() {
        let alert = UIAlertController(title: "筛选", message: "leadingAccessoryView 点击", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func onMore() {
        let alert = UIAlertController(title: "更多", message: "trailingAccessoryView 点击", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

final class EqualWidthEnabledDeselectDemoViewController: Modern2_0BaseViewController {
    private let shortTitles = ["推荐", "关注", "同城", "直播"]

    override func configure() {
        let ds = TFYSwiftTitleDataSource()
        ds.titles = shortTitles
        ds.itemWidthMode = .equal
        ds.itemSpacing = 0
        ds.isItemSpacingAverageEnabled = false
        ds.titleNormalColor = .secondaryLabel
        ds.titleSelectedColor = .systemBlue
        ds.titleNormalFont = .systemFont(ofSize: 15, weight: .medium)
        ds.titleSelectedFont = .systemFont(ofSize: 15, weight: .semibold)
        ds.itemEnabledStates = [true, true, false, true]
        ds.applyNumberBadges([0, 3, 0, 1])
        dataSourceStrongRef = ds
        segmentedView.dataSource = ds
        segmentedView.contentEdgeInsetLeft = 0
        segmentedView.contentEdgeInsetRight = 0
        segmentedView.allowsDeselection = true
        segmentedView.isHapticEnabled = true

        let bg = TFYSwiftIndicatorBackgroundView()
        bg.indicatorHeight = 32
        bg.indicatorWidthIncrement = 0
        bg.indicatorColor = UIColor.systemBlue.withAlphaComponent(0.15)
        segmentedView.indicators = [bg]
    }

    override func numberOfLists(in listContainerView: TFYSwiftListContainerView) -> Int {
        shortTitles.count
    }

    override func listContainerView(_ listContainerView: TFYSwiftListContainerView,
                                    initListAt index: Int) -> TFYSwiftListContainerViewListDelegate {
        Modern2_0PageViewController(index: index, title: shortTitles[safe: index] ?? "")
    }
}

final class TitleImageTypesDemoViewController: Modern2_0BaseViewController {
    private let mixTitles = ["首页", "视频", "消息", "我"]

    override func configure() {
        let ds = TFYSwiftTitleImageDataSource()
        ds.titles = mixTitles
        ds.titleImageTypes = [.topImage, .leftImage, .onlyTitle, .onlyImage]
        ds.normalImageInfos = ["house", "play.rectangle", "", "person"]
        ds.selectedImageInfos = ["house.fill", "play.rectangle.fill", "", "person.fill"]
        ds.loadImageClosure = { imageView, info in
            imageView.image = UIImage(systemName: info)
        }
        ds.imageSize = CGSize(width: 18, height: 18)
        ds.titleImageSpacing = 4
        ds.titleNormalColor = .secondaryLabel
        ds.titleSelectedColor = .label
        dataSourceStrongRef = ds
        segmentedView.dataSource = ds
        segmentedView.indicators = [TFYSwiftIndicatorLineView()]
    }

    override func numberOfLists(in listContainerView: TFYSwiftListContainerView) -> Int {
        mixTitles.count
    }

    override func listContainerView(_ listContainerView: TFYSwiftListContainerView,
                                    initListAt index: Int) -> TFYSwiftListContainerViewListDelegate {
        Modern2_0PageViewController(index: index, title: mixTitles[safe: index] ?? "")
    }
}

final class Modern2_0SwiftUIListPagingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let host = UIHostingController(rootView: Modern2_0SwiftUIListPagingDemo())
        addChild(host)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        host.didMove(toParent: self)
    }
}

private struct Modern2_0SwiftUIListPagingDemo: View {
    @State private var index = 0
    private let titles = ["发现", "关注", "同城", "直播"]

    var body: some View {
        TFYSwiftListPagingContainer(titles: titles, selectedIndex: $index) { page in
            ZStack {
                Color(hue: Double(page) * 0.18, saturation: 0.18, brightness: 0.96)
                VStack(spacing: 8) {
                    Text("ListContainer Page \(page)")
                        .font(.title3.weight(.semibold))
                    Text(titles[page])
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
