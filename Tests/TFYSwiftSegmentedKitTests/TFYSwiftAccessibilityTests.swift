#if canImport(UIKit)
import XCTest
import UIKit
@testable import TFYSwiftSegmentedKit

final class TFYSwiftAccessibilityTests: XCTestCase {

    @MainActor
    func testBaseCellAccessibilityValueReflectsIndexAndTotal() {
        let model = TFYSwiftBaseItemModel()
        model.index = 2
        model.isSelected = false
        model.totalItemCount = 5

        let cell = TFYSwiftBaseCell(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
        cell.reloadData(itemModel: model, selectedType: .unknown)

        XCTAssertTrue(cell.isAccessibilityElement)
        XCTAssertNotNil(cell.accessibilityValue)
        XCTAssertTrue(cell.accessibilityValue!.contains("3"),
                      "accessibilityValue 应使用 1-based 序号，收到 \(cell.accessibilityValue ?? "nil")")
        XCTAssertTrue(cell.accessibilityValue!.contains("5"),
                      "accessibilityValue 应包含 total，收到 \(cell.accessibilityValue ?? "nil")")
        XCTAssertTrue(cell.accessibilityTraits.contains(.button))
        XCTAssertFalse(cell.accessibilityTraits.contains(.selected))
    }

    @MainActor
    func testBaseCellAccessibilityTraitsSelected() {
        let model = TFYSwiftBaseItemModel()
        model.index = 0
        model.isSelected = true
        model.totalItemCount = 3

        let cell = TFYSwiftBaseCell(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
        cell.reloadData(itemModel: model, selectedType: .click)

        XCTAssertTrue(cell.accessibilityTraits.contains(.selected))
    }

    @MainActor
    func testBaseCellAccessibilityHintFromModelOverridesDefault() {
        let model = TFYSwiftBaseItemModel()
        model.index = 1
        model.isSelected = false
        model.totalItemCount = 4
        model.accessibilityHintText = "切换到第二栏"

        let cell = TFYSwiftBaseCell(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
        cell.reloadData(itemModel: model, selectedType: .unknown)

        XCTAssertEqual(cell.accessibilityHint, "切换到第二栏")
    }
}
#endif
