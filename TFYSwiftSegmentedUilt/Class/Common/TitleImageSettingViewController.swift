//
//  TitleImageSettingViewController.swift
//  TFYSwiftView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit


class TitleImageSettingViewController: UITableViewController {
    var clickedClosure: ((TFYSwiftTitleImageType) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let types: [TFYSwiftTitleImageType] = [.topImage, .leftImage, .bottomImage, .rightImage, .onlyImage, .onlyTitle, .backgroundImage]
        clickedClosure?(types[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}
