# Getting Started

Integrate TFYSwiftSegmentedKit in a UIKit or SwiftUI app.

## Installation

### Swift Package Manager

```swift
.package(url: "https://github.com/13662049573/TFYSwiftSegmentedUilt.git", from: "2.0.0")
```

### CocoaPods

```ruby
pod 'TFYSwiftSegmentedKit', '~> 2.0'
```

## Minimum a UIKit segmented title bar

```swift
import TFYSwiftSegmentedKit

let view = TFYSwiftView()
let ds = TFYSwiftTitleDataSource()
ds.titles = ["Home", "Trending", "Library"]
ds.titleNormalColor = .secondaryLabel
ds.titleSelectedColor = .label

view.dataSource = ds
view.indicators = [TFYSwiftIndicatorLineView()]
view.defaultSelectedIndex = 0
view.reloadData()
```

## Add a paging container

```swift
let container = TFYSwiftListContainerView(dataSource: self, type: .collectionView)
view.contentScrollView = container.scrollView
view.listContainer = container
```

## Observe changes

```swift
view.eventHandlers = .init(didSelect: { _, idx in
    print("idx =", idx)
})

view.selectedIndexPublisher
    .sink { print("combine idx =", $0) }
    .store(in: &bag)

Task { await view.selectItem(at: 2, animated: true) }
```
