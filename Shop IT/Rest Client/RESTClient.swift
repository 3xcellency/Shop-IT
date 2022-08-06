//
//  RESTClient.swift
//  Shop IT
//
//  Created by Ozan on 4.08.2022.
//

import Foundation
import RxAlamofire
import RxSwift
class RESTClient<HTTPRequestType: HTTPRequest> {
    func execute<ResponseBodyType: Decodable>(request: HTTPRequestType) -> Single<ResponseBodyType> {
        return (RxAlamofire.requestDecodable(request) as Observable<(HTTPURLResponse, ResponseBodyType)>)
            .map { $0.1 }
            .asSingle()
    }
}
