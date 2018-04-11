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

    private var requests: [DataRequest] = []
    private func fetchData(_ request: DataRequest, completion: @escaping (FetchResult?, Error?)->() ) {
        guard addNewRequest(request) == true else { return } // skip request if exists
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        request.responseJSON { [weak self] response in
            self?.deleteRequest(request)
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
    
    /// Returns True if this is a new request. Returns False if this request already exists.
    private func addNewRequest(_ request: DataRequest) -> Bool {
        guard !requests.contains(request) else { return false }
        requests.append(request)
        return true
    }
    
    private func cancelRequest(_ request: DataRequest) {
        deleteRequest(request)?.cancel()
    }
    
    @discardableResult private func deleteRequest(_ request: DataRequest) -> DataRequest? {
        guard let requestIndex = requests.index(of: request) else { return nil }
        return requests.remove(at: requestIndex)
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
        let parameters: Parameters = WebParameter.make(page: page,
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

    func parseManufacturers(_ dict: [String:String]) -> [Manufacturer] {
        let resultOpt = dict.map { Manufacturer(id: $0.key, name: $0.value) }
        let result = resultOpt.filter { $0 != nil } as! [Manufacturer]
        return result.sorted { $0.name < $1.name }
    }
    
    func cancelManufacturersFetch(onIndex index: Int, pageSize: Int) {
        guard let page = page(forIndex: index, pageSize: pageSize) else { return }
        let request = makeRequestForFetchManufacturers(page: page, pageSize: pageSize)
        cancelRequest(request)
    }
}



// fetch Cars
extension WebDataFetcher {
    private func makeRequestForFetchCars(manufacturerId: Int, page: Int, pageSize: Int) -> DataRequest {
        let url = Endpoints.Auto.cars.url
        let parameters: Parameters = WebParameter.make(manufacturer: manufacturerId,
                                                       page: page,
                                                       pageSize: pageSize,
                                                       key: Endpoints.Auto.key)
        return Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
    }
    
    func fetchCars(manufacturerId: Int, page: Int, pageSize: Int, completion: @escaping (PageInfo?, [Car]?, Error?)->() ) {
        debugPrint("Fetch cars for \(manufacturerId) - page \(page)")
        let request = makeRequestForFetchCars(manufacturerId: manufacturerId, page: page, pageSize: pageSize)
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
    
    private func parseCars(_ dict: [String:String]) -> [Car] {
        let result = dict.map { Car(name: $0.value) }
        return result.sorted { $0.name < $1.name }
    }
    
    func cancelCarsFetch(manufacturerId: Int, onIndex index: Int, pageSize: Int) {
        guard let page = page(forIndex: index, pageSize: pageSize) else { return }
        let request = makeRequestForFetchCars(manufacturerId: manufacturerId,page: page, pageSize: pageSize)
        cancelRequest(request)
    }
}


extension DataRequest: Equatable {
    public static func == (lhs:DataRequest, rhs:DataRequest) -> Bool {
        return lhs.request == rhs.request
    }
}
