//
//  CarTests.swift
//  ShowRoomTests
//
//  Created by Oleksandr Buravlyov on 4/7/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import XCTest
@testable import ShowRoom

class CarTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreation() {
        let name = "Marvin Ltd."
        
        let car = Car(name: name)
        
        XCTAssertNotNil(car)
        
        XCTAssertNotNil(car.name)
        XCTAssertEqual(car.name, name)
    }
    
}
