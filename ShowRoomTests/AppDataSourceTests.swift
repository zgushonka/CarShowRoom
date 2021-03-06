//
//  AppDataSourceTests.swift
//  ShowRoomTests
//
//  Created by Buravlyov on 4/10/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import XCTest
@testable import ShowRoom

//  interface
//    func updateManufacturers(completion: @escaping ([Manufacturer], _ isLastUpdate: Bool)->() )
//    func updateCars(manufacurer: Manufacturer, completion: @escaping (Manufacturer, _ isLastUpdate: Bool)->() )


class AppDataSourceTests: XCTestCase {
    
    private var dataSource: AppDataSourceProtocol! = nil
    
    override func setUp() {
        super.setUp()
        
        let dataFetcher = MockDataFetcher()
        XCTAssertNotNil(dataFetcher)
        dataSource = AppDataSource(dataFetcher: dataFetcher, pageSize: 15)
        XCTAssertNotNil(dataSource)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchManufacturers() {
        let expectation = XCTestExpectation(description: "fetch manufacturers")
        
        dataSource.updateManufacturers() { manufacturers, _ in
            XCTAssertNotNil(manufacturers)
            XCTAssert(manufacturers.count == 2)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: TimeInterval(5))
    }
    
    func testFetchCarsHappy() {
        let expectation = XCTestExpectation(description: "fetch manufacturer cars")
        
        let manufacturer = Manufacturer(id: 42, name: "Infinite Improbability Drives Ltd.")
        dataSource.updateCars(manufacurer: manufacturer) { manufacturer, _ in
            XCTAssertNotNil(manufacturer)
            XCTAssert(manufacturer.cars.count > 0)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: TimeInterval(5))
    }
    
    func testFetchManufacturersLastUpdateTrue() {
        let expectation = XCTestExpectation(description: "last page")
        
        dataSource.updateManufacturers() { _, isLastUpdate in
            XCTAssert(isLastUpdate)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: TimeInterval(5))
    }
    
    func testFetchManufacturersLastUpdateFalse() {
        let expectation = XCTestExpectation(description: "is not last page")
        
        let manufacturer = Manufacturer(id: 42, name: "Infinite Improbability Drives Ltd.")
        dataSource.updateCars(manufacurer: manufacturer) { _, isLastUpdate in
            XCTAssert(isLastUpdate == false)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: TimeInterval(5))
    }
    
    class MockDataFetcher: DataFetcher {
        func fetchManufacturers(page: Int, pageSize: Int, completion: @escaping (PageInfo?, [Manufacturer]?, Error?) -> ()) {
            let pageInfo = PageInfo(page: page, pageSize: pageSize, totalPageCount: page + 1)
            let manufacturers = [Manufacturer(id: 15, name: "AutoZAZ"), Manufacturer(id: 42, name: "Infinite Improbability Drives Ltd.")]
            completion(pageInfo, manufacturers, nil)
        }
        
        func fetchCars(manufacturerId: Int, page: Int, pageSize: Int, completion: @escaping (PageInfo?, [Car]?, Error?) -> ()) {
            guard manufacturerId == 42 else {
                completion(nil, nil, NetworkError.missedVitalResponseData)
                return
            }
            let pageInfo = PageInfo(page: page, pageSize: pageSize, totalPageCount: page + 10)
            let cars = [Car(name: "Heart of Gold")]
            completion(pageInfo, cars, nil)
        }
    }
    
}

