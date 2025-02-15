//
//  NestViewController.swift
//  TFYSwiftView
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit


class NestViewController: UIViewController {
    let segmentedDataSource = TFYSwiftTitleDataSource()
    let segmentedView = TFYSwiftView()
    lazy var listContainerView: TFYSwiftListContainerView! = {
        return TFYSwiftListContainerView(dataSource: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let totalItemWidth: CGFloat = 150
        let titles = ["吃饭🍚", "运动💪"]
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedDataSource.itemWidth = totalItemWidth/CGFloat(titles.count)
        segmentedDataSource.titles = titles
        segmentedDataSource.isTitleMaskEnabled = true
        segmentedDataSource.titleNormalColor = UIColor.red
        segmentedDataSource.titleSelectedColor = UIColor.white
        segmentedDataSource.itemSpacing = 0

        let indicator = TFYSwiftIndicatorBackgroundView()
        indicator.indicatorHeight = 30
        indicator.indicatorWidthIncrement = 0
        indicator.indicatorColor = UIColor.red

        segmentedView.frame = CGRect(x: 0, y: 0, width: totalItemWidth, height: 30)
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.cornerRadius = 15
        segmentedView.layer.borderColor = UIColor.red.cgColor
        segmentedView.layer.borderWidth = 1/UIScreen.main.scale
        segmentedView.dataSource = segmentedDataSource
        segmentedView.indicators = [indicator]
        navigationItem.titleView = segmentedView

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        listContainerView.frame = view.bounds
    }
}

extension NestViewController: TFYSwiftListContainerViewDataSource {
    func numberOfLists(in listContainerView: TFYSwiftListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? TFYSwiftBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: TFYSwiftListContainerView, initListAt index: Int) -> TFYSwiftListContainerViewListDelegate {
        let vc = NestChildViewController()
        if index == 0 {
           vc.titles = ["吃鸡🍗", "吃西瓜🍉", "吃热狗🌭"]
        }else if index == 1 {
            vc.titles = ["高尔夫🏌", "滑雪⛷", "自行车🚴"]
        }
        return vc
    }
}


