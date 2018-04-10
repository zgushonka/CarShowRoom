//
//  Protocols.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/8/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import Foundation
import UIKit


protocol DataFetcher {
    func fetchManufacturers(page: Int, pageSize: Int, completion: @escaping (PageInfo?, [Manufacturer]?, Error?)->() )
    func cancelManufacturersFetch(onIndex index: Int, pageSize: Int) // optional
    
    func fetchCars(manufacturerId: Int, page: Int, pageSize: Int, completion: @escaping (PageInfo?, [Car]?, Error?)->() )
    func cancelCarsFetch(manufacturerId: Int, onIndex index: Int, pageSize: Int) // optional
}

extension DataFetcher {
    func cancelManufacturersFetch(onIndex index: Int, pageSize: Int) {
        debugPrint("override me - cancelManufacturersFetch")
    }
    func cancelCarsFetch(manufacturerId: Int, onIndex index: Int, pageSize: Int) {
        debugPrint("override me - cancelCarsFetch")
    }
}


protocol AppDataSourceProtocol {
    func updateManufacturers(completion: @escaping ([Manufacturer], _ isLastUpdate: Bool)->() )
    func cancelManufacturersUpdate(atIndex index: Int)
    
    func updateCars(manufacurer: Manufacturer, completion: @escaping (Manufacturer, _ isLastUpdate: Bool)->() )
    func cancelCarsUpdate(manufacturer: Manufacturer, atIndex index: Int)
}

extension AppDataSourceProtocol {
    func cancelManufacturersUpdate(atIndex index: Int) {
        debugPrint("override me - cancelManufacturersPrefetch")
    }
    func cancelCarsUpdate(manufacturer: Manufacturer, atIndex: Int) {
        debugPrint("override me - cancelCarsPrefetch")
    }
}


protocol ItemsViewModelProtocol {
    var viewTitle: String { get }
    var itemsCount: Int { get }
    var onDataUpdate: ( (_ isLastUpdate: Bool)->() )? { get set }
    
    func itemTitle(forIndex index: Int) -> String?
    func item(forIndex index: Int) -> AnyObject?
    func cellColor(forIndex index: Int) -> UIColor
    
    func cancelPrefetch(atIndex index: Int)
}

extension ItemsViewModelProtocol {
    func cellColor(forIndex index: Int) -> UIColor {
        let cellColor = CellColor(index)
        return cellColor.color
    }
}

extension ItemsViewModelProtocol {
    func cancelPrefetch(atIndex index: Int) {
        debugPrint("override me - cancelPrefetch")
    }
}

