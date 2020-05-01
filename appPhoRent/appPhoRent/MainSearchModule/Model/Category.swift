//
//  Category.swift
//  appPhoRent
//
//  Created by Ilya Buzyrev on 21.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

struct Category {
    init(name: String, imageName: String, ID: String) {
        self.name = name
        self.imageName = imageName
        self.ID = ID
    }
    var name: String
    var imageName: String
    var ID: String
}

