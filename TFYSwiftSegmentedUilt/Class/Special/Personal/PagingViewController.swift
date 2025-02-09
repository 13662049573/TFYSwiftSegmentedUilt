//
//  PagingViewController.swift
//  TFYSwiftPagingView
//
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit


extension TFYSwiftPagingListContainerView: TFYSwiftViewListContainer {}

class PagingViewController: UIViewController {
    var pagingView: TFYSwiftPagingView!
    var userHeaderView: PagingViewTableHeaderView!
    var userHeaderContainerView: UIView!
    var segmentedViewDataSource: TFYSwiftTitleDataSource!
    var segmentedView: TFYSwiftView!
    let titles = ["能力", "爱好", "队友"]
    var TFYSwiftTableHeaderViewHeight: Int = 200
    var TFYSwiftheightForHeaderInSection: Int = 50

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "个人中心"
        self.navigationController?.navigationBar.isTranslucent = false

        userHeaderContainerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(TFYSwiftTableHeaderViewHeight)))
        userHeaderView = PagingViewTableHeaderView(frame: userHeaderContainerView.bounds)
        userHeaderContainerView.addSubview(userHeaderView)

        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedViewDataSource = TFYSwiftTitleDataSource()
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.titleSelectedColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        segmentedViewDataSource.titleNormalColor = UIColor.black
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.isTitleZoomEnabled = true

        segmentedView = TFYSwiftView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(TFYSwiftheightForHeaderInSection)))
        segmentedView.backgroundColor = UIColor.white
        segmentedView.dataSource = segmentedViewDataSource
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false

        let lineView = TFYSwiftIndicatorLineView()
        lineView.indicatorColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        lineView.indicatorWidth = 30
        segmentedView.indicators = [lineView]

        let lineWidth = 1/UIScreen.main.scale
        let lineLayer = CALayer()
        lineLayer.backgroundColor = UIColor.lightGray.cgColor
        lineLayer.frame = CGRect(x: 0, y: segmentedView.bounds.height - lineWidth, width: segmentedView.bounds.width, height: lineWidth)
        segmentedView.layer.addSublayer(lineLayer)

        pagingView = TFYSwiftPagingView(delegate: self)

        self.view.addSubview(pagingView)
        
        segmentedView.listContainer = pagingView.listContainerView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagingView.frame = self.view.bounds
    }
}

extension PagingViewController: TFYSwiftPagingViewDelegate {

    func tableHeaderViewHeight(in pagingView: TFYSwiftPagingView) -> Int {
        return TFYSwiftTableHeaderViewHeight
    }

    func tableHeaderView(in pagingView: TFYSwiftPagingView) -> UIView {
        return userHeaderContainerView
    }

    func heightForPinSectionHeader(in pagingView: TFYSwiftPagingView) -> Int {
        return TFYSwiftheightForHeaderInSection
    }

    func viewForPinSectionHeader(in pagingView: TFYSwiftPagingView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in pagingView: TFYSwiftPagingView) -> Int {
        return titles.count
    }

    func pagingView(_ pagingView: TFYSwiftPagingView, initListAtIndex index: Int) -> TFYSwiftPagingViewListViewDelegate {
        let list = PagingListBaseView()
        if index == 0 {
            list.dataSource = ["橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮", "橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮"]
        }else if index == 1 {
            list.dataSource = ["吃烤肉", "吃鸡腿肉", "吃牛肉", "各种肉"]
        }else {
            list.dataSource = ["【剑士】罗罗诺亚·索隆", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾"]
        }
        list.beginFirstRefresh()
        return list
    }

    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        userHeaderView?.scrollViewDidScroll(contentOffsetY: scrollView.contentOffset.y)
    }
}

