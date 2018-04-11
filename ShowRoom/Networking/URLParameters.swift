//
//  ManufacureURLParameters.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/8/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import Foundation

struct WebParameter {
    static func make(page: Int, pageSize: Int, key: String?) -> [String:Any] {
        var parameters: [String:Any] = [Parameter.page.rawValue: page,
                                        Parameter.pageSize.rawValue: pageSize]
        if let _ = key {
            parameters[Parameter.key.rawValue] = key
        }
        return parameters
    }

    static func make(manufacturer: Int, page: Int, pageSize: Int, key: String?) -> [String:Any] {
        var parameters: [String:Any] = [Parameter.manufacturer.rawValue: manufacturer,
                                        Parameter.page.rawValue: page,
                                        Parameter.pageSize.rawValue: pageSize]
        if let _ = key {
            parameters[Parameter.key.rawValue] = key
        }
        return parameters
    }
}

enum Parameter: String {
    case manufacturer
    case page
    case pageSize
    case key = "wa_key"
}

