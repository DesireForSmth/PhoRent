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
    var name: String
    var cost: Int
    var imageURL: String
    var manufacturer: String
    var count: Int
    let categoryID: String
    var dbItemID: String
}

extension BasketItem {
    init(dictionary: Dictionary<String,Any>, itemID: String){
        name = dictionary["name"] as? String ?? ""
        cost = dictionary["cost"] as? Int ?? 1000
        imageURL = dictionary["imageURL"] as? String ?? ""
        manufacturer = dictionary["manufacturer"] as? String ?? ""
        count = dictionary["count"] as? Int ?? 1
        categoryID = dictionary["categoryID"] as? String ?? ""
        dbItemID = dictionary["itemID"] as? String ?? ""
        self.itemID = itemID
    }
}

struct Order {
    let orderID: String
    var date: String
    var countOfDay: Int
    var status: String
    var items: [BasketItem]
}
