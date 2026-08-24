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

    @MainActor
    func testDefaultScrollViewIsNestSafeSubclass() {
        let ds = MockListContainerDataSource()
        let scrollContainer = TFYSwiftListContainerView(dataSource: ds, type: .scrollView)
        XCTAssertTrue(scrollContainer.contentScrollView() is TFYSwiftListContainerScrollView)

        let collectionContainer = TFYSwiftListContainerView(dataSource: ds, type: .collectionView)
        XCTAssertTrue(collectionContainer.contentScrollView() is TFYSwiftListContainerCollectionView)
    }
}

final class TFYSwiftNestedHorizontalPanTests: XCTestCase {

    private func makeOverflowScrollView(offsetX: CGFloat) -> UIScrollView {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        scrollView.contentSize = CGSize(width: 800, height: 50)
        scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
        return scrollView
    }

    @MainActor
    func testCanAbsorb_whenContentFits_returnsFalse() {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        scrollView.contentSize = CGSize(width: 320, height: 50)
        XCTAssertFalse(TFYSwiftNestedHorizontalPan.canAbsorb(in: scrollView, moveX: -10))
        XCTAssertFalse(TFYSwiftNestedHorizontalPan.canAbsorb(in: scrollView, moveX: 10))
    }

    @MainActor
    func testCanAbsorb_whenOverflowAndMidContent_returnsTrue() {
        let scrollView = makeOverflowScrollView(offsetX: 100)
        XCTAssertTrue(TFYSwiftNestedHorizontalPan.canAbsorb(in: scrollView, moveX: -10))
        XCTAssertTrue(TFYSwiftNestedHorizontalPan.canAbsorb(in: scrollView, moveX: 10))
        XCTAssertTrue(TFYSwiftNestedHorizontalPan.canAbsorb(in: scrollView, moveX: 0))
    }

    @MainActor
    func testCanAbsorb_atLeadingEdge_onlyAbsorbsTrailingPan() {
        let scrollView = makeOverflowScrollView(offsetX: 0)
        XCTAssertTrue(TFYSwiftNestedHorizontalPan.canAbsorb(in: scrollView, moveX: -10))
        XCTAssertFalse(TFYSwiftNestedHorizontalPan.canAbsorb(in: scrollView, moveX: 10))
        XCTAssertFalse(TFYSwiftNestedHorizontalPan.canAbsorb(in: scrollView, moveX: 0))
    }

    @MainActor
    func testCanAbsorb_atTrailingEdge_onlyAbsorbsLeadingPan() {
        let scrollView = makeOverflowScrollView(offsetX: 480)
        XCTAssertFalse(TFYSwiftNestedHorizontalPan.canAbsorb(in: scrollView, moveX: -10))
        XCTAssertTrue(TFYSwiftNestedHorizontalPan.canAbsorb(in: scrollView, moveX: 10))
        XCTAssertFalse(TFYSwiftNestedHorizontalPan.canAbsorb(in: scrollView, moveX: 0))
    }

    @MainActor
    func testCanAbsorb_whenScrollDisabled_returnsFalse() {
        let scrollView = makeOverflowScrollView(offsetX: 100)
        scrollView.isScrollEnabled = false
        XCTAssertFalse(TFYSwiftNestedHorizontalPan.canAbsorb(in: scrollView, moveX: -10))
    }

    @MainActor
    func testShouldOuterPanBegin_yieldsToOverflowNestedScrollView() {
        let outer = TFYSwiftListContainerScrollView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let nested = UIScrollView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        nested.contentSize = CGSize(width: 800, height: 50)
        nested.contentOffset = CGPoint(x: 100, y: 0)
        outer.addSubview(nested)

        XCTAssertFalse(TFYSwiftNestedHorizontalPan.shouldOuterPanBegin(outer.panGestureRecognizer, in: outer))
    }

    @MainActor
    func testShouldOuterPanBegin_whenNestedContentFits_allowsOuter() {
        let outer = TFYSwiftListContainerScrollView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let nested = UIScrollView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        nested.contentSize = CGSize(width: 320, height: 50)
        outer.addSubview(nested)

        XCTAssertTrue(TFYSwiftNestedHorizontalPan.shouldOuterPanBegin(outer.panGestureRecognizer, in: outer))
    }
}
#endif
