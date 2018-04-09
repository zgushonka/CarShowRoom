//
//  ManufacturersViewModel.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/8/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import Foundation
import UIKit

final class ManufacturersViewModel: ItemsViewModelProtocol {
    private var manufacturers: [Manufacturer]
    let dataSource: AppDataSourceProtocol!
    
    init(dataProvider: AppDataSourceProtocol) {
        manufacturers = []
        self.dataSource = dataProvider
    }
    
    var viewTitle: String {
        return "ShowRoom"
    }
    
    var onDataUpdate: ( (_ isUpdated: Bool)->() )?
    
    private func askForNextItems() {
        dataSource.updateManufacurers() { [weak self] manufacturers, isLastUpdate in
            self?.manufacturers = manufacturers
            self?.onDataUpdate?(isLastUpdate)
        }
    }
    
    var itemsCount: Int {
        return manufacturers.count
    }
    
    func itemTitle(forIndex index: Int) -> String? {
        if manufacturers.count <= index {
            // ask dataProvider for next items
            askForNextItems()
            return nil
        }
        let manufacturer = manufacturers[index]
        return "\(index + 1). \(manufacturer.id) - \(manufacturer.name)"
    }
    
    func item(forIndex index: Int) -> AnyObject? {
        guard index < manufacturers.count else { return nil }
        return manufacturers[index]
    }
    
    func cellColor(forIndex index: Int) -> UIColor {
        let cellColor = CellColor(index)
        return cellColor.color
    }
    
}
