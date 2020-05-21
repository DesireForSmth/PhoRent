//
//  BasketItem.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

struct BasketItem: Codable {
    let itemID: String
    let name: String
    let cost: Int
    let imageURL: String
    let manufacturer: String
    var count: Int
    
}

extension BasketItem {
    init(dictionary: Dictionary<String,Any>, itemID: String){
        name = dictionary["name"] as? String ?? ""
        cost = dictionary["cost"] as? Int ?? 1000
        imageURL = dictionary["imageURL"] as? String ?? ""
        manufacturer = dictionary["manufacturer"] as? String ?? ""
        count = dictionary["count"] as? Int ?? 1
        
        self.itemID = itemID
    }
}

struct Order {
    let orderID: String
    var date: Date
    var countOfDay: Int
    var items: [BasketItem]
//    var totalCost: Int
}
