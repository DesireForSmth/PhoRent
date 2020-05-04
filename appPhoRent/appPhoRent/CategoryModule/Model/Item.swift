//
//  Item.swift
//  appPhoRent
//
//  Created by Александр Сетров on 30.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

struct Item {
    init (name: String, cost: String, manufacturer: String, imageURL: String, count: Int) {
        self.name = name
        self.cost = cost
        self.manufacturer = manufacturer
        self.imageURL = imageURL
        self.count = count
    }
    var name: String
    var cost: String
    var manufacturer: String
    var imageURL: String
    var count: Int
}
