//
//  DataStorage.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/8/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import Foundation

final class AppDataSource: AppDataSourceProtocol {
    
    private var manufacturers: [Manufacturer]        // Page : Manufacturers
    
    private var manufacturersPageInfo: PageInfo?
    private var carsPageInfo: [Int:PageInfo] = [:]
    
    private var dataFetcher: DataFetcher
    private let pageSize: Int
    
    init(dataFetcher: DataFetcher, pageSize: Int) {
        self.dataFetcher = dataFetcher
        self.pageSize = pageSize
        manufacturers = []
    }
    
    // AppDataSourceProtocol methods
    // update Manufacturers
    private func isMoreManufacturersAvaliable() -> Bool {
        let result = isMorePagesAvaliable(itemsFetched: manufacturers.count,
                                          itemsPerPage: pageSize,
                                          totalPageCount: manufacturersPageInfo?.totalPageCount)
        return result
    }
    
    func updateManufacturers(completion: @escaping ([Manufacturer], _ isLastUpdate: Bool)->() ) {
        let isAllDataFetched = !isMoreManufacturersAvaliable()
        if isAllDataFetched {
            completion(manufacturers, true)
            return
        }
        
        // fetch next page
        let pagesFetched = fetchedPages(manufacturers.count, pageSize)
        let pageToFetch = pagesFetched
        dataFetcher.fetchManufacturers(page: pageToFetch, pageSize: pageSize) { [manufacturers, weak self] (pageInfo, newManufacturers, error) in
            guard error == nil else {
                // some internal error handling
                debugPrint("Warning: network error \(error!.localizedDescription)")
                return
            }
            guard let pageInfo = pageInfo,
                let newManufacturers = newManufacturers else {
                    debugPrint("Warning: payload mised.")
                    return
            }
            
            self?.manufacturersPageInfo = pageInfo
            var updatedManufacturers = manufacturers
            updatedManufacturers.append(contentsOf: newManufacturers)
            self?.manufacturers = updatedManufacturers
            
            let isLastPage = pageToFetch == (pageInfo.totalPageCount - 1)
            completion(updatedManufacturers, isLastPage)
        }
    }
    
    
    // Update Cars
    private func isMoreCarsAvaliable(for manufacturer: Manufacturer) -> Bool {
        let thisManufacturerCarsPageInfo = carsPageInfo[manufacturer.id]
        let result = isMorePagesAvaliable(itemsFetched: manufacturer.cars.count,
                                          itemsPerPage: pageSize,
                                          totalPageCount: thisManufacturerCarsPageInfo?.totalPageCount)
        return result
    }
    
    func updateCars(manufacurer: Manufacturer, completion: @escaping (Manufacturer, _ isLastUpdate: Bool)->() ) {
        let isAllDataFetched = !isMoreCarsAvaliable(for: manufacurer)
        if isAllDataFetched {
            completion(manufacurer, true)
            return
        }
        
        // fetch next page
        let pagesFetched = fetchedPages(manufacurer.cars.count, pageSize)
        let pageToFetch = pagesFetched
        dataFetcher.fetchCars(manufacturerId: manufacurer.id, page: pageToFetch, pageSize: pageSize) { [weak self] (pageInfo, cars, error) in
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
            
            self?.carsPageInfo[manufacurer.id] = pageInfo
            manufacurer.addCars(cars)
            
            let isLastPage = pageToFetch == (pageInfo.totalPageCount - 1)
            completion(manufacurer, isLastPage)
        }
    }
    
}


extension AppDataSource {
    // calc if we can fetch more data based on itemsFetched count and estimated items count
    private func isMorePagesAvaliable(itemsFetched: Int, itemsPerPage: Int, totalPageCount: Int?) -> Bool {
        guard let totalPageCount = totalPageCount else { return true } // assume we need to fetch the very first page
        let pagesFetched = fetchedPages(itemsFetched, itemsPerPage)
        let result = pagesFetched < totalPageCount
        return result
    }
    
    private func fetchedPages(_ itemsFetched: Int, _ itemPerPage: Int) -> Int {
        assert(itemPerPage != 0)
        return Int( (Double(itemsFetched) / Double(itemPerPage)).rounded(.up) )
    }
}

