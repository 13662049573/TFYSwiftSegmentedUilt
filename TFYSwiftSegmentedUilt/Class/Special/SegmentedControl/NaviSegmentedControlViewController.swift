//
//  NaviSegmentedControlViewController.swift
//  TFYSwiftView
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit


class NaviSegmentedControlViewController: ContentBaseViewController {
    let totalItemWidth: CGFloat = 150
    
    deinit {
        print("NaviSegmentedControlViewController deinited")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let titles = ["吃饭🍚", "睡觉😴"]
        let titleDataSource = TFYSwiftTitleDataSource()
        titleDataSource.itemWidth = totalItemWidth/CGFloat(titles.count)
        titleDataSource.titles = titles
        titleDataSource.isTitleMaskEnabled = true
        titleDataSource.titleNormalColor = UIColor.red
        titleDataSource.titleSelectedColor = UIColor.white
        titleDataSource.itemSpacing = 0
        segmentedDataSource = titleDataSource

        segmentedView.dataSource = titleDataSource
        segmentedView.frame = CGRect(x: 0, y: 0, width: totalItemWidth, height: 30)
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.cornerRadius = 15
        segmentedView.layer.borderColor = UIColor.red.cgColor
        segmentedView.layer.borderWidth = 1/UIScreen.main.scale
        navigationItem.titleView = segmentedView

        let indicator = TFYSwiftIndicatorBackgroundView()
        indicator.indicatorHeight = 30
        indicator.indicatorWidthIncrement = 0
        indicator.indicatorColor = UIColor.red
        segmentedView.indicators = [indicator]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 0, y: 0, width: totalItemWidth, height: 30)
        listContainerView.frame = view.bounds
    }
}
