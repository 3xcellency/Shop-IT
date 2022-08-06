//
//  ShopModel.swift
//  Shop IT
//
//  Created by Ozan on 4.08.2022.
//

import Foundation
struct ShopModel: Identifiable, Decodable,Encodable{
    
    let id: String
    let name: String
    let price: Double
    let currency: String
    let imageUrl: String
    let stock: Int
    
 
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case price = "price"
        case currency = "currency"
        case imageUrl = "imageUrl"
        case stock = "stock"
    }
}
