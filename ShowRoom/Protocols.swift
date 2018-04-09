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
    func fetchManufacurers(page: Int, pageSize: Int, completion: @escaping (PageInfo?, [Manufacturer]?, Error?)->() )
    func fetchCars(manufacturer: Int, page: Int, pageSize: Int, completion: @escaping (PageInfo?, [Car]?, Error?)->() )
}


protocol AppDataSourceProtocol {
    func updateManufacurers(completion: @escaping ([Manufacturer], _ isLastUpdate: Bool)->() )
    func updateCars(manufacurer: Manufacturer, completion: @escaping (Manufacturer, _ isLastUpdate: Bool)->() )
}


protocol ItemsViewModelProtocol {
    var viewTitle: String { get }
    var itemsCount: Int { get }
    var onDataUpdate: ( (_ isLastUpdate: Bool)->() )? { get set }
    
    func itemTitle(forIndex index: Int) -> String?
    func item(forIndex index: Int) -> AnyObject?
    func cellColor(forIndex index: Int) -> UIColor
}

