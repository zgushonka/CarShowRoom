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
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    /// Creates an instance if String "id" can be represented as Int.
    convenience init?(id: String, name: String) {
        guard let intId = Int(id) else { return nil }
        self.init(id: intId, name: name)
    }
    
    func addCars(_ newCars: [Car]) {
        cars.append(contentsOf: newCars)
    }
}

