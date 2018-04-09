//
//  Endpoints.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/8/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import Foundation

// you know what to do
struct Endpoints {
    
    enum Auto: String {
        case manufacturer = "/manufacturer"
        case cars = "/main-types"
        
        private var base: String {
            return "your url"
        }
        
        var url: String {
            return base + self.rawValue
        }
        
        static var key: String {
            return "your key"
        }
    }
}
