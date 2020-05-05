//
//  PersonalData.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

struct PersonalData {
    var name: String
    var email: String
    var phone: String?
    var userID: String
//    var imageUrl: String?
}

class UserManager {
    static let shared = UserManager()
    var currentUser: PersonalData?
    private init() {}
    
    
}
