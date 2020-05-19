//
//  DataManager.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 12.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class DataManager {
    private let colorSchemeKey = "colorSchemeKey"

    private let userDefaults = UserDefaults.standard
    
    static let shared = DataManager()
    
    private init() {}

    func save(colorScheme: String) {
        userDefaults.setValue(colorScheme, forKey: colorSchemeKey)
    }
    
    func loadColorScheme() -> String? {
        return userDefaults.value(forKey: colorSchemeKey) as? String
    }


}
