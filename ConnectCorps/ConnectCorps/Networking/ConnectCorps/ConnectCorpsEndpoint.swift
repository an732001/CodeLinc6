//
//  ConnectCorpsEndpoint.swift
//  ConnectCorps
//
//  Created by Harish Yerra on 9/28/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import Foundation

enum ConnectCorpsEndpoint: Endpoint {    
    case fetchBenefits
    case fetchContacts
    
    var baseURL: URL {
        return URL(string: "https://lincolncodelink.s3.us-east-2.amazonaws.com/")!
    }
    
    var path: String {
        switch self {
        case .fetchBenefits: return "VeteransBenefit/benefits.json"
        case .fetchContacts: return "contactinfo/contactinfo.json"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Data? {
        return nil
    }
    
    func asURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        let urlComps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        var urlRequest = URLRequest(url: urlComps.url!)
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}

import Foundation

enum ConnectCorpsEndpointAlternate: Endpoint {
    case fetchHouses
    
    var baseURL: URL {
        return URL(string: "https://connectcorps.ml/")!
    }
    
    var path: String {
        switch self {
        case .fetchHouses: return "housing.json"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Data? {
        return nil
    }
    
    func asURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        let urlComps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        var urlRequest = URLRequest(url: urlComps.url!)
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}
