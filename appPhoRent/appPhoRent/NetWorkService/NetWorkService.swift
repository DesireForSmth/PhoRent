//
//  NetWorkService.swift
//  appPhoRent
//
//  Created by Ilya Buzyrev on 22.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFunctions

protocol NetWorkServiceProtocol {
    func getCategories(completion: @escaping (Result<[Category]?, Error>) -> Void)
    func getItems(categoryID: String, completion: @escaping (Result<[Item]?, Error>) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func signUp(username: String, email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func signOut(completion: @escaping (Result<String, Error>) -> Void)
    func passwordDrop(email: String?, completion: @escaping (Result<String, Error>) -> Void)
    func getPersonalInfo(completion: @escaping (Result<PersonalData, Error>) -> Void)
    func setPhone(phone: String, completion: @escaping (Result<String, Error>) -> Void)
    func getOrder(orderID: String, completion: @escaping (Result<Order, Error>) -> Void)
    func addItemInBasket(itemID: String, categoryID: String, completion: @escaping (Result<String, Error>) -> Void)
    func reduceCount(itemID: String, categoryID: String, completion: @escaping (Result<String, Error>) -> Void)
    func setNewCount(newCount: Int, itemTitle: String)
}

class NetworkService: NetWorkServiceProtocol {
    
    
    
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            let helloString = "access is success"
            completion(.success(helloString))
        }
    }
    
