//
//  DataStorage.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/8/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import Foundation

final class AppDataSource: AppDataSourceProtocol {
    
    private var manufacurers: [Manufacturer]        // Page : Manufacturers
//    private var manufacurersPageInfo: PageInfo?
//    private var carsPageInfo: [Int:PageInfo]?
    private var maxManufacturerCount: Int?
    
    private var dataFetcher: DataFetcher
    private let pageSize: Int
    
    init(dataFetcher: DataFetcher, pageSize: Int) {
        self.dataFetcher = dataFetcher
        self.pageSize = pageSize
        manufacurers = []
    }
    
    // AppDataSourceProtocol methods
    // update Manufacturers
    private func isMoreManufacurersAvaliable() -> Bool {
        let result = isMorePagesAvaliable(itemsFetched: manufacurers.count,
                                          itemsPerPage: pageSize,
                                          totalCount: maxManufacturerCount)
        return result
    }
    
    var inManufacurersFetch = false
    func updateManufacurers(completion: @escaping ([Manufacturer], _ isLastUpdate: Bool)->() ) {
        let isAllDataFetched = !isMoreManufacurersAvaliable()
        if isAllDataFetched {
            completion(manufacurers, true)
            return
        }
        
        // fetch next page
        if inManufacurersFetch { return }
        inManufacurersFetch = true
        
        let pagesFetched = fetchedPages(manufacurers.count, pageSize)
        let nextPageIndex = pagesFetched
        dataFetcher.fetchManufacurers(page: nextPageIndex, pageSize: pageSize) { (pageInfo, manufacurers, error) in
            self.inManufacurersFetch = false
            guard error == nil else {
                // some internal error handling
                debugPrint("Warning: network error \(error!.localizedDescription)")
                return
            }
            guard let pageInfo = pageInfo,
                let manufacurers = manufacurers else {
                    debugPrint("Warning: payload mised.")
                    return
            }
            
            self.maxManufacturerCount = pageInfo.pageSize * pageInfo.totalPageCount
            self.manufacurers.append(contentsOf: manufacurers)
            
            let isAllDataFetched = !self.isMoreManufacurersAvaliable()
            completion(self.manufacurers, isAllDataFetched)
        }
    }
    
    
    // Update Cars
    private func isMoreCarsAvaliable(for manufacturer: Manufacturer) -> Bool {
        let result = isMorePagesAvaliable(itemsFetched: manufacturer.cars.count,
                                          itemsPerPage: pageSize,
                                          totalCount: manufacturer.maxCarCount)
        return result
    }
    
    var inCarsFetch = false
    func updateCars(manufacurer: Manufacturer, completion: @escaping (Manufacturer, _ isLastUpdate: Bool)->() ) {
        let isAllDataFetched = !isMoreCarsAvaliable(for: manufacurer)
        if isAllDataFetched {
            completion(manufacurer, true)
            return
        }
        
        // fetch next page
        if inCarsFetch { return }
        inCarsFetch = true
        
        let pagesFetched = fetchedPages(manufacurer.cars.count, pageSize)
        let nextPageIndex = pagesFetched
        dataFetcher.fetchCars(manufacturer: manufacurer.id, page: nextPageIndex, pageSize: pageSize) { (pageInfo, cars, error) in
            self.inCarsFetch = false
            guard error == nil else {
                // some internal error handling
                debugPrint("Warning: network error \(error!.localizedDescription)")
                return
            }
            guard let pageInfo = pageInfo,
                let cars = cars else {
                    debugPrint("Warning: payload mised.")
                    return
            }
            
            manufacurer.addCars(cars)
            manufacurer.maxCarCount = pageInfo.pageSize * pageInfo.totalPageCount
            
            let isAllDataFetched = !self.isMoreCarsAvaliable(for: manufacurer)
            completion(manufacurer, isAllDataFetched)
        }
    }
    
}


extension AppDataSource {
    // calc if we can fetch more data based on itemsFetched count and estimated items count
    private func isMorePagesAvaliable(itemsFetched: Int, itemsPerPage: Int, totalCount: Int?) -> Bool {
        guard let totalCount = totalCount else { return true } // assume we need to fetch the very first page
        let pagesFetched = fetchedPages(itemsFetched, itemsPerPage)
        let result = pagesFetched < (totalCount / itemsPerPage)
        return result
    }
    
    private func fetchedPages(_ itemsFetched: Int, _ itemPerPage: Int) -> Int {
        assert(itemPerPage != 0)
        return Int( (Double(itemsFetched) / Double(itemPerPage)).rounded(.up) )
    }
}

