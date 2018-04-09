//
//  Constants.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/8/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import Foundation
import UIKit

enum CellColor: Int {
    case odd
    case even
    
    init(_ index: Int) {
        let isEven = (index % 2) == 0
        self = isEven ? CellColor.even : CellColor.odd
    }
    
    var color: UIColor {
        let alpha: CGFloat = 0.5
        switch self {
        case .odd:
            return UIColor(red: 253.0/255, green: 202.0/255, blue: 46.0/255, alpha: alpha)
        case .even:
            return UIColor(red: 55.0/255, green: 107.0/255, blue: 251.0/255, alpha: alpha)
        }
    }
}

enum AppSegue: String {
    case showManufacturers
    case showCars
}