    func signUp(username: String, email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let db = Firestore.firestore()
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error{
                completion(.failure(error))
                return
            }
            guard let userID = Auth.auth().currentUser?.uid else {
                assertionFailure("Ошибка доступа к пользователю")
                return
            }
            db.collection("users").document(userID).setData(["username" : username, "email" : email, "ID" : userID]) { error in
                if let error = error{
                    completion(.failure(error))
                    return
                }
                let helloString = "access is success"
                completion(.success(helloString))
            }
            
        }
    }
    
    func signOut(completion: @escaping (Result<String, Error>) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            completion(.failure(signOutError))
            return
        }
        completion(.success("SignOut"))
    }
    
    func passwordDrop(email: String?, completion: @escaping (Result<String, Error>) -> Void) {
        if let email = email {
            if !email.isEmpty {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    let helloString = "access is success"
                    completion(.success(helloString))
                }
            }
        }
    }
    
    func getCategories(completion: @escaping (Result<[Category]?, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("categories").getDocuments() { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            var obj = [Category]()
            for document in querySnapshot!.documents {
                guard let categoryName = document.get("categoryName") as? String else {
                    assertionFailure("Ошибка доступа к имени категории")
                    return
                }
                guard let categoryImage = document.get("imageURL") as? String else {
                    assertionFailure("Ошибка доступа к изображению категории")
                    return
                }
                let category = Category(name:  categoryName, imageName: categoryImage, ID: document.documentID)
                obj.append(category)
            }
            completion(.success(obj))
        }
    }
    
    func getItems(categoryID: String, completion: @escaping (Result<[Item]?, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("categories").document(categoryID).collection("items").getDocuments() { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            var obj = [Item]()
            for document in querySnapshot!.documents {
                guard let itemName = document.get("name") as? String else {
                    assertionFailure("Ошибка доступа к имени товара")
                    return
                }
                guard let itemImage = document.get("imageURL") as? String else {
                    assertionFailure("Ошибка доступа к изображению товара")
                    return
                }
                guard let itemCost = document.get("cost") as? String, let itemIntCost = Int(itemCost) else {
                    assertionFailure("Ошибка доступа к цене товара")
                    return
                }
                guard let itemManufacturer = document.get("manufacturer") as? String else {
                    assertionFailure("Ошибка доступа к производителю товара")
                    return
                }
                guard let itemCount = document.get("count") as? Int else {
                    assertionFailure("Ошибка доступа к количеству товара")
                    return
                }
                let item = Item(name: itemName, cost: itemIntCost, manufacturer: itemManufacturer, imageURL: itemImage, count: itemCount, ID: document.documentID)
                obj.append(item)
            }
            completion(.success(obj))
        }
    }
    
    func addItemInBasket(itemID: String, categoryID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let functions = Functions.functions()
        functions.httpsCallable("addItemInBasket").call(["id": itemID, "category": categoryID]) { (result, error) in
            if let error = error as NSError? {
               if error.domain == FunctionsErrorDomain {
                 let code = FunctionsErrorCode(rawValue: error.code)
                 let message = error.localizedDescription
                 let details = error.userInfo[FunctionsErrorDetailsKey]
                 completion(.failure(error))
                 return
               }
        }
    }
        functions.httpsCallable("reduceCountofItem").call(["id": itemID, "category": categoryID, "count": 1]) { (result, error) in
                if let error = error as NSError? {
                   if error.domain == FunctionsErrorDomain {
                     let code = FunctionsErrorCode(rawValue: error.code)
                     let message = error.localizedDescription
                     let details = error.userInfo[FunctionsErrorDetailsKey]
                     completion(.failure(error))
                     return
                    }
            }
        }
        completion(.success("Done"))
    }
    
    
    func reduceCount(itemID: String, categoryID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let functions = Functions.functions()
        functions.httpsCallable("reduceCount").call(["ID": itemID, "category": categoryID, "count": 1]) { (result, error) in
                if let error = error as NSError? {
                   if error.domain == FunctionsErrorDomain {
                     let code = FunctionsErrorCode(rawValue: error.code)
                     let message = error.localizedDescription
                     let details = error.userInfo[FunctionsErrorDetailsKey]
                     completion(.failure(error))
                     return
                   }
            }
        }
        completion(.success("Done"))
    }
        
    
    func getPersonalInfo(completion: @escaping (Result<PersonalData, Error>) -> Void) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            assertionFailure("Ошибка доступа к пользователю")
            return
        }
        db.collection("users").document(userID).getDocument() { (document, error) in
            if let error = error{
                completion(.failure(error))
                return
            }
            let name = document?.get("username") as? String ?? ""
            let email = document?.get("email") as? String ?? ""
            let phone = document?.get("phone") as? String
            let obj = PersonalData(name: name, email: email, phone: phone, userID: userID)
            completion(.success(obj))
        }
    }
    
    func setPhone(phone: String, completion: @escaping (Result<String, Error>) -> Void) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            assertionFailure("Ошибка доступа к пользователю")
            return
        }
        db.collection("users").document(userID).updateData(["phone": phone]) { error in
            if let error = error{
                completion(.failure(error))
                return
            }
            completion(.success("Phone number has been seted"))
        }
    }
    
    
    func setOrder(orderID: String) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            assertionFailure("Ошибка доступа к пользователю")
            return
        }
        
        let cost1: Float = 1500
        let cost2: Float = 1000
        db.collection("users").document(userID).collection("orders").document(orderID).setData([
            "date": Date(),
            "totalCost": 6500,
            "items":
            ["goPro": ["price": cost1, "count": 3],
             "sony": ["price": cost2, "count": 2],
             ]
        ])
    }
    
    func setNewCount(newCount: Int, itemTitle: String) {
    }
    
    
    func getOrder(orderID: String, completion: @escaping (Result<Order, Error>) -> Void) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            assertionFailure("Ошибка доступа к пользователю")
            return
        }
        
        db.collection("users").document(userID).collection("orders").document(orderID).getDocument() { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            var items = [BasketItem]()
            if let dict = document?.get("items") as? Dictionary<String, Dictionary<String,Any>> {
                for element in dict {
                    let item = BasketItem(title: element.key, price: element.value["price"] as? Float ?? 0, count: element.value["count"] as? Int ?? 0)
                    items.append(item)
                }
            }
            
            let date = document?.get("date") as? Date ?? Date()
            let totalCost = document?.get("totalCost") as? Float ?? 0
            let order = Order(orderID: orderID, date: date, items: items, totalCost: totalCost)
            completion(.success(order))
        }
    }
}
