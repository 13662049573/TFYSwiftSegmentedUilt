# TFYSwiftSegmentedKit

[Version](https://cocoapods.org/pods/TFYSwiftSegmentedKit)
[License](https://cocoapods.org/pods/TFYSwiftSegmentedKit)
[Platform](https://cocoapods.org/pods/TFYSwiftSegmentedKit)
[Swift](https://swift.org)
[iOS](https://developer.apple.com/ios/)
[SPM](https://swift.org/package-manager/)
[CI](.github/workflows/ci.yml)

> 🇨🇳 中文版（本节） · 🇺🇸 [English](#english)

TFYSwiftSegmentedKit 是一个纯 Swift 的分段选择器 / 分页标签组件库。从 2.0 起，框架彻底与 JXSegmentedView 解耦并全面现代化：提供了严格并发安全的底层、12+ 指示器、SwiftUI 封装、Combine 订阅、async API、拖拽重排、Context Menu、触感反馈以及开箱即用的 CI/Lint/测试闭环。

## 目录

- [预览](#预览)
- [特性](#特性)
- [安装](#安装)
- [快速开始](#快速开始)
- [2.0 新能力速览](#20-新能力速览)
- [2.0.3 增量](#203-增量)
- [SwiftUI](#swiftui)
- [Combine / async](#combine--async)
- [指示器图库](#指示器图库)
- [可访问性 / 触感 / 减弱动画](#可访问性--触感--减弱动画)
- [Badge](#badge)
- [性能与诊断](#性能与诊断)
- [测试 & CI](#测试--ci)
- [迁移到 2.0](#迁移到-20)
- [更新日志](#更新日志)
- [许可证](#许可证)



## 预览

  

## 特性

- [x] 支持多种指示器样式
- [x] 支持标题文本渐变
- [x] 支持图文混排
- [x] 支持自定义标题样式
- [x] 支持动态数字显示
- [x] 支持点状装饰
- [x] 灵活的布局配置
- [x] 丰富的动画效果
- [x] 支持RTL布局
- [x] 支持自适应布局
- [x] 支持列表容器联动
- [x] 支持等宽布局 / item 禁用态 / 反选 / Momentary
- [x] 支持左右 Accessory、一等公民 Badge API
- [x] 支持 SwiftUI（SegmentedView / PagingContainer / ListPagingContainer）
- [x] 支持 Swift Package Manager / CocoaPods
- [x] 支持图片资源自定义 Bundle
- [x] 支持可访问性选中状态
- [x] 支持安全单项/批量刷新
- [x] 完整的示例代码



## 要求

- iOS 15.0+
- Swift 5.0+
- Xcode 14.0+



## 功能列表


| 模块             | 说明    | 示例         |
| -------------- | ----- | ---------- |
| Base           | 核心功能  | 基础布局和配置    |
| Title          | 标题样式  | 普通文本展示     |
| Indicator      | 指示器   | 下划线、背景等指示器 |
| Number         | 数字显示  | 角标、计数器等    |
| Dot            | 点状装饰  | 小红点、徽标等    |
| TitleImage     | 图文混排  | 图标+文字组合    |
| TitleGradient  | 标题渐变  | 文字颜色渐变     |
| TitleOrImage   | 标题或图片 | 可切换的图文显示   |
| AttributeTitle | 富文本标题 | 复杂文本样式     |
| PagingView     | 分页联动  | 主从表 / SmoothPaging |
| SwiftUI        | SwiftUI | Segmented / Paging / ListPaging |
| Tool           | 工具    | 辅助功能       |




## 安装



### Swift Package Manager

在 Xcode 中选择 `File > Add Package Dependencies...`，输入仓库地址：

```text
https://github.com/13662049573/TFYSwiftSegmentedUilt.git
```

然后选择 `TFYSwiftSegmentedKit` 添加到你的 iOS Target。代码中直接导入：

```swift
import TFYSwiftSegmentedKit
```



### CocoaPods

1. 在 Podfile 中添加依赖：

```ruby
# 完整安装（默认含全部 subspec，含 SwiftUI）
pod 'TFYSwiftSegmentedKit', '~> 2.0.3'

# 按需安装
pod 'TFYSwiftSegmentedKit/TFYSwiftBase'        # 核心功能
pod 'TFYSwiftSegmentedKit/TFYSwiftTitle'       # 标题样式
pod 'TFYSwiftSegmentedKit/TFYSwiftIndicator'   # 指示器
pod 'TFYSwiftSegmentedKit/TFYSwiftNumber'      # 数字显示
pod 'TFYSwiftSegmentedKit/TFYSwiftDot'         # 点状装饰
pod 'TFYSwiftSegmentedKit/TFYSwiftTitleImage'  # 图文混排
pod 'TFYSwiftSegmentedKit/TFYSwiftTitleGradient' # 标题渐变
pod 'TFYSwiftSegmentedKit/TFYSwiftTitleOrImage'  # 标题或图片
pod 'TFYSwiftSegmentedKit/TFYSwiftAttributeTitle' # 富文本标题
pod 'TFYSwiftSegmentedKit/TFYSwiftTool'          # 工具
pod 'TFYSwiftSegmentedKit/TFYSwiftPagingView'    # Paging 联动
pod 'TFYSwiftSegmentedKit/TFYSwiftSwiftUI'       # SwiftUI 封装
```

1. 执行安装：

```bash
pod install
```



## 快速开始

1. 导入模块：

```swift
import TFYSwiftSegmentedKit
```

1. 创建分段选择器：

```swift
class ViewController: UIViewController {
    private let titles = ["首页", "视频", "图片", "音乐", "书籍"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let segmentedView = TFYSwiftView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 50))
        segmentedView.dataSource = self
        segmentedView.delegate = self
        view.addSubview(segmentedView)
        
        // 创建指示器
        let lineView = TFYSwiftIndicatorLineView()
        lineView.indicatorColor = .red
        lineView.indicatorWidth = 20
        segmentedView.indicators = [lineView]
    }
}
```

1. 实现数据源和代理：

```swift
extension ViewController: TFYSwiftViewDataSource {
    func itemDataSource(in segmentedView: TFYSwiftView) -> [TFYSwiftBaseItemModel] {
        return titles.map { title -> TFYSwiftBaseItemModel in
            let itemModel = TFYSwiftTitleItemModel()
            itemModel.title = title
            itemModel.titleNormalColor = .gray
            itemModel.titleSelectedColor = .red
            itemModel.titleNormalFont = .systemFont(ofSize: 14)
            itemModel.titleSelectedFont = .boldSystemFont(ofSize: 16)
            return itemModel
        }
    }
    
    func segmentedView(_ segmentedView: TFYSwiftView, cellForItemAt index: Int) -> TFYSwiftBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cellID", at: index) as! TFYSwiftTitleCell
        return cell
    }
}

extension ViewController: TFYSwiftViewDelegate {
    func segmentedView(_ segmentedView: TFYSwiftView, didSelectedItemAt index: Int) {
        print("Selected index: \(index)")
    }
}
```



## 自定义样式



### 指示器样式

```swift
let lineView = TFYSwiftIndicatorLineView()
lineView.indicatorColor = .red
lineView.indicatorWidth = 20
segmentedView.indicators = [lineView]
```



### 标题渐变

```swift
let itemModel = TFYSwiftTitleItemModel()
itemModel.titleNormalColor = .gray
itemModel.titleSelectedColor = .red
itemModel.isTitleZoomEnabled = true
```



### 图文混排

```swift
let itemModel = TFYSwiftTitleImageItemModel()
itemModel.title = "首页"
itemModel.normalImageInfo = "home_normal"
itemModel.selectedImageInfo = "home_selected"
itemModel.imageSize = CGSize(width: 20, height: 20)
```

如果图片资源不在 main bundle，例如业务模块或 Swift Package 内部资源，可以在数据源上指定 Bundle：

```swift
let dataSource = TFYSwiftTitleImageDataSource()
dataSource.titles = ["首页", "消息"]
dataSource.normalImageInfos = ["home_normal", "message_normal"]
dataSource.selectedImageInfos = ["home_selected", "message_selected"]
dataSource.imageBundle = Bundle(for: ResourceMarker.self)
```



### 运行时刷新

```swift
segmentedView.reloadItem(at: 0)
segmentedView.reloadItems(at: [1, 2, 3])
segmentedView.selectItemAt(index: 2, animated: false)
segmentedView.scrollToSelectedItem(animated: true)
```



### 列表容器联动

```swift
let listContainerView = TFYSwiftListContainerView(dataSource: self)
view.addSubview(listContainerView)
segmentedView.listContainer = listContainerView
```



## 示例项目

克隆仓库并运行示例项目：

```bash
git clone https://github.com/13662049573/TFYSwiftSegmentedUilt.git
cd TFYSwiftSegmentedUilt
pod install
open TFYSwiftSegmentedUilt.xcworkspace
```



## 常见问题



### Q: 如何自定义指示器样式？

A: 继承 TFYSwiftIndicatorProtocol 协议，实现自定义指示器。

### Q: 如何实现自定义布局？

A: 通过实现 TFYSwiftViewDataSource 的相关方法自定义布局参数。

### Q: 如何处理内存管理？

A: 框架内部已处理循环引用问题，使用时注意避免强引用即可。

## 作者

田风有, [420144542@qq.com](mailto:420144542@qq.com)

## 贡献

欢迎提交 Issue 和 Pull Request。

## 许可证

TFYSwiftSegmentedKit 基于 MIT 许可证开源。详见 [LICENSE](LICENSE) 文件。

## 2.0 新能力速览


| 模块      | 新能力                                                                                                                   |
| ------- | --------------------------------------------------------------------------------------------------------------------- |
| 并发      | `SWIFT_STRICT_CONCURRENCY=targeted`，`TFYSwiftTextMeasure` `@unchecked Sendable`，主线程 API 收敛                            |
| 性能      | `UICollectionViewDiffableDataSource` 开关、`TFYSwiftScrollDelegateMultiplexer` 多代理复用、`TFYSwiftDiagnostics` `os_signpost` |
| 指示器     | 新增 **Capsule / ElasticLine / Blur / Symbol** 4 种，共 12+                                                                |
| 交互      | 拖拽重排（`isReorderingEnabled`）、Context Menu、Long Press 钩子、`TFYSwiftHapticEngine`                                         |
| 可访问性    | 自动订阅 `isReduceMotionEnabled`、`accessibilityValue`/`accessibilityHint`、`TFYSwiftViewTool.contrastRatio`                |
| API     | `TFYSwiftViewEventHandlers`、`selectedIndexPublisher`、`scrollingProgressPublisher`、`async selectItem(at:animated:)`    |
| SwiftUI | `TFYSwiftSegmentedView`、`TFYSwiftPagingContainer(ViewBuilder)`、`TFYSwiftListPagingContainer` |
| 布局 / 交互 | `itemWidthMode`、`itemEnabledStates`、`allowsDeselection` / `isMomentary`、左右 Accessory |
| 工具链     | SPM 工作区联合、XCTest 扩充、GitHub Actions CI（build / test-spm / lint / pod-lint）                                             |




## 2.0.3 增量

当前推荐版本：**2.0.3**（2026-07-23）。相对 2.0.0 的主要增量：

### 等宽 · 禁用 · 反选

```swift
let ds = TFYSwiftTitleDataSource()
ds.titles = ["推荐", "关注", "同城", "直播"]
ds.itemWidthMode = .equal
ds.itemEnabledStates = [true, true, false, true] // 「同城」禁用：点击拦截，滑动自动跳过
ds.applyNumberBadges([0, 3, 0, 1])

segmentedView.allowsDeselection = true   // 再点已选中项可取消选中
segmentedView.isMomentary = false
segmentedView.clearSelection()           // 代码清除选中态
```

滑动经过禁用项时：内容页与指示器只会落到滑动方向上的**相邻启用项**（例如直播 → 关注，不会一次冲到推荐），且标题 / 指示器 / 内容保持同步。

### Accessory

```swift
segmentedView.leadingAccessoryView = filterButton
segmentedView.trailingAccessoryView = moreButton
segmentedView.accessorySpacing = 8
```

### SwiftUI ListPaging

```swift
TFYSwiftListPagingContainer(titles: titles, selectedIndex: $index) {
    // 真实 ListContainer 联动，而非仅 TabView 包裹
}
```

完整变更见 [CHANGELOG.md](CHANGELOG.md)。




## SwiftUI

```swift
@State private var index = 0

TFYSwiftPagingContainer(titles: ["Home", "Trending", "Library"],
                       selectedIndex: $index) {
    HomePage()
    TrendingPage()
    LibraryPage()
}
```



## Combine / async

```swift
view.selectedIndexPublisher
    .sink { print("selected = \($0)") }
    .store(in: &bag)

Task {
    await view.selectItem(at: 2, animated: true)
    print("done")
}
```



## 可访问性 / 触感 / 减弱动画

```swift
view.isHapticEnabled = true
view.isRespectReduceMotionEnabled = true
TFYSwiftViewTool.warnIfContrastTooLow(foreground: .white,
                                      background: .systemBlue)
```



## Badge

```swift
titleCell.tfy_applyBadge(TFYSwiftBadgeConfiguration(style: .number(12),
                                                   backgroundColor: .systemRed))
```



## 性能与诊断

```swift
TFYSwiftDiagnostics.shared.isSignpostEnabled = true
TFYSwiftDiagnostics.shared.isVerboseLoggingEnabled = true
view.isDiffableDataSourceEnabled = true
```



## 测试 & CI

```bash
xcodebuild test -workspace TFYSwiftSegmentedKit.xcworkspace \
                -scheme TFYSwiftSegmentedKit \
                -destination 'platform=iOS Simulator,name=iPhone 16'
swiftlint lint
pod lib lint TFYSwiftSegmentedKit.podspec --allow-warnings
```



## 迁移到 2.0

- 新代码请使用 `TFYSwiftListContainerBase` 协议接收容器，避免绑定具体类。
- `itemContentWidth` 已标记 `@available(*, deprecated, renamed: "itemWidth")`，请切换为 `itemWidth`。
- 具体变更详见 [MIGRATION.md](MIGRATION.md) 与 [CHANGELOG.md](CHANGELOG.md)。

## 更新日志

详见 [CHANGELOG.md](CHANGELOG.md)。最新发布：**2.0.3**。

---



# TFYSwiftSegmentedKit (English)

A pure-Swift segmented-control / paging-tab toolkit. Since v2.0 the framework is fully independent from JXSegmentedView, with strict-concurrency-ready internals, 12+ indicators, a SwiftUI wrapper, Combine/async APIs, drag-to-reorder, context menus, haptics, and an out-of-the-box CI / lint / test pipeline.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [What's New in 2.0](#whats-new-in-20)
- [What's New in 2.0.3](#whats-new-in-203)
- [SwiftUI](#swiftui-1)
- [Combine & async](#combine--async)
- [Indicators Gallery](#indicators-gallery)
- [Accessibility · Haptics · Reduce Motion](#accessibility--haptics--reduce-motion)
- [Badge](#badge-1)
- [Diagnostics](#diagnostics)
- [Testing & CI](#testing--ci)
- [Migration Guide](#migration-guide)
- [Changelog](#changelog-1)
- [License](#license-1)



## Features

- 12+ indicator styles (Line / DoubleLine / Dot / Triangle / Rainbow / Background / Gradient / GradientLine / Image / Capsule / ElasticLine / Blur / Symbol)
- Title / Title+Image / Image-over-Title / Attributed / Dot / Number / Gradient cells
- RTL support, dynamic type, accessibility traits & values
- Paging container + smooth paging variant
- Drag-to-reorder, context menu, long-press hook, haptic feedback
- SwiftUI: `TFYSwiftSegmentedView`, `TFYSwiftPagingContainer`, `TFYSwiftListPagingContainer`
- Equal-width layout, per-item enabled states (swipe skips disabled pages), deselection / momentary
- Leading / trailing accessories, first-class badge helpers
- Combine publishers (`selectedIndexPublisher`, `scrollingProgressPublisher`)
- `async func selectItem(at:animated:)`
- SPM, CocoaPods, Xcode 16+, iOS 15+



## Installation



### Swift Package Manager

```swift
.package(url: "https://github.com/13662049573/TFYSwiftSegmentedUilt.git", from: "2.0.3")
```



### CocoaPods

```ruby
pod 'TFYSwiftSegmentedKit', '~> 2.0.3'
```



## Quick Start

```swift
let view = TFYSwiftView()
let ds = TFYSwiftTitleDataSource()
ds.titles = ["Home", "Trending", "Library"]
view.dataSource = ds
view.indicators = [TFYSwiftIndicatorLineView()]
```



## What's New in 2.0

See the Chinese section above — all bullet points are identical in English. Highlights:

- Strict concurrency-targeted code base, thread-safe text measurement cache.
- `UICollectionViewDiffableDataSource` toggle, os_signpost diagnostics.
- 4 new indicators: Capsule, Elastic Line, Blur, Symbol.
- Drag-to-reorder, Context Menu, haptic & reduce-motion awareness.
- Event-handlers struct + Combine publishers + `async` selection.
- `TFYSwiftPagingContainer` SwiftUI ViewBuilder container.
- Unified `TFYSwiftListContainerBase` protocol for both list containers.
- GitHub Actions CI (build / test-spm / lint / pod-lint).



## What's New in 2.0.3

Recommended version: **2.0.3** (2026-07-23).

- `itemWidthMode`, `itemEnabledStates` (tap blocked + swipe skips disabled pages, one adjacent enabled step at a time)
- `allowsDeselection` / `isMomentary` / `clearSelection()`
- Leading / trailing accessories
- Badge helpers + `titleImageTypes`
- SwiftUI `TFYSwiftListPagingContainer`
- Pod modular build fix: `scrollAnimationDuration` lives on `TFYSwiftIndicatorProtocol` (Base), so `TFYSwiftBase` lint no longer needs Indicator

Full notes: [CHANGELOG.md](CHANGELOG.md).



## Changelog

See [CHANGELOG.md](CHANGELOG.md). Latest: **2.0.3**.



## License

MIT — see [LICENSE](LICENSE).
