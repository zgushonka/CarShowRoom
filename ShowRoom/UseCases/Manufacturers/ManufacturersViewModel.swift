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
    private let dataSource: AppDataSourceProtocol!
    init(dataSource: AppDataSourceProtocol) {
        manufacturers = []
        self.dataSource = dataSource
    }
    
    
    var viewTitle: String {
        return "ShowRoom"
    }
    
    var itemsCount: Int {
        return manufacturers.count
    }
    
    var onDataUpdate: ( (_ isUpdated: Bool)->() )?

    func item(forIndex index: Int) -> AnyObject? {
        guard index < manufacturers.count else { return nil }
        return manufacturers[index]
    }
    
    func itemTitle(forIndex index: Int) -> String? {
        if manufacturers.count <= index {
            // ask dataSource for next items
            askForNextItems()
            return nil
        }
        let manufacturer = manufacturers[index]
        return "\(index + 1). \(manufacturer.id) - \(manufacturer.name)"
    }
    
    private func askForNextItems() {
        dataSource.updateManufacturers() { [weak self] manufacturers, isLastUpdate in
            self?.manufacturers = manufacturers
            self?.onDataUpdate?(isLastUpdate)
        }
    }
    
    func cancelPrefetch(atIndex index: Int) {
        dataSource.cancelManufacturersUpdate(atIndex: index)
    }
    
}
