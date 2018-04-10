//
//  WebDataFetcher.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/8/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import Foundation
import Alamofire

final class WebDataFetcher: DataFetcher {
    // TODO inject:
    // let endpoints: EndpointsProtocol
    // let parameters: ParametersProtocol

//    add Alamofire
    private var requests: [DataRequest] = []
    private func fetchData(_ request: DataRequest, completion: @escaping (FetchResult?, Error?)->() ) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        guard !requests.contains(request) else {
            return // skip request
        }
        requests.append(request)
        
        request.responseJSON { [weak self] response in
            if let requestIndex = self?.requests.index(of: request) {
                self?.requests.remove(at: requestIndex)
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let error = response.error {
                completion(nil, error)
                return
            }
            
            if let json = response.result.value as? [String:Any] {
                let result = FetchResult(JSON: json)
                completion(result, nil)
            } else {
                debugPrint("Warning: wrong response.")
                debugPrint(response)
            }
        }
    }
    
    private func cancelFetch(request: DataRequest) {
        if let requestIndex = requests.index(of: request) {
            let request = requests.remove(at: requestIndex)
            request.cancel()
        }
    }
    
    func page(forIndex index: Int, pageSize: Int) -> Int? {
        guard index >= 0, pageSize > 0 else { return nil }
        let page = Int( (Double(index) / Double(pageSize)).rounded(.down) )
        return page
    }
}

// fetch Manufacturers
extension WebDataFetcher {
    private func makeRequestForFetchManufacturers(page: Int, pageSize: Int) -> DataRequest {
        let url = Endpoints.Auto.manufacturer.url
        let parameters: Parameters = ManufacureURLParameters.make(page: page,
                                                                  pageSize: pageSize,
                                                                  key: Endpoints.Auto.key)
        return Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
    }
    
    func fetchManufacturers(page: Int, pageSize: Int, completion: @escaping (PageInfo?, [Manufacturer]?, Error?)->() ) {
        debugPrint("Fetch manufacturers - page \(page)")
        let request = makeRequestForFetchManufacturers(page: page, pageSize: pageSize)
        
        fetchData(request) { fetchResult, error in
            // check response
            guard error == nil else {
                completion(nil, nil, error)
                return
            }
            // check and parse data
            guard let fetchResult = fetchResult,
                let pageInfo = PageInfo(fetchResult: fetchResult),
                let dataDict = fetchResult.data else {
                    completion(nil, nil, NetworkError.missedVitalResponseData)
                    return
            }
            
            let manufacturers = self.parseManufacturers(dataDict)
            completion(pageInfo, manufacturers, nil)
        }
    }

    private func parseManufacturers(_ manufacturersDict: [String:String]) -> [Manufacturer] {
        var result = [Manufacturer]()
        for (id, name) in manufacturersDict {
            if let intId = Int(id) {
                let manufacturer = Manufacturer(id: intId, name: name)
                result.append(manufacturer)
            } else {
                debugPrint("Warning: can't read manufacturer ID.")
            }
        }
        result.sort { $0.name < $1.name }
        return result
    }
    
    func cancelManufacturersFetch(onIndex index: Int, pageSize: Int) {
        guard let page = page(forIndex: index, pageSize: pageSize) else { return }
        let request = makeRequestForFetchManufacturers(page: page, pageSize: pageSize)
        cancelFetch(request: request)
    }
}

// fetch Cars
extension WebDataFetcher {
    
    private func makeRequestForFetchCars(manufacturerId: Int, page: Int, pageSize: Int) -> DataRequest {
        let url = Endpoints.Auto.cars.url
        let parameters: Parameters = CarsURLParameters.make(manufacturer: manufacturerId,
                                                            page: page,
                                                            pageSize: pageSize,
                                                            key: Endpoints.Auto.key)
        return Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
    }
    
    
    func fetchCars(manufacturerId: Int, page: Int, pageSize: Int, completion: @escaping (PageInfo?, [Car]?, Error?)->() ) {
        debugPrint("Fetch cars for \(manufacturerId) - page \(page)")
        let request = makeRequestForFetchManufacturers(page: page, pageSize: pageSize)
        fetchData(request) { fetchResult, error in
            // check response
            guard error == nil else {
                completion(nil, nil, error)
                return
            }
            // check and parse data
            guard let fetchResult = fetchResult,
                let pageInfo = PageInfo(fetchResult: fetchResult),
                let dataDict = fetchResult.data else {
                    completion(nil, nil, NetworkError.missedVitalResponseData)
                    return
            }
            
            let cars = self.parseCars(dataDict)
            completion(pageInfo, cars, nil)
        }
    }
    
    private func parseCars(_ carsDict: [String:String]) -> [Car] {
        var result = [Car]()
        for (_, name) in carsDict {
            let car = Car(name: name)
            result.append(car)
        }
        result.sort { $0.name < $1.name }
        return result
    }
    
    func cancelCarsFetch(manufacturerId: Int, onIndex index: Int, pageSize: Int) {
        guard let page = page(forIndex: index, pageSize: pageSize) else { return }
        let request = makeRequestForFetchCars(manufacturerId: manufacturerId,page: page, pageSize: pageSize)
        cancelFetch(request: request)
    }
}


extension DataRequest: Equatable {
    public static func ==(lhs:DataRequest, rhs:DataRequest) -> Bool {
        return lhs.request == rhs.request
    }
}
