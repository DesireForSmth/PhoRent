//
//  Item.swift
//  appPhoRent
//
//  Created by Александр Сетров on 30.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

struct Item {
    var name: String
    var cost: UInt
    var manufacturer: String
    var imageURL: String
    init (name: String, cost: UInt, manufacturer: String, imageURL: String) {
        self.name = name
        self.cost = cost
        self.manufacturer = manufacturer
        self.imageURL = imageURL
    }
}
