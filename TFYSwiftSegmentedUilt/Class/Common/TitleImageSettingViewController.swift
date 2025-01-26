//
//  TitleImageSettingViewController.swift
//  TFYSwiftView
//
//  Created by 田风有 on 2025/1/25.
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
