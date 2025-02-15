//
//  LoadDataDetailViewController.swift
//  TFYSwiftView
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

class LoadDataDetailViewController: UIViewController {
    var detailText = ""
    private var textLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "测试详情页面"
        view.backgroundColor = UIColor.white

        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(textLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        textLabel.text = detailText
        textLabel.sizeToFit()
        textLabel.center = view.center
    }


}
