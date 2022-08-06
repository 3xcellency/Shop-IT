//
//  CartModel.swift
//  Shop IT
//
//  Created by Ozan on 6.08.2022.
//

import Foundation

struct CartModel: Identifiable, Decodable,Encodable, Hashable{
    
    let id: String
 
    let amount: Int
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case amount = "amount"
    }
}
