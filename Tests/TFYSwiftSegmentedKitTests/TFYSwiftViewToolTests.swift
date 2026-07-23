//
//  TFYSwiftViewToolTests.swift
//  TFYSwiftSegmentedKitTests
//

import XCTest
@testable import TFYSwiftSegmentedKit

final class TFYSwiftViewToolTests: XCTestCase {

    // MARK: - interpolate (CGFloat)

    func testInterpolate_atStart_returnsFrom() {
        XCTAssertEqual(TFYSwiftViewTool.interpolate(from: 10, to: 30, percent: 0), 10, accuracy: 0.0001)
    }

    func testInterpolate_atEnd_returnsTo() {
        XCTAssertEqual(TFYSwiftViewTool.interpolate(from: 10, to: 30, percent: 1), 30, accuracy: 0.0001)
    }

    func testInterpolate_atMid_returnsMidpoint() {
        XCTAssertEqual(TFYSwiftViewTool.interpolate(from: 10, to: 30, percent: 0.5), 20, accuracy: 0.0001)
    }

    func testInterpolate_clampsBelowZero() {
        XCTAssertEqual(TFYSwiftViewTool.interpolate(from: 0, to: 100, percent: -0.5), 0, accuracy: 0.0001)
    }

    func testInterpolate_clampsAboveOne() {
        XCTAssertEqual(TFYSwiftViewTool.interpolate(from: 0, to: 100, percent: 1.7), 100, accuracy: 0.0001)
    }

    func testInterpolate_arbitraryFractionUsesFloatingPointMath() {
        // 如果 percent 被误用为 Int，将 clamp 到 0 或 1 导致结果跳变；这里用 0.25 验证中间值是浮点连续的。
        let result = TFYSwiftViewTool.interpolate(from: 0.0, to: 1.0, percent: 0.25)
        XCTAssertEqual(result, 0.25, accuracy: 0.0001)
    }

    // MARK: - interpolateColor

    func testInterpolateColor_midpoint() {
        let from = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let to = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let mid = TFYSwiftViewTool.interpolateColor(from: from, to: to, percent: 0.5)

        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        mid.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertEqual(r, 0.5, accuracy: 0.0001)
        XCTAssertEqual(g, 0.5, accuracy: 0.0001)
        XCTAssertEqual(b, 0.5, accuracy: 0.0001)
        XCTAssertEqual(a, 1.0, accuracy: 0.0001)
    }

    func testInterpolateColor_clampsBelowZero() {
        let from = UIColor.red
        let to = UIColor.blue
        let clamped = TFYSwiftViewTool.interpolateColor(from: from, to: to, percent: -1)
        var fr: CGFloat = 0, fg: CGFloat = 0, fb: CGFloat = 0, fa: CGFloat = 0
        from.getRed(&fr, green: &fg, blue: &fb, alpha: &fa)
        var cr: CGFloat = 0, cg: CGFloat = 0, cb: CGFloat = 0, ca: CGFloat = 0
        clamped.getRed(&cr, green: &cg, blue: &cb, alpha: &ca)
        XCTAssertEqual(cr, fr, accuracy: 0.0001)
        XCTAssertEqual(cg, fg, accuracy: 0.0001)
        XCTAssertEqual(cb, fb, accuracy: 0.0001)
    }
}
