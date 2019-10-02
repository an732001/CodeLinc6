//
//  EventbriteEndpoint.swift
//  ConnectCorps
//
//  Created by Harish Yerra on 9/29/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

/*
import Foundation

enum EventbriteEndpoint: Endpoint {
    case searchEvents
    
    var baseURL: URL {
        return URL(string: "https://www.eventbriteapi.com")!
    }
    
    var version: String {
        return "3"
    }
    
    var path: String {
        switch self {
        case .searchEvents: return "events/search/"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchEvents: return .get
        }
    }
    
    var parameters: Data? {
        switch self {
        }
    }
    
    func asURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent("v\(version)").appendingPathComponent(path)
        var urlComps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        params: if let parameters = parameters {
            let dict = try! JSONSerialization.jsonObject(with: parameters, options: []) as! [String: Any]
            guard !dict.isEmpty else { break params }
            urlComps.queryItems = dict.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        var urlRequest = URLRequest(url: urlComps.url!)
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
    
    /// Converts `parameters` to `Data` for use with `URLRequest`.
    ///
    /// - Parameter parameters: The parameters to be encoded.
    /// - Returns: The data that was generated from the parameters.
    /// - Throws: An error that explains what went wrong in the encoding process.
    func convert<EncodableType: Encodable>(parameters: EncodableType) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let json = try encoder.encode(parameters)
        return json
    }
}
*/
