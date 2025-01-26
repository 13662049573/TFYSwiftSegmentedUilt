//
//  ListCacheViewController.swift
//  TFYSwiftViewExample
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit


class ListCacheViewController: UIViewController {
    var segmentedDataSource: TFYSwiftTitleDataSource!
    var segmentedView: TFYSwiftView!
    var listContainerView: TFYSwiftListContainerView!
    private var listCacheDict: [String: LoadDataListViewController] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        //1、初始化TFYSwiftView
        segmentedView = TFYSwiftView()

        //2、配置数据源
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedDataSource = TFYSwiftTitleDataSource()
        segmentedDataSource.titles = getRandomTitles()
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新数据", style: UIBarButtonItem.Style.plain, target: self, action: #selector(reloadData))
    }

    @objc func reloadData() {
        segmentedDataSource.titles = getRandomTitles()
        segmentedView.defaultSelectedIndex = 1
        segmentedView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        listContainerView.frame = CGRect(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 50)
    }

    func getRandomTitles() -> [String] {
        let titles = ["猴哥", "青蛙王子", "旺财", "粉红猪", "喜羊羊", "黄焖鸡", "小马哥", "牛魔王", "大象先生", "神龙"]
        //随机title数量，4~n
        let randomCount = Int(arc4random()%7 + 4)
        var tempTitles = titles
        var resultTitles = [String]()
        for _ in 0..<randomCount {
            let randomIndex = Int(arc4random()%UInt32(tempTitles.count))
            resultTitles.append(tempTitles[randomIndex])
            tempTitles.remove(at: randomIndex)
        }
        return resultTitles
    }
}

extension ListCacheViewController: TFYSwiftListContainerViewDataSource {
    func numberOfLists(in listContainerView: TFYSwiftListContainerView) -> Int {
        return segmentedDataSource.dataSource.count
    }

    func listContainerView(_ listContainerView: TFYSwiftListContainerView, initListAt index: Int) -> TFYSwiftListContainerViewListDelegate {
        let title = segmentedDataSource.titles[index]
        if let vc = listCacheDict[title] {
            return vc
        } else {
            let vc = LoadDataListViewController()
            vc.typeString = title
            listCacheDict[title] = vc
            return vc
        }
    }
}
