//
//  NetworkEntityExtensions.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/8/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import Foundation

extension PageInfo {
    init?(fetchResult: FetchResult?) {
        guard fetchResult != nil,
            let page = fetchResult?.page,
            let pageSize = fetchResult?.pageSize,
            let totalPageCount = fetchResult?.totalPageCount else {
                return nil
        }
        self.page = page
        self.pageSize = pageSize
        self.totalPageCount = totalPageCount
    }
}

enum NetworkError: Error {
    case missedVitalResponseData
}

