//
//  ItemsViewController.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/8/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var viewModel: ItemsViewModelProtocol! {
        didSet {
            viewModel.onDataUpdate = { [weak self] isLastUpdate in
                self?.updateUI(isLastUpdate)
            }
        }
    }
    
    var cellAccessoryType: UITableViewCellAccessoryType = .none
    
    // shows activity ondicator and provoke to fetch new data
    var activityCell = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.prefetchDataSource = self
        title = viewModel.viewTitle
    }
    
    private func updateUI(_ isLastUpdate: Bool) {
        if isLastUpdate {
            // hide additionalCell
            activityCell = 0
        }
        tableView.reloadData()
    }
    
//  tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsCount + activityCell
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCellReuseIdentifier", for: indexPath) as! ItemTableViewCell
        if let title = viewModel.itemTitle(forIndex: indexPath.row) {
            cell.setTitle(title)
            cell.accessoryType = cellAccessoryType
        }
        cell.backgroundColor = viewModel.cellColor(forIndex: indexPath.row)
        return cell
    }

}

extension ItemsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let latestIndexPath = indexPaths.sorted(by:<).last {
            let _ = viewModel.itemTitle(forIndex: latestIndexPath.row)
        }
    }
}
