#if canImport(UIKit)
import XCTest
import UIKit
@testable import TFYSwiftSegmentedKit

private final class MockListView: UIView, TFYSwiftListContainerViewListDelegate {
    func listView() -> UIView { return self }
}

private final class MockListContainerDataSource: NSObject, TFYSwiftListContainerViewDataSource {
    var listCount: Int = 3
    private(set) var instantiatedViews = 0

    func numberOfLists(in listContainerView: TFYSwiftListContainerView) -> Int {
        return listCount
    }

    func listContainerView(_ listContainerView: TFYSwiftListContainerView,
                           initListAt index: Int) -> TFYSwiftListContainerViewListDelegate {
        instantiatedViews += 1
        return MockListView()
    }
}

final class TFYSwiftListContainerViewTests: XCTestCase {

    @MainActor
    func testDataSourceCountDrivesListCreation() {
        let ds = MockListContainerDataSource()
        let container = TFYSwiftListContainerView(dataSource: ds, type: .scrollView)
        container.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        container.layoutIfNeeded()
        container.reloadData()
        container.layoutIfNeeded()

        XCTAssertGreaterThanOrEqual(ds.instantiatedViews, 1,
                                    "至少应初始化一个 list view")
    }

    @MainActor
    func testContentScrollViewIsNotNil() {
        let ds = MockListContainerDataSource()
        let container = TFYSwiftListContainerView(dataSource: ds, type: .scrollView)
        XCTAssertNotNil(container.contentScrollView())
    }

    @MainActor
    func testReloadWithEmptyDataSourceDoesNotCrash() {
        let ds = MockListContainerDataSource()
        ds.listCount = 0
        let container = TFYSwiftListContainerView(dataSource: ds, type: .scrollView)
        container.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        container.reloadData()
        container.layoutIfNeeded()
        XCTAssertEqual(ds.instantiatedViews, 0)
    }
}
#endif
