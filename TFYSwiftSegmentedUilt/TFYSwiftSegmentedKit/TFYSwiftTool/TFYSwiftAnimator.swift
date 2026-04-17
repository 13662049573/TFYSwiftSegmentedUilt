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
    private var displayLink: CADisplayLink?
    private var firstTimestamp: CFTimeInterval?
    private var hasStarted = false

    public init() {
    }

    open func start() {
        guard duration > 0 else {
            finishAnimation(shouldComplete: true)
            return
        }
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(processDisplayLink(sender:)))
        }
        firstTimestamp = nil
        hasStarted = true
        displayLink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }

    open func stop() {
        finishAnimation(shouldComplete: hasStarted)
    }

    @objc private func processDisplayLink(sender: CADisplayLink) {
        let startTimestamp = firstTimestamp ?? sender.timestamp
        firstTimestamp = startTimestamp
        let percent = (sender.timestamp - startTimestamp)/duration
        if percent >= 1 {
            finishAnimation(shouldComplete: true)
        }else {
            progressClosure?(CGFloat(percent))
        }
    }

    private func finishAnimation(shouldComplete: Bool) {
        if shouldComplete {
            progressClosure?(1)
        }
        displayLink?.invalidate()
        displayLink = nil
        firstTimestamp = nil
        if shouldComplete {
            completedClosure?()
        }
        hasStarted = false
    }
}
