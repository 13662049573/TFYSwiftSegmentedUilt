//
//  TitleConfigurationViewController.swift
//  TFYSwiftViewExample
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit


class TitleConfigurationViewController: UIViewController {
    var segmentedDataSource: TFYSwiftTitleDataSource!
    var segmentedView: TFYSwiftView!
    var listContainerView: TFYSwiftListContainerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        //1、初始化TFYSwiftView
        segmentedView = TFYSwiftView()

        //2、配置数据源
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedDataSource = TFYSwiftTitleDataSource()
        segmentedDataSource.configuration = self
        segmentedDataSource.titles = ["猴哥", "青蛙王子", "旺财", "粉红猪", "喜羊羊", "黄焖鸡", "小马哥", "牛魔王", "大象先生", "神龙", "小猪佩奇"]
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedView.dataSource = segmentedDataSource
        
        //3、配置指示器
        let indicator = TFYSwiftIndicatorLineView()
        indicator.indicatorWidth = TFYSwiftViewAutomaticDimension
        indicator.lineStyle = .lengthen
        segmentedView.indicators = [indicator]

        //4、配置TFYSwiftView的属性
        view.addSubview(segmentedView)

        //5、初始化TFYSwiftListContainerView
        listContainerView = TFYSwiftListContainerView(dataSource: self)
        view.addSubview(listContainerView)

        //6、将listContainerView.scrollView和segmentedView.contentScrollView进行关联
        segmentedView.listContainer = listContainerView

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        listContainerView.frame = CGRect(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 50)
    }
}

extension TitleConfigurationViewController: TFYSwiftListContainerViewDataSource {
    func numberOfLists(in listContainerView: TFYSwiftListContainerView) -> Int {
        return segmentedDataSource.dataSource.count
    }

    func listContainerView(_ listContainerView: TFYSwiftListContainerView, initListAt index: Int) -> TFYSwiftListContainerViewListDelegate {
        let vc = LoadDataListViewController()
        vc.typeString = segmentedDataSource.titles[index]
        return vc
    }
}

extension TitleConfigurationViewController: TFYSwiftTitleDynamicConfiguration {
    func titleNumberOfLines(at index: Int) -> Int {
        1
    }
    
    func titleNormalColor(at index: Int) -> UIColor {
        if index == 0 {
            return .cyan
        } else {
            return .black
        }
    }
    
    func titleSelectedColor(at index: Int) -> UIColor {
        if index == 0 {
            return .brown
        } else {
            return .red
        }
    }
    
    func titleNormalFont(at index: Int) -> UIFont {
        if index == 0 {
            return .systemFont(ofSize: 20)
        } else {
            return .systemFont(ofSize: 15)
        }
    }
    
    func titleSelectedFont(at index: Int) -> UIFont? {
        if index == 0 {
            return .systemFont(ofSize: 20)
        } else {
            return .systemFont(ofSize: 15)
        }
    }
}
