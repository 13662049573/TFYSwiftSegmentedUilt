//
//  ContentBaseViewController.swift
//  TFYSwiftView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class ContentBaseViewController: UIViewController {
    var segmentedDataSource: TFYSwiftBaseDataSource?
    let segmentedView = TFYSwiftView()
    lazy var listContainerView: TFYSwiftListContainerView! = {
        return TFYSwiftListContainerView(dataSource: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        view.addSubview(segmentedView)

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)

        for indicaotr in segmentedView.indicators {
            if (indicaotr as? TFYSwiftIndicatorLineView) != nil ||
                (indicaotr as? TFYSwiftIndicatorDotLineView) != nil ||
                (indicaotr as? TFYSwiftIndicatorDoubleLineView) != nil ||
                (indicaotr as? TFYSwiftIndicatorRainbowLineView) != nil ||
                (indicaotr as? TFYSwiftIndicatorImageView) != nil ||
                (indicaotr as? TFYSwiftIndicatorTriangleView) != nil {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "指示器位置切换", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didIndicatorPositionChanged))
                break
            }
        }

        if (segmentedDataSource as? TFYSwiftTitleImageDataSource) != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设置", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didSetingsButtonClicked))
        }
        
        
        if let _ = segmentedDataSource as? TFYSwiftNumberDataSource {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新", style: UIBarButtonItem.Style.plain, target: self, action: #selector(hanldeNumberRefresh))
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //处于第一个item的时候，才允许屏幕边缘手势返回
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        listContainerView.frame = CGRect(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 50)
    }

    @objc func didSetingsButtonClicked() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TitleImageSettingViewController") as! TitleImageSettingViewController
        vc.title = title
        vc.clickedClosure = {[weak self] (type) in
            (self?.segmentedDataSource as? TFYSwiftTitleImageDataSource)?.titleImageType = type
            //先更新数据源
            self?.segmentedDataSource?.reloadData(selectedIndex: self?.segmentedView.selectedIndex ?? 0)
            //再更新segmentedView
            self?.segmentedView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func didIndicatorPositionChanged() {
        for indicaotr in (segmentedView.indicators as! [TFYSwiftIndicatorBaseView]) {
            if indicaotr.indicatorPosition == .bottom {
                indicaotr.indicatorPosition = .top
            }else {
                indicaotr.indicatorPosition = .bottom
            }
        }
        segmentedView.reloadDataWithoutListContainer()
    }
    
    //MARK: 数字刷新demo
    @objc func hanldeNumberRefresh()
    {
        if let _segDataSource = segmentedDataSource as? TFYSwiftNumberDataSource {
            let newNumbers = [223, 12, 435, 332, 0, 32, 98, 0, 99999, 112]
            _segDataSource.numberHeight = 18
            _segDataSource.numberOffset = CGPoint(x: -5, y: 5)
            _segDataSource.numbers = newNumbers
            segmentedView.reloadDataWithoutListContainer()
        }
    }

}

extension ContentBaseViewController: TFYSwiftViewDelegate {
    func segmentedView(_ segmentedView: TFYSwiftView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? TFYSwiftDotDataSource {
            //先更新数据源的数据
            dotDataSource.dotStates[index] = false
            //再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }

        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
}

extension ContentBaseViewController: TFYSwiftListContainerViewDataSource {
    func numberOfLists(in listContainerView: TFYSwiftListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? TFYSwiftBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: TFYSwiftListContainerView, initListAt index: Int) -> TFYSwiftListContainerViewListDelegate {
        return ListBaseViewController()
    }
}

