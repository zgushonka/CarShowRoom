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
    private let dataSource: AppDataSourceProtocol!
    init(manufacturer: Manufacturer, dataSource: AppDataSourceProtocol) {
        self.manufacturer = manufacturer
        self.dataSource = dataSource
    }
    
    
    var viewTitle: String {
        return manufacturer.name
    }
    
    var itemsCount: Int {
        return manufacturer.cars.count
    }
    
    var onDataUpdate: ( (_ isLastUpdate: Bool)->() )?
    
    
    func item(forIndex index: Int) -> AnyObject? {
        guard index < manufacturer.cars.count else { return nil }
        return  manufacturer.cars[index]
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
    
    private func askForNextItems() {
        dataSource.updateCars(manufacurer: manufacturer) { [weak self] manufacturer, isLastUpdate in
            self?.manufacturer = manufacturer
            self?.onDataUpdate?(isLastUpdate)
        }
    }
    
    func cancelPrefetch(atIndex index: Int) {
        dataSource.cancelCarsPrefetch(manufacturer: manufacturer, atIndex: index)
    }
    
}
