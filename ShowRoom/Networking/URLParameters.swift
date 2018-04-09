//
//  ManufacureURLParameters.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/8/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import Foundation

struct ManufacureURLParameters {
    static func make(page: Int, pageSize: Int, key: String?) -> [String:Any] {
        var parameters: [String:Any] = [ParameterKey.page.rawValue: page,
                                        ParameterKey.pageSize.rawValue: pageSize]
        if let _ = key {
            parameters[ParameterKey.key.rawValue] = key
        }
        return parameters
    }
}

struct CarsURLParameters {
    static func make(manufacturer: Int, page: Int, pageSize: Int, key: String?) -> [String:Any] {
        var parameters: [String:Any] = [ParameterKey.manufacturer.rawValue: manufacturer,
                                        ParameterKey.page.rawValue: page,
                                        ParameterKey.pageSize.rawValue: pageSize]
        if let _ = key {
            parameters[ParameterKey.key.rawValue] = key
        }
        return parameters
    }
}

