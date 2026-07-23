//
//  TFYSwiftTextMeasureTests.swift
//  TFYSwiftSegmentedKitTests
//

import XCTest
@testable import TFYSwiftSegmentedKit

final class TFYSwiftTextMeasureTests: XCTestCase {

    override func setUp() {
        super.setUp()
        TFYSwiftTextMeasure.shared.invalidate()
    }

    func testEmptyTitleReturnsZero() {
        let w = TFYSwiftTextMeasure.shared.width(for: "", font: .systemFont(ofSize: 14))
        XCTAssertEqual(w, 0, accuracy: 0.0001)
    }

    func testSameInputsReturnsCachedResult() {
        let font = UIFont.systemFont(ofSize: 14)
        let first = TFYSwiftTextMeasure.shared.width(for: "Hello", font: font)
        let second = TFYSwiftTextMeasure.shared.width(for: "Hello", font: font)
        XCTAssertEqual(first, second, accuracy: 0.0001)
    }

    func testLargerFontProducesWiderOrEqualMeasurement() {
        let small = TFYSwiftTextMeasure.shared.width(for: "Hello", font: .systemFont(ofSize: 10))
        let large = TFYSwiftTextMeasure.shared.width(for: "Hello", font: .systemFont(ofSize: 30))
        XCTAssertGreaterThan(large, small)
    }

    func testCountLimitIsTunable() {
        TFYSwiftTextMeasure.shared.countLimit = 128
        XCTAssertEqual(TFYSwiftTextMeasure.shared.countLimit, 128)
        TFYSwiftTextMeasure.shared.countLimit = 512
    }

    func testInvalidateDoesNotCrash() {
        _ = TFYSwiftTextMeasure.shared.width(for: "A", font: .systemFont(ofSize: 12))
        TFYSwiftTextMeasure.shared.invalidate()
        let w = TFYSwiftTextMeasure.shared.width(for: "A", font: .systemFont(ofSize: 12))
        XCTAssertGreaterThan(w, 0)
    }
}
