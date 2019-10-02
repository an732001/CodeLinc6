//
//  ConnectCorpsClient.swift
//  ConnectCorps
//
//  Created by Harish Yerra on 9/28/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import Foundation
import MapboxGeocoder

final class ConnectCoreClient: APIClient {
    static let shared = ConnectCoreClient()
    
    init() { }
    
    @discardableResult
    func fetchHouses(completion: @escaping (APIResult<[House]>) -> Void) -> URLSessionDataTask {
        let housesEndpoint = ConnectCorpsEndpointAlternate.fetchHouses
        return connect(to: housesEndpoint) { (result: APIResult<[House]>) in
            if case let .success(houses) = result {
                var theHouses: [House] = []
                
                var numberOfRuns = 0 {
                    didSet {
                        if numberOfRuns == theHouses.count {
                            completion(.success(theHouses))
                        }
                    }
                }
                
                for var house in houses {
                    let options = ForwardGeocodeOptions(query: house.address)
                    let task = Geocoder.shared.geocode(options) { (placemarks, attribution, error) in
                        guard let placemark = placemarks?.first else {
                            numberOfRuns += 1
                            return
                        }
                        house.location = placemark.location
                        theHouses.append(house)
                        numberOfRuns += 1
                    }
                    task.resume()
                }
            }
        }
    }
    
    @discardableResult
    public func fetchBenefits(completion: @escaping (APIResult<[Benefit]>) -> Void) -> URLSessionDataTask {
        let benefitsEndpoint = ConnectCorpsEndpoint.fetchBenefits
        return connect(to: benefitsEndpoint, completion: completion)
    }
    
    @discardableResult
    public func fetchContact(completion: @escaping (APIResult<[Contact]>) -> Void) -> URLSessionDataTask {
        let contactsEndpoint = ConnectCorpsEndpoint.fetchContacts
        return connect(to: contactsEndpoint, completion: completion)
    }
    
    // MARK: - API client
    
    @discardableResult
    func connect(to request: URLRequestConvertible, completion: @escaping (NetworkingResponse) -> Void) -> URLSessionDataTask {
        let request = request.asURLRequest()
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            #if DEBUG
            print(response as Any)
            #endif
            DispatchQueue.main.async {
                completion((data, response, error))
            }
        }
        
        dataTask.resume()
        return dataTask
    }
    
    @discardableResult
    func connect<T>(to request: URLRequestConvertible, parse: ((NetworkingResponse) -> APIResult<T>)? = nil, completion: @escaping (APIResult<T>) -> Void) -> URLSessionDataTask {
        return connect(to: request) { response in
            if let parse = parse {
                let parsedValue = parse(response)
                completion(parsedValue)
            } else {
                let decoder = JSONDecoder()
                guard let data = response.data else { completion(.failure(response.error!)); return }
                do {
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
    }
}
