//
//  CarsViewModel.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/9/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import Foundation
import UIKit

final class CarsViewModel: ItemsViewModelProtocol {

    private var manufacturer: Manufacturer
    
    let dataSource: AppDataSourceProtocol!
    
    init(manufacturer: Manufacturer, dataProvider: AppDataSourceProtocol) {
        self.manufacturer = manufacturer
        self.dataSource = dataProvider
    }
    
    var viewTitle: String {
        return manufacturer.name
    }
    
    var onDataUpdate: ( (_ isLastUpdate: Bool)->() )?
    
    private func askForNextItems() {
        dataSource.updateCars(manufacurer: manufacturer) { [weak self] manufacturer, isLastUpdate in
            self?.manufacturer = manufacturer
            self?.onDataUpdate?(isLastUpdate)
        }
    }
    
    var itemsCount: Int {
        return manufacturer.cars.count
    }
    
    func itemTitle(forIndex index: Int) -> String? {
        if manufacturer.cars.count <= index {
            // ask dataProvider for next items
            askForNextItems()
            return nil
        }
        let car = manufacturer.cars[index]
        return "\(index + 1). \(car.name)"
    }
    
    func item(forIndex index: Int) -> AnyObject? {
        guard index < manufacturer.cars.count else { return nil }
        return  manufacturer.cars[index]
    }
    
    func cellColor(forIndex index: Int) -> UIColor {
        let cellColor = CellColor(index)
        return cellColor.color
    }
    
}
