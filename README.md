# TFYSwiftSegmentedKit

[![Version](https://img.shields.io/cocoapods/v/TFYSwiftSegmentedKit.svg?style=flat)](https://cocoapods.org/pods/TFYSwiftSegmentedKit)
[![License](https://img.shields.io/cocoapods/l/TFYSwiftSegmentedKit.svg?style=flat)](https://cocoapods.org/pods/TFYSwiftSegmentedKit)
[![Platform](https://img.shields.io/cocoapods/p/TFYSwiftSegmentedKit.svg?style=flat)](https://cocoapods.org/pods/TFYSwiftSegmentedKit)
[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![Email](https://img.shields.io/badge/Email-420144542@qq.com-blue.svg)](mailto:420144542@qq.com)

TFYSwiftSegmentedKit 是一个功能强大的 iOS 分段选择器框架，使用 Swift 编写。它提供了丰富的自定义选项和灵活的配置方式。

## 预览

<img src="Resources/preview1.gif" width="200"> <img src="Resources/preview2.gif" width="200"> <img src="Resources/preview3.gif" width="200">

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
- [x] 完整的示例代码

## 要求

- iOS 15.0+
- Swift 5.0+
- Xcode 14.0+

## 功能列表

| 模块 | 说明 | 示例 |
|------|------|------|
| Base | 核心功能 | 基础布局和配置 |
| Title | 标题样式 | 普通文本展示 |
| Indicator | 指示器 | 下划线、背景等指示器 |
| Number | 数字显示 | 角标、计数器等 |
| Dot | 点状装饰 | 小红点、徽标等 |
| TitleImage | 图文混排 | 图标+文字组合 |
| TitleGradient | 标题渐变 | 文字颜色渐变 |
| TitleOrImage | 标题或图片 | 可切换的图文显示 |
| AttributeTitle | 富文本标题 | 复杂文本样式 |
| Tool | 工具 | 辅助功能 |

## 安装

### CocoaPods

1. 在 Podfile 中添加依赖：

```ruby
# 完整安装
pod 'TFYSwiftSegmentedKit'

# 按需安装
pod 'TFYSwiftSegmentedKit/Base'        # 核心功能
pod 'TFYSwiftSegmentedKit/Title'       # 标题样式
pod 'TFYSwiftSegmentedKit/Indicator'   # 指示器
pod 'TFYSwiftSegmentedKit/Number'      # 数字显示
pod 'TFYSwiftSegmentedKit/Dot'         # 点状装饰
pod 'TFYSwiftSegmentedKit/TitleImage'  # 图文混排
pod 'TFYSwiftSegmentedKit/TitleGradient' # 标题渐变
pod 'TFYSwiftSegmentedKit/TitleOrImage'  # 标题或图片
pod 'TFYSwiftSegmentedKit/AttributeTitle' # 富文本标题
pod 'TFYSwiftSegmentedKit/Tool'          # 工具
```

2. 执行安装：

```bash
pod install
```

## 快速开始

1. 导入模块：

```swift
import TFYSwiftSegmentedKit
```

2. 创建分段选择器：

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

3. 实现数据源和代理：

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
itemModel.normalImageInfo = UIImage(named: "home_normal")
itemModel.selectedImageInfo = UIImage(named: "home_selected")
itemModel.imageSize = CGSize(width: 20, height: 20)
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

田风有, 420144542@qq.com

## 贡献

欢迎提交 Issue 和 Pull Request。

## 许可证

TFYSwiftSegmentedKit 基于 MIT 许可证开源。详见 [LICENSE](LICENSE) 文件。
