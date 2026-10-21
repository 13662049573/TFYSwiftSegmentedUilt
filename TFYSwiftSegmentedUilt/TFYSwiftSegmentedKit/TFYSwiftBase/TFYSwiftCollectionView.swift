//
//  TFYSwiftCollectionView.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

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
