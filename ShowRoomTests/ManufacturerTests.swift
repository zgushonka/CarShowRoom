//
//  ManufacturerTests.swift
//  ShowRoomTests
//
//  Created by Oleksandr Buravlyov on 4/7/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import XCTest
@testable import ShowRoom

class ManufacturerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreation() {
        let id = "42"
        let name = "Marvin Ltd."
        
        let manufacturer = Manufacturer(id: id, name: name)
        
        XCTAssertNotNil(manufacturer)
        
        XCTAssertNotNil(manufacturer.id)
        XCTAssertEqual(manufacturer.id, id)
        
        XCTAssertNotNil(manufacturer.name)
        XCTAssertEqual(manufacturer.name, name)
    }
    
}
