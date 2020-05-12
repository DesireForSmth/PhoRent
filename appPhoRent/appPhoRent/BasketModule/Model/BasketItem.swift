//
//  BasketItem.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

struct BasketItem {
    let title: String
    let price: Float
    var count: Int
}

struct Order {
    let orderID: String
    var date: Date
    var items: [BasketItem]
    var totalCost: Float
}
