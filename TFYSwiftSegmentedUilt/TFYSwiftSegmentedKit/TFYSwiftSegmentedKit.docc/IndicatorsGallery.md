# Indicators Gallery

Out-of-the-box indicators shipped with TFYSwiftSegmentedKit.

## Classic

- ``TFYSwiftIndicatorLineView`` — sliding underline.
- ``TFYSwiftIndicatorDoubleLineView`` — top + bottom underline.
- ``TFYSwiftIndicatorDotLineView`` — underline with a leading dot marker.
- ``TFYSwiftIndicatorRainbowLineView`` — animated rainbow gradient.
- ``TFYSwiftIndicatorTriangleView`` — triangle pointer.

## Background

- ``TFYSwiftIndicatorBackgroundView`` — solid rounded background.
- ``TFYSwiftIndicatorCapsuleView`` — capsule background with border + shadow.
- ``TFYSwiftIndicatorBlurView`` — `UIVisualEffectView` powered, light/dark aware.

## Gradient

- ``TFYSwiftIndicatorGradientView`` — gradient background (horizontal / diagonal).
- ``TFYSwiftIndicatorGradientLineView`` — gradient underline.

## Motion & Media

- ``TFYSwiftIndicatorElasticLineView`` — elastic stretch animation inspired by Material 3.
- ``TFYSwiftIndicatorImageView`` — image underlay.
- ``TFYSwiftIndicatorSymbolView`` — SF Symbol overlay for the selected tab.

## Composition

Multiple indicators can be stacked by assigning an array to `TFYSwiftView.indicators`. The framework paints them in the order provided, which lets you layer e.g. an underline on top of a capsule background.
