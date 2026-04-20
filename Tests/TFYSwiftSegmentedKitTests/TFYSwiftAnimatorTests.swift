//
//  TFYSwiftAnimatorTests.swift
//  TFYSwiftSegmentedKitTests
//

import XCTest
@testable import TFYSwiftSegmentedKit

final class TFYSwiftAnimatorTests: XCTestCase {

    func testStartTriggersProgressAndCompletion() {
        let animator = TFYSwiftAnimator()
        animator.duration = 0.1

        let progressExp = expectation(description: "progress fires at least once")
        progressExp.assertForOverFulfill = false
        let completionExp = expectation(description: "completion fires")

        var lastPercent: CGFloat = -1
        animator.progressClosure = { percent in
            XCTAssertGreaterThanOrEqual(percent, 0)
            XCTAssertLessThanOrEqual(percent, 1)
            lastPercent = percent
            progressExp.fulfill()
        }
        animator.completedClosure = {
            completionExp.fulfill()
        }
        animator.start()
        wait(for: [progressExp, completionExp], timeout: 2.0)
        XCTAssertGreaterThan(lastPercent, 0)
    }

    func testStopBeforeCompletionDoesNotFireCompletion() {
        let animator = TFYSwiftAnimator()
        animator.duration = 1.0
        var completed = false
        animator.completedClosure = { completed = true }
        animator.start()
        animator.stop()
        let exp = expectation(description: "wait a bit")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { exp.fulfill() }
        wait(for: [exp], timeout: 1.0)
        XCTAssertFalse(completed)
    }
}
