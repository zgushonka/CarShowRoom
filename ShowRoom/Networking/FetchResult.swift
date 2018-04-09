//
//  FetchResult.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/8/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import Foundation
import ObjectMapper

struct FetchResult: Mappable {
    var page: Int?
    var pageSize: Int?
    var totalPageCount: Int?
    var data: [String: String]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        page <- map["page"]
        pageSize <- map["pageSize"]
        totalPageCount <- map["totalPageCount"]
        data <- map["wkda"]
    }
}
