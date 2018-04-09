//
//  RootNavigationController.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/8/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vc = viewControllers.first as? ManufacturersViewController {
            // assemble first view controller
            let dataFetcher = WebDataFetcher()
            let dataSource = AppDataSource(dataFetcher: dataFetcher, pageSize: PageInfo.defaultPageSize)
            let viewModel = ManufacturersViewModel(dataSource: dataSource)
            vc.viewModel = viewModel
        }
    }
}
