//
//  TFYSwiftTitleDataSourceTests.swift
//  TFYSwiftSegmentedKitTests
//

import XCTest
@testable import TFYSwiftSegmentedKit

final class TFYSwiftTitleDataSourceTests: XCTestCase {

    func testReloadDataPopulatesItemsAndTotalCount() {
        let ds = TFYSwiftTitleDataSource()
        ds.titles = ["A", "B", "C"]
        ds.reloadData(selectedIndex: 1)

        XCTAssertEqual(ds.dataSource.count, 3)
        XCTAssertTrue(ds.dataSource[1].isSelected)
        XCTAssertFalse(ds.dataSource[0].isSelected)
        XCTAssertFalse(ds.dataSource[2].isSelected)
        XCTAssertEqual(ds.dataSource[0].totalItemCount, 3)
        XCTAssertEqual(ds.dataSource[2].totalItemCount, 3)
    }

    func testEmptyTitlesDoesNotCrash() {
        let ds = TFYSwiftTitleDataSource()
        ds.titles = []
        ds.reloadData(selectedIndex: 0)
        XCTAssertEqual(ds.dataSource.count, 0)
    }

    func testDynamicTypeEnabled_returnsScaledFont() {
        let ds = TFYSwiftTitleDataSource()
        let baseFont = UIFont.systemFont(ofSize: 12)
        ds.titleNormalFont = baseFont
        ds.titleMaximumContentSizeCategory = .accessibilityLarge

        ds.isTitleDynamicTypeEnabled = false
        let unscaled = ds.scaleFontForDynamicTypeIfNeeded(baseFont)
        XCTAssertEqual(unscaled.pointSize, baseFont.pointSize, accuracy: 0.0001)

        ds.isTitleDynamicTypeEnabled = true
        let scaled = ds.scaleFontForDynamicTypeIfNeeded(baseFont)
        XCTAssertGreaterThanOrEqual(scaled.pointSize, baseFont.pointSize)
    }

    func testTitleItemModelStoresComplexStringLengthSafely() {
        // 如果历史版本的 NSRange 用 String.count，emoji 场景会越界。这里间接验证 length 计算使用 NSString.length。
        let ds = TFYSwiftTitleDataSource()
        ds.titles = ["😀🚀👨‍👩‍👧‍👦"]
        ds.reloadData(selectedIndex: 0)
        XCTAssertEqual(ds.dataSource.count, 1)
        let model = ds.dataSource[0] as? TFYSwiftTitleItemModel
        XCTAssertEqual(model?.title, "😀🚀👨‍👩‍👧‍👦")
        XCTAssertGreaterThan(model?.textWidth ?? 0, 0)
    }
}
