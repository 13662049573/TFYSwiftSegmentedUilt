//
//  Modern2_0ListViewController.swift
//  TFYSwiftSegmentedUilt
//
//  入口列表：展示 TFYSwiftSegmentedKit 2.0 新能力的 Demo。
//  iOS 15+ / Swift 5.9+ / Swift 6 concurrency targeted。
//

import UIKit

final class Modern2_0ListViewController: UITableViewController {

    struct Row {
        let title: String
        let subtitle: String
        let make: () -> UIViewController
    }

    struct Section {
        let header: String
        let rows: [Row]
    }

    private let sections: [Section] = [
        Section(header: "A · 布局与分页补齐", rows: [
            Row(title: "RTL 从右到左",
                subtitle: "强制 RTL semanticAttribute + 阿拉伯语标题",
                make: { RTLSegmentedDemoViewController() }),
            Row(title: "PagingSmoothView 平滑嵌套",
                subtitle: "Header + Pin + 列表联动（Smooth）",
                make: { PagingSmoothDemoViewController() }),
            Row(title: "嵌套·超长标签不跟手",
                subtitle: "二级标签过长横滑时，一级分页不应抖动",
                make: { NestLongTitleViewController() }),
            Row(title: "PagingListRefreshView 下拉刷新",
                subtitle: "悬浮头 + 列表 UIRefreshControl",
                make: { PagingListRefreshDemoViewController() }),
            Row(title: "SwiftUI · TFYSwiftSegmentedView",
                subtitle: "仅标题条 Representable（无分页容器）",
                make: { Modern2_0SwiftUIBarViewController() }),
            Row(title: "左右 Accessory（筛选/更多）",
                subtitle: "leadingAccessoryView / trailingAccessoryView",
                make: { AccessoryChromeDemoViewController() }),
            Row(title: "等宽 + 禁用态 + 反选",
                subtitle: "itemWidthMode.equal / itemEnabledStates / allowsDeselection",
                make: { EqualWidthEnabledDeselectDemoViewController() }),
            Row(title: "混排 titleImageTypes",
                subtitle: "按 index 指定图文布局类型",
                make: { TitleImageTypesDemoViewController() }),
            Row(title: "SwiftUI · ListPagingContainer",
                subtitle: "真实 ListContainer 联动（指示器进度）",
                make: { Modern2_0SwiftUIListPagingViewController() })
        ]),
        Section(header: "B · 性能与诊断", rows: [
            Row(title: "UICollectionViewDiffableDataSource",
                subtitle: "isDiffableDataSourceEnabled = true，带降级开关",
                make: { Modern2_0DiffableDataSourceViewController() }),
            Row(title: "os_signpost 诊断",
                subtitle: "TFYSwiftDiagnostics.shared.isSignpostEnabled / isVerbose",
                make: { Modern2_0DiagnosticsViewController() })
        ]),
        Section(header: "C · 新指示器 / 新交互", rows: [
            Row(title: "Capsule 胶囊指示器",
                subtitle: "TFYSwiftIndicatorCapsuleView（边框 / 阴影 / 圆角 / verticalOffset）",
                make: { Modern2_0IndicatorShowcaseViewController(kind: .capsule) }),
            Row(title: "ElasticLine 弹性下划线",
                subtitle: "TFYSwiftIndicatorElasticLineView（Material 3 风格）",
                make: { Modern2_0IndicatorShowcaseViewController(kind: .elasticLine) }),
            Row(title: "Blur 毛玻璃指示器",
                subtitle: "TFYSwiftIndicatorBlurView（UIVisualEffectView，深浅色自适应）",
                make: { Modern2_0IndicatorShowcaseViewController(kind: .blur) }),
            Row(title: "Symbol SF 符号指示器",
                subtitle: "TFYSwiftIndicatorSymbolView",
                make: { Modern2_0IndicatorShowcaseViewController(kind: .symbol) }),
            Row(title: "触感反馈 + Reduce Motion",
                subtitle: "isHapticEnabled / isRespectReduceMotionEnabled",
                make: { Modern2_0HapticReduceMotionViewController() }),
            Row(title: "Context Menu 长按菜单",
                subtitle: "isContextMenuEnabled + contextMenuProvider",
                make: { Modern2_0ContextMenuViewController() }),
            Row(title: "拖拽重排（可选）",
                subtitle: "isReorderingEnabled + didReorderItem",
                make: { Modern2_0ReorderViewController() }),
            Row(title: "Badge 角标（DataSource.badges）",
                subtitle: "TFYSwiftBadgeConfiguration 一等公民，随 cell 复用",
                make: { Modern2_0BadgeViewController() }),
            Row(title: "对比度校验（Debug）",
                subtitle: "TFYSwiftViewTool.contrastRatio / warnIfContrastTooLow",
                make: { Modern2_0ContrastViewController() })
        ]),
        Section(header: "D · API 现代化", rows: [
            Row(title: "EventHandlers 闭包式回调",
                subtitle: "TFYSwiftViewEventHandlers",
                make: { Modern2_0EventHandlersViewController() }),
            Row(title: "Combine Publishers",
                subtitle: "selectedIndexPublisher / scrollingProgressPublisher",
                make: { Modern2_0CombineViewController() }),
            Row(title: "async / await 选中",
                subtitle: "await view.selectItem(at:animated:)",
                make: { Modern2_0AsyncSelectViewController() }),
            Row(title: "SwiftUI · TFYSwiftPagingContainer",
                subtitle: "ViewBuilder 分页容器（公开 PagesBuilder）",
                make: { Modern2_0SwiftUIContainerViewController() })
        ])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TFYSwiftSegmentedKit 2.0"
        view.backgroundColor = .systemBackground
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }

    override func numberOfSections(in tableView: UITableView) -> Int { sections.count }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].header
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let row = sections[indexPath.section].rows[indexPath.row]
        cell.textLabel?.text = row.title
        cell.detailTextLabel?.text = row.subtitle
        cell.detailTextLabel?.textColor = .secondaryLabel
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = sections[indexPath.section].rows[indexPath.row]
        let vc = row.make()
        vc.title = row.title
        navigationController?.pushViewController(vc, animated: true)
    }
}
