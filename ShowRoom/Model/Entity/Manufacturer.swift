//
//  Manufacturer.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/7/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import Foundation

final class Manufacturer {
    let id: Int
    let name: String
    
    private (set) var cars: [Car] = []
    var maxCarCount: Int? = nil
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    func addCars(_ newCars: [Car]) {
        cars.append(contentsOf: newCars)
    }
}
