//
//  APIRequest.swift
//  Shop IT
//
//  Created by Ozan on 4.08.2022.
//

import Foundation
import Alamofire

enum APIRequest {

    case getList
    case complete(items: [CartModel])
}

extension APIRequest: HTTPRequest {
    var method: HTTPMethod {
      
        switch self {
        case .complete(_):
            return .post
        default:
            return .get
        }
    }
    
    var baseUrl: String {
        return APIConstants.baseUrl
    }
    
    var path: String {
        switch self {
        case .complete(_):
            return APIConstants.apiCheckOut
        default:
            return APIConstants.apiList
        }
    }
    
    var parameters: [String: String] {
        var dictionary: [String: String] = [:]
        
        switch self {
        case let .complete(items):
            guard let data = try? JSONEncoder().encode(items) else { return dictionary }
            dictionary["products"] = String(data: data, encoding: .utf8)
        
        case .getList:
            dictionary = ["":""]
            break
        }
        return dictionary
    }
}
