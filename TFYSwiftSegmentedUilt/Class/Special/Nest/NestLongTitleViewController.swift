//
//  NestLongTitleViewController.swift
//  TFYSwiftView
//
//  嵌套 + 二级超长标签：左右滑标签栏时，一级分页不应跟着抖。
//

import UIKit

final class NestLongTitleViewController: UIViewController {
    private let segmentedDataSource = TFYSwiftTitleDataSource()
    private let segmentedView = TFYSwiftView()
    private lazy var listContainerView = TFYSwiftListContainerView(dataSource: self)
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.text = "左右滑动二级超长标签，顶部一级不应抖动；滑内容区可切二级页，滑到边再切一级。"
        return label
    }()

    private let parentTitles = ["美食🍜", "运动🏅", "旅行✈️"]
    private let childTitles: [[String]] = [
        [
            "黄焖鸡米饭超长套餐限时折扣🍗",
            "冰镇西瓜汁加珍珠加椰果🍉",
            "芝士热狗堡配蜂蜜芥末酱🌭",
            "麻辣小龙虾十三香蒜香两种口味🦐",
            "炭烤生蚝柠檬蒜蓉黄油🦞"
        ],
        [
            "室内攀岩体验课含装备租赁🧗",
            "高山滑雪初级道教练一对一⛷",
            "环城自行车夜骑荧光装备🚴",
            "网球馆室内灯光场包场两小时🎾",
            "马拉松备赛配速训练营🏃"
        ],
        [
            "京都岚山竹林小火车一日游🎋",
            "冰岛蓝湖温泉含接送与浴袍🧖",
            "敦煌莫高窟日出摄影包车📸",
            "阿尔卑斯山徒步向导两日行程🏔️",
            "威尼斯贡多拉夜游含晚餐🍷"
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let totalItemWidth: CGFloat = 210
        segmentedDataSource.itemWidth = totalItemWidth / CGFloat(parentTitles.count)
        segmentedDataSource.titles = parentTitles
        segmentedDataSource.isTitleMaskEnabled = true
        segmentedDataSource.titleNormalColor = .systemRed
        segmentedDataSource.titleSelectedColor = .white
        segmentedDataSource.itemSpacing = 0

        let indicator = TFYSwiftIndicatorBackgroundView()
        indicator.indicatorHeight = 30
        indicator.indicatorWidthIncrement = 0
        indicator.indicatorColor = .systemRed

        segmentedView.frame = CGRect(x: 0, y: 0, width: totalItemWidth, height: 30)
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.cornerRadius = 15
        segmentedView.layer.borderColor = UIColor.systemRed.cgColor
        segmentedView.layer.borderWidth = 1 / UIScreen.main.scale
        segmentedView.dataSource = segmentedDataSource
        segmentedView.indicators = [indicator]
        navigationItem.titleView = segmentedView

        view.addSubview(hintLabel)
        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let top = view.safeAreaInsets.top
        hintLabel.frame = CGRect(x: 12, y: top + 8, width: view.bounds.width - 24, height: 36)
        let listY = hintLabel.frame.maxY + 8
        listContainerView.frame = CGRect(
            x: 0,
            y: listY,
            width: view.bounds.width,
            height: view.bounds.height - listY
        )
    }
}

extension NestLongTitleViewController: TFYSwiftListContainerViewDataSource {
    func numberOfLists(in listContainerView: TFYSwiftListContainerView) -> Int {
        parentTitles.count
    }

    func listContainerView(_ listContainerView: TFYSwiftListContainerView, initListAt index: Int) -> TFYSwiftListContainerViewListDelegate {
        let vc = NestChildViewController()
        vc.titles = childTitles[index]
        return vc
    }
}
