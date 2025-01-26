//
//  TestListView.swift
//  TFYSwiftPagingView
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit


class TestListBaseView: UIView {
    var tableView: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        tableView = UITableView(frame: frame, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PagingListBaseCell.self, forCellReuseIdentifier: "cell")
        addSubview(tableView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        tableView.frame = bounds
    }

}

extension TestListBaseView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PagingListBaseCell
        cell.titleLabel.text = "row:\(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}

extension TestListBaseView: TFYSwiftListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
