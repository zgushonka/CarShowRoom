//
//  ManufacturersViewController.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/9/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import UIKit

class ManufacturersViewController: ItemsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.viewTitle
        cellAccessoryType = .disclosureIndicator
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ItemsViewController {
            if let selectedItemIndex = tableView.indexPathForSelectedRow?.row,
                let manufacturer = viewModel.item(forIndex: selectedItemIndex) as? Manufacturer {
                let dataFetcher = WebDataFetcher()
                let dataSource = AppDataSource(dataFetcher: dataFetcher, pageSize: PageInfo.defaultPageSize)
                let viewModel = CarsViewModel(manufacturer: manufacturer, dataProvider: dataSource)
                vc.viewModel = viewModel
            }
        }
    }
}
