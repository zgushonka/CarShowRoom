//
//  WebDataFetcherTests.swift
//  ShowRoomTests
//
//  Created by Buravlyov on 4/10/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import XCTest
@testable import ShowRoom

class WebDataFetcherTests: XCTestCase {
    
    var dataFetcher: WebDataFetcher!
    let pageSize = 15
    
    override func setUp() {
        super.setUp()
        
        dataFetcher = WebDataFetcher()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPageIndex0() {
        let index = 0
        let actualPage = dataFetcher.page(forIndex: index, pageSize: pageSize)
        let expectedPage = 0
        XCTAssertEqual(actualPage, expectedPage)
    }
    
    func testPageIndexNext() {
        let index = pageSize
        let actualPage = dataFetcher.page(forIndex: index, pageSize: pageSize)
        let expectedPage = 1
        XCTAssertEqual(actualPage, expectedPage)
    }
    
    func testPageIndexNextMinus1() {
        let index = pageSize - 1
        let actualPage = dataFetcher.page(forIndex: index, pageSize: pageSize)
        let expectedPage = 0
        XCTAssertEqual(actualPage, expectedPage)
    }
    func testPageIndexNextTimes2() {
        let index = pageSize * 2
        let actualPage = dataFetcher.page(forIndex: index, pageSize: pageSize)
        let expectedPage = 2
        XCTAssertEqual(actualPage, expectedPage)
    }
}
