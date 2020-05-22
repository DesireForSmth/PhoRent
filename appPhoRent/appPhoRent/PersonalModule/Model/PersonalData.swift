//
//  PersonalData.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//
import Foundation

struct PersonalData {
    var name: String
    var email: String
    var phone: String?
    var userID: String
    var imageURLString: String?
}

class UserManager {
    static let shared = UserManager()
    var currentUser: PersonalData?
    private init() {}
    
    
}
