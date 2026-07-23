# Changelog

All notable changes to **TFYSwiftSegmentedKit** will be documented in this file.

The format is loosely based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-04-20

### Highlights

- 🎉 Full independence from JXSegmentedView. Renamed, re-implemented and
  modernized throughout.
- 🛡 `SWIFT_STRICT_CONCURRENCY = targeted`, thread-safe `TFYSwiftTextMeasure`
  marked `@unchecked Sendable`.
- 🚀 Brand-new diagnostics, indicators, interactions and SwiftUI wrappers.

### Added

- **Concurrency & tooling**
  - Xcode workspace (`TFYSwiftSegmentedKit.xcworkspace`) so `xcodebuild test`
    can drive SPM test targets.
  - `.swiftlint.yml` and `.github/workflows/ci.yml`
    (`build-app`, `test-spm`, `lint`, `pod-lint` jobs).
- **Performance**
  - `TFYSwiftView.isDiffableDataSourceEnabled` toggle with degradation path.
  - `TFYSwiftScrollDelegateMultiplexer` replaces KVO cycles inside
    `TFYSwiftPagingView`.
  - `TFYSwiftDiagnostics` (`os_signpost` + verbose flag).
  - Structured keys, partial invalidation and low-memory subscription in
    `TFYSwiftTextMeasure`.
  - Shared `CAShapeLayer` / `CAGradientLayer` cache in indicators.
- **Indicators**: `TFYSwiftIndicatorCapsuleView`,
  `TFYSwiftIndicatorElasticLineView`, `TFYSwiftIndicatorBlurView`,
  `TFYSwiftIndicatorSymbolView`.
- **Interactions**
  - `TFYSwiftHapticEngine` and `TFYSwiftView.isHapticEnabled`.
  - Auto-respect `UIAccessibility.isReduceMotionEnabled`.
  - Context menu provider hook (`contextMenuProvider`,
    `isContextMenuEnabled`).
  - Drag-to-reorder (`isReorderingEnabled`, `didReorderItem`).
  - `TFYSwiftBadgeConfiguration` + `UIView.tfy_applyBadge(_:)`.
  - `TFYSwiftViewTool.contrastRatio(_:_:)` and debug-only
    `warnIfContrastTooLow`.
- **APIs**
  - `TFYSwiftViewEventHandlers` closure bag.
  - `selectedIndexPublisher`, `scrollingProgressPublisher` (Combine).
  - `async func selectItem(at:animated:)`.
  - SwiftUI: `TFYSwiftPagingContainer(ViewBuilder)`.
  - Unified `TFYSwiftListContainerBase` protocol for both existing list
    containers.
- **Tests**: `TFYSwiftAccessibilityTests`, `TFYSwiftListContainerViewTests` and
  expanded item-frame coverage.

### Changed

- Default branch of the project is now polyglot: README has dual Chinese /
  English sections with a shared table of contents.
- Podspec and `Package.swift` are bumped to **2.0.0**.

### Deprecated

- `TFYSwiftBaseDataSource.itemContentWidth` (already annotated; kept for one
  more minor version).

### Migration

See [MIGRATION.md](MIGRATION.md) for a concrete diff-style migration guide.

## [1.x]

Historical 1.x releases. See git history for details.
