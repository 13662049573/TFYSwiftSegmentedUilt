//
//  TFYSwiftCollectionView.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

/// 嵌套横向 UIScrollView 抢手势判定：内层还能沿当前方向滚时，外层分页容器不应跟手。
enum TFYSwiftNestedHorizontalPan {
    static let overflowSlop: CGFloat = 0.5
    static let edgeSlop: CGFloat = 0.5
    static let translationPriority: CGFloat = 0.5

    static func canAbsorb(in scrollView: UIScrollView, moveX: CGFloat) -> Bool {
        guard scrollView.isScrollEnabled, scrollView.isUserInteractionEnabled else {
            return false
        }
        let inset = scrollView.adjustedContentInset
        let overflow = scrollView.contentSize.width - scrollView.bounds.width + inset.left + inset.right
        guard overflow > overflowSlop else {
            return false
        }
        let minX = -inset.left
        let maxX = max(minX, scrollView.contentSize.width - scrollView.bounds.width + inset.right)
        let offsetX = scrollView.contentOffset.x
        let canScrollLeading = offsetX > minX + edgeSlop
        let canScrollTrailing = offsetX < maxX - edgeSlop
        if abs(moveX) < 0.1 {
            return canScrollLeading && canScrollTrailing
        }
        if moveX > 0 {
            return canScrollLeading
        }
        return canScrollTrailing
    }

    static func horizontalMoveX(for pan: UIPanGestureRecognizer, in view: UIView) -> CGFloat {
        let translation = pan.translation(in: view)
        if abs(translation.x) > translationPriority {
            return translation.x
        }
        return pan.velocity(in: view).x
    }

    static func shouldOuterPanBegin(_ pan: UIPanGestureRecognizer, in outer: UIScrollView) -> Bool {
        guard pan === outer.panGestureRecognizer else {
            return true
        }
        let moveX = horizontalMoveX(for: pan, in: outer)
        let location = pan.location(in: outer)
        var view: UIView? = outer.hitTest(location, with: nil)
        while let current = view, current !== outer {
            if let nested = current as? UIScrollView,
               nested !== outer,
               canAbsorb(in: nested, moveX: moveX) {
                return false
            }
            view = current.superview
        }
        return true
    }
}

open class TFYSwiftCollectionView: UICollectionView {

    open var indicators = [TFYSwiftIndicatorProtocol]() {
        willSet {
            for indicator in indicators {
                indicator.removeFromSuperview()
            }
        }
        didSet {
            for indicator in indicators {
                addSubview(indicator)
            }
        }
    }

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        isDirectionalLockEnabled = true
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        isDirectionalLockEnabled = true
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        for indicator in indicators {
            sendSubviewToBack(indicator)
            if let backgroundView = backgroundView {
                sendSubviewToBack(backgroundView)
            }
        }
    }

    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer === panGestureRecognizer,
              otherGestureRecognizer is UIPanGestureRecognizer,
              let otherScrollView = otherGestureRecognizer.view as? UIScrollView,
              otherScrollView !== self else {
            return false
        }
        let moveX = TFYSwiftNestedHorizontalPan.horizontalMoveX(for: panGestureRecognizer, in: self)
        return TFYSwiftNestedHorizontalPan.canAbsorb(in: self, moveX: moveX)
    }
}
