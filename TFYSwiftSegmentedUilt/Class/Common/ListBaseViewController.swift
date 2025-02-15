//
//  ListBaseViewController.swift
//  TFYSwiftView
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit


class ListBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: CGFloat(arc4random()%255)/255, green: CGFloat(arc4random()%255)/255, blue: CGFloat(arc4random()%255)/255, alpha: 1)
    }
}

extension ListBaseViewController: TFYSwiftListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
