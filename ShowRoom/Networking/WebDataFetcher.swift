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
    
    // TODO
    // let endpoints: EndpointsProtocol
    // let parameters: ParametersProtocol
    
    
    func fetchManufacturers(page: Int, pageSize: Int, completion: @escaping (PageInfo?, [Manufacturer]?, Error?)->() ) {
        debugPrint("Fetch manufacturers - page \(page)")
        let url = Endpoints.Auto.manufacturer.url
        let parameters: Parameters = ManufacureURLParameters.make(page: page,
                                                                  pageSize: pageSize,
                                                                  key: Endpoints.Auto.key)
        
        fetchData(url, parameters: parameters, completion: { fetchResult, error in
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
        })
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
    
    
    func fetchCars(manufacturerId: Int, page: Int, pageSize: Int, completion: @escaping (PageInfo?, [Car]?, Error?)->() ) {
        debugPrint("Fetch cars for \(manufacturerId) - page \(page)")
        let url = Endpoints.Auto.cars.url
        let parameters: Parameters = CarsURLParameters.make(manufacturer: manufacturerId,
                                                            page: page,
                                                            pageSize: pageSize,
                                                            key: Endpoints.Auto.key)
        fetchData(url, parameters: parameters, completion: { fetchResult, error in
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
        })
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
    
    
//    add Alamofire
    private var requests: [DataRequest] = []
    private func fetchData(_ url: URLConvertible,
                           parameters: Parameters? = nil,
                           completion: @escaping (FetchResult?, Error?)->() ) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let request = Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        guard !requests.contains(request) else {
            return // skip request
        }
        
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
}


extension DataRequest: Equatable {
    public static func ==(lhs:DataRequest, rhs:DataRequest) -> Bool {
        return lhs.request == rhs.request
    }
}
