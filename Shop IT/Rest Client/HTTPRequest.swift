//
//  HTTPRequest.swift
//  Shop IT
//
//  Created by Ozan on 4.08.2022.
//


import Foundation
import Alamofire

protocol HTTPRequest: URLRequestConvertible {
    var method: HTTPMethod { get }
    var baseUrl: String { get }
    var path: String { get }
    var parameters: [String: String] { get }
}

extension HTTPRequest {
    func asURLRequest() throws -> URLRequest {
        guard var components = URLComponents(string: baseUrl) else {
            fatalError("Failed to create \(String(describing: URLComponents.self))")
        }
        components.path = self.path
        components.queryItems = self.parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        
        let url = try components.asURL()
        
        var request = URLRequest(url: url)
        
        request.method = self.method
        
        return request
    }
}
