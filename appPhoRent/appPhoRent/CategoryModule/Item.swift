//
//  Item.swift
//  appPhoRent
//
//  Created by Александр Сетров on 30.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

struct Item {
<<<<<<< HEAD:appPhoRent/appPhoRent/RangeModule/Model/Item.swift
    var name: String
    var cost: String
    var manufacturer: String
    var imageURL: String
    var count: UInt
    
    init (name: String, cost: String, manufacturer: String, imageURL: String, count: UInt) {
=======
    init (name: String, cost: String, manufacturer: String, imageURL: String) {
>>>>>>> f0b0d0299be63dfa6ef382d61b877c5378e180c1:appPhoRent/appPhoRent/CategoryModule/Item.swift
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
}
