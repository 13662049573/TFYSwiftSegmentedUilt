# Migration Guide — 1.x → 2.0

> TFYSwiftSegmentedKit 2.0 is fully independent from JXSegmentedView. Most
> source-level APIs remain the same, but a few modernization choices require
> small updates in calling code.

## Minimum versions

| Item | 1.x | 2.0 |
| --- | --- | --- |
| iOS | 11 | **13** |
| Swift | 5.0 | **5.9+ / 6.0** |
| Xcode | 14 | **16** |

## Behaviour changes

### 1. Strict concurrency

The target now builds with `SWIFT_STRICT_CONCURRENCY = targeted`. If you
subclass internal types (e.g. a custom indicator), annotate any shared state
with `@MainActor` or ensure it is `Sendable`.

### 2. Haptics & Reduce Motion

`TFYSwiftView` now fires `UISelectionFeedbackGenerator` on every user-driven
selection when `isHapticEnabled == true` (default). Opt-out:

```swift
view.isHapticEnabled = false
```

When `UIAccessibility.isReduceMotionEnabled` is on, transitions on
`contentScrollView` are forced `animated=false`. Opt-out:

```swift
view.isRespectReduceMotionEnabled = false
```

### 3. List container protocol

Both `TFYSwiftListContainerView` and `TFYSwiftPagingListContainerView` now
conform to the new `TFYSwiftListContainerBase` protocol. **Prefer accepting
the protocol instead of the concrete class** so that a later consolidation is
source-compatible:

```swift
// Before
func configure(container: TFYSwiftListContainerView) { /* ... */ }

// After
func configure(container: TFYSwiftListContainerBase) { /* ... */ }
```

### 4. Deprecated fields

| API | Replacement |
| --- | --- |
| `TFYSwiftBaseDataSource.itemContentWidth` | `itemWidth` |

Both still work in 2.0 but emit a deprecation warning.

## New APIs you should know

```swift
// Closure-style events (delegate still works in parallel)
view.eventHandlers = .init(didSelect: { _, index in
    print("selected", index)
})

// Combine
view.selectedIndexPublisher.sink { print("idx=\($0)") }

// async/await
Task { await view.selectItem(at: 2, animated: true) }

// SwiftUI
TFYSwiftPagingContainer(titles: ["A", "B"], selectedIndex: $idx) {
    PageA()
    PageB()
}

// Diagnostics
TFYSwiftDiagnostics.shared.isSignpostEnabled = true
```

## Checklist

- [ ] Bump minimum deployment target to iOS 13.
- [ ] Replace `itemContentWidth` usages.
- [ ] Update custom subclasses for strict concurrency.
- [ ] Prefer `TFYSwiftListContainerBase` in API signatures.
- [ ] Decide on `isHapticEnabled` / `isRespectReduceMotionEnabled` defaults.
- [ ] Enable the new CI workflow if you fork the repo.
