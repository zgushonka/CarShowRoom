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
        
        var url: String {
            return base + self.rawValue
        }
        
//        private var base: String {
//            return "your url"
//        }
        
//        static var key: String {
//            return "my key"
//        }
    }
}
