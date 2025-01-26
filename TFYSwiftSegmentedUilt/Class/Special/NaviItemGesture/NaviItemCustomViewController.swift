//
//  NaviItemCustomViewController.swift
//  TFYSwiftView
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit


class NaviItemCustomViewController: ContentBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let backItem = UIBarButtonItem(title: "自定义返回", style: .plain, target: self, action: #selector(customBackItemClicked))
        navigationItem.leftBarButtonItem = backItem

        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        let titles = ["猴哥", "青蛙王子", "旺财", "粉红猪", "喜羊羊", "黄焖鸡", "小马哥", "牛魔王", "大象先生", "神龙"]
        //配置数据源
        let dataSource = TFYSwiftTitleDataSource()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titles = titles
        segmentedDataSource = dataSource
        segmentedView.dataSource = segmentedDataSource

        //配置指示器
        let indicator = TFYSwiftIndicatorLineView()
        indicator.indicatorWidth = 20
        segmentedView.indicators = [indicator]
    }
    
    @objc func customBackItemClicked(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

}

extension NaviItemCustomViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
