//
//  APIClient.swift
//  Shop IT
//
//  Created by Ozan on 4.08.2022.
//

import Foundation
import RxSwift

class APIClient {
    
    private let restClient: RESTClient<APIRequest>
    
    public init(restClient: RESTClient<APIRequest>) {
        self.restClient = restClient
    }
    
    public func getList() -> Single<[ShopModel]> {
        return self.restClient.execute(request: .getList)
    }
    public func complete(models: [CartModel]) -> Single<CheckResponse> {
        return self.restClient.execute(request: .complete(items: models))
    }
}
