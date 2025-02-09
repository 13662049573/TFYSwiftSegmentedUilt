//
//  TFYSwiftAnimator.swift
//  TFYSwiftSegmentedDemo
//
//  Created by 田风有 on 2025/1/25.
//

import Foundation
import UIKit

open class TFYSwiftAnimator {
    open var duration: TimeInterval = 0.25
    open var progressClosure: ((CGFloat)->())?
    open var completedClosure: (()->())?
    private var displayLink: CADisplayLink!
    private var firstTimestamp: CFTimeInterval?

    public init() {
        displayLink = CADisplayLink(target: self, selector: #selector(processDisplayLink(sender:)))
    }

    open func start() {
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }

    open func stop() {
        progressClosure?(1)
        displayLink.invalidate()
        completedClosure?()
    }

    @objc private func processDisplayLink(sender: CADisplayLink) {
        if firstTimestamp == nil {
            firstTimestamp = sender.timestamp
        }
        let percent = (sender.timestamp - firstTimestamp!)/duration
        if percent >= 1 {
            progressClosure?(1)
            displayLink.invalidate()
            completedClosure?()
        }else {
            progressClosure?(CGFloat(percent))
        }
    }
}

