//
//  PageInfo.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/8/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import Foundation

struct PageInfo {
    let page: Int
    let pageSize: Int
    let totalPageCount: Int
}

extension PageInfo {
    static let defaultPageSize = 15
}
