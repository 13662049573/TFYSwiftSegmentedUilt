//
//  TFYSwiftBaseCell.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

public typealias TFYSwiftCellSelectedAnimationClosure = (CGFloat)->()

open class TFYSwiftBaseCell: UICollectionViewCell, TFYSwiftViewRTLCompatible {
    open var itemModel: TFYSwiftBaseItemModel?
    open var animator: TFYSwiftAnimator?
    private var selectedAnimationClosureArray = [TFYSwiftCellSelectedAnimationClosure]()

    deinit {
        animator?.stop()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()

        animator?.stop()
        animator = nil
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    open func commonInit() {
        if segmentedViewShouldRTLLayout() {
            segmentedView(horizontalFlipForView: self)
            segmentedView(horizontalFlipForView: contentView)
        }
    }

    open func canStartSelectedAnimation(itemModel: TFYSwiftBaseItemModel, selectedType: TFYSwiftViewItemSelectedType) -> Bool {
        var isSelectedAnimatable = false
        if itemModel.isSelectedAnimable {
            if selectedType == .scroll {
                //滚动选中且没有开启左右过渡，允许动画
                if !itemModel.isItemTransitionEnabled {
                    isSelectedAnimatable = true
                }
            }else if selectedType == .click || selectedType == .code {
                //点击和代码选中，允许动画
                isSelectedAnimatable = true
            }
        }
        return isSelectedAnimatable
    }

    open func appendSelectedAnimationClosure(closure: @escaping TFYSwiftCellSelectedAnimationClosure) {
        selectedAnimationClosureArray.append(closure)
    }

    open func startSelectedAnimationIfNeeded(itemModel: TFYSwiftBaseItemModel, selectedType: TFYSwiftViewItemSelectedType) {
        if itemModel.isSelectedAnimable && canStartSelectedAnimation(itemModel: itemModel, selectedType: selectedType) {
            //需要更新isTransitionAnimating，用于处理在过滤时，禁止响应点击，避免界面异常。
            itemModel.isTransitionAnimating = true
            animator?.progressClosure = {[weak self] (percent) in
                guard self != nil else {
                    return
                }
                for closure in self!.selectedAnimationClosureArray {
                    closure(percent)
                }
            }
            animator?.completedClosure = {[weak self] in
                itemModel.isTransitionAnimating = false
                self?.selectedAnimationClosureArray.removeAll()
            }
            animator?.start()
        }
    }

    open func reloadData(itemModel: TFYSwiftBaseItemModel, selectedType: TFYSwiftViewItemSelectedType) {
        self.itemModel = itemModel

        if itemModel.isSelectedAnimable {
            selectedAnimationClosureArray.removeAll()
            if canStartSelectedAnimation(itemModel: itemModel, selectedType: selectedType) {
                animator = TFYSwiftAnimator()
                animator?.duration = itemModel.selectedAnimationDuration
            }else {
                animator?.stop()
                animator = nil
            }
        }
    }
    
    open override var isSelected: Bool {
        didSet {
            setSelectedStyle(isSelected: isSelected)
        }
    }
    
    open override var isHighlighted: Bool {
        didSet {
            setSelectedStyle(isSelected: isHighlighted)
        }
    }
    
    func setSelectedStyle(isSelected: Bool) {
        
    }
}

