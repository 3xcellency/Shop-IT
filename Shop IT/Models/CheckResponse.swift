//
//  CheckOutModel.swift
//  Shop IT
//
//  Created by Ozan on 6.08.2022.
//

import Foundation

struct CheckResponse: Decodable{
    
    let result: String
 
  
    enum CodingKeys: String, CodingKey {
        case result = "error"
    }
}
