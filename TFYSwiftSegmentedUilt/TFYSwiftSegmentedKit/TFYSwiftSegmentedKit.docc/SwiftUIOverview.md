# SwiftUI

TFYSwiftSegmentedKit ships two SwiftUI views.

## ``TFYSwiftSegmentedView`` — title-driven bar

```swift
@State private var index = 0

TFYSwiftSegmentedView(
    titles: ["Home", "Trending", "Library"],
    selectedIndex: $index
) { view, ds in
    ds.titleSelectedColor = .systemBlue
    view.indicators = [TFYSwiftIndicatorCapsuleView()]
}
.frame(height: 44)
```

## ``TFYSwiftPagingContainer`` — full paging container

```swift
@State private var index = 0

TFYSwiftPagingContainer(titles: ["Home", "Trending", "Library"],
                        selectedIndex: $index,
                        segmentedHeight: 44) {
    HomePage()
    TrendingPage()
    LibraryPage()
}
```

The container stacks a `TFYSwiftSegmentedView` on top of a `TabView` that is driven by the same `selectedIndex` binding. Pages are declared with `ViewBuilder`, so conditional content is fully supported.
