//
//  CellColorTests.swift
//  ShowRoomTests
//
//  Created by Oleksandr Buravlyov on 4/8/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import XCTest
@testable import ShowRoom

class CellColorTests: XCTestCase {
    
    func testOdd() {
        let index = 7
        let cellColor = CellColor(index)
        
        XCTAssertNotNil(cellColor)
        
        let actualColor = cellColor.color
        let expectedColor = CellColor.odd.color
        XCTAssert(actualColor == expectedColor)
    }

    func testEven() {
        let index = 16
        let cellColor = CellColor(index)
        
        XCTAssertNotNil(cellColor)
        
        let actualColor = cellColor.color
        let expectedColor = CellColor.even.color
        XCTAssert(actualColor == expectedColor)
    }
}
