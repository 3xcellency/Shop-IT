//
//  CartStoreManager.swift
//  Shop IT
//
//  Created by Ozan on 5.08.2022.
//

import Foundation
class CartStoreManager
{
   
    //singleton
    public static var shared = CartStoreManager()

    var carts: [ShopModel]
    {
        get
        {
            guard let data = UserDefaults.standard.data(forKey: "carts") else { return [] }
            return (try? JSONDecoder().decode([ShopModel].self, from: data)) ?? []
        }
        set
        {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: "carts")
        }
    }
    private init(){}
}
