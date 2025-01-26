//
//  SegmentedControlViewController.swift
//  TFYSwiftView
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit


class SegmentedControlViewController: ContentBaseViewController {
    var totalItemWidth: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        totalItemWidth = UIScreen.main.bounds.size.width - 30*2
        let titles = ["吃饭🍚", "睡觉😴", "游泳🏊", "跳舞💃"]
        let titleDataSource = TFYSwiftTitleDataSource()
        titleDataSource.itemWidth = totalItemWidth/CGFloat(titles.count)
        titleDataSource.titles = titles
        titleDataSource.isTitleMaskEnabled = true
        titleDataSource.titleNormalColor = UIColor.red
        titleDataSource.titleSelectedColor = UIColor.white
        titleDataSource.itemSpacing = 0
        segmentedDataSource = titleDataSource

        segmentedView.dataSource = titleDataSource
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.cornerRadius = 15
        segmentedView.layer.borderColor = UIColor.red.cgColor
        segmentedView.layer.borderWidth = 1/UIScreen.main.scale

        let indicator = TFYSwiftIndicatorBackgroundView()
        indicator.indicatorHeight = 30
        indicator.indicatorWidthIncrement = 0
        indicator.indicatorColor = UIColor.red
        segmentedView.indicators = [indicator]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 30, y: 10, width: totalItemWidth, height: 30)
    }
}
