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
import FirebaseStorage

protocol NetWorkServiceProtocol {
    func getCategories(completion: @escaping (Result<[Category]?, Error>) -> Void)
    func getItems(categoryID: String, completion: @escaping (Result<[Item]?, Error>) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func signUp(username: String, email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func signOut(completion: @escaping (Result<String, Error>) -> Void)
    func passwordDrop(email: String?, completion: @escaping (Result<String, Error>) -> Void)
    func getPersonalInfo(completion: @escaping (Result<PersonalData, Error>) -> Void)
    func setPhone(phone: String, completion: @escaping (Result<String, Error>) -> Void)
    func getOrder(completion: @escaping (Result<[BasketItem], Error>) -> Void)
    func getPreviousOrders(completion: @escaping (Result<[PreviousOrder], Error>) -> Void)
    func addItemInBasket(itemID: String, categoryID: String, count: Int, completion: @escaping (Result<String, Error>) -> Void)
    //    func setNewCount(newCount: Int, itemID: String)
    func removeFromBasket(itemID: String, dbItemID: String, categoryID: String, completion: @escaping (Result<String, Error>) -> Void)
    func saveImage(dataImage: Data)
    func putOrder(order: Order)
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
        db.collection("categories").addSnapshotListener() { (querySnapshot, error) in
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
        db.collection("categories").document(categoryID).collection("items").whereField("count", isGreaterThan: 0).addSnapshotListener() { (querySnapshot, error) in
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
                guard let itemCost = document.get("cost") as? Int else {
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
                let item = Item(name: itemName, cost: itemCost, manufacturer: itemManufacturer, imageURL: itemImage, count: itemCount, ID: document.documentID)
                obj.append(item)
            }
            completion(.success(obj))
        }
    }
    
  
    
    func addItemInBasket(itemID: String, categoryID: String, count: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let functions = Functions.functions()
        functions.httpsCallable("addItemInBasket").call(["id": itemID, "category": categoryID, "count": count]) { (result, error) in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    completion(.failure(error))
                    return
                }
            }
        }
        completion(.success("Done"))
    }
    
    func removeFromBasket(itemID: String, dbItemID: String, categoryID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let functions = Functions.functions()
        functions.httpsCallable("deleteItemFromBasket").call(["itemID": itemID, "categoryID": categoryID, "dbItemID": dbItemID]) { (result, error) in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
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
            let imageURLString = document?.get("imageURL") as? String
            let obj = PersonalData(name: name, email: email, phone: phone, userID: userID, imageURLString: imageURLString)
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
    
    func saveImage(dataImage: Data) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        guard let userID = Auth.auth().currentUser?.uid else {
            assertionFailure("Ошибка доступа к пользователю")
            return
        }
        let imageRef = storageRef.child("images/\(userID)")
        imageRef.putData(dataImage, metadata: nil) { [weak self] (metadata, error) in
            guard let _ = metadata else {
                return
            }
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                self?.saveImageURL(userID: userID, url: downloadURL)
            }
        }
    }
    
    func saveImageURL(userID: String, url: URL) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).updateData(["imageURL": String(describing: url)]) { error in
            if let error = error{
                print("Error update imageURL: \(error)")
                return
            }
            print("ImageURL has been setted")
        }
    }
    
    
    //    func setOrder(orderID: String) {
    //        let db = Firestore.firestore()
    //        guard let userID = Auth.auth().currentUser?.uid else {
    //            assertionFailure("Ошибка доступа к пользователю")
    //            return
    //        }
    //
    //        let cost1: Float = 1500
    //        let cost2: Float = 1000
    //        db.collection("users").document(userID).collection("orders").document(orderID).setData([
    //            "date": Date(),
    //            "totalCost": 6500,
    //            "items":
    //                ["goPro": ["price": cost1, "count": 3],
    //                 "sony": ["price": cost2, "count": 2],
    //            ]
    //        ])
    //    }

    
    
    func getOrder(completion: @escaping (Result<[BasketItem], Error>) -> Void) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            assertionFailure("Ошибка доступа к пользователю")
            return
        }
        
        db.collection("users").document(userID).collection("basket")
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                } else {
                    let items = documentSnapshot?.documents.map { (document) -> BasketItem in
                        let item = BasketItem(dictionary: document.data(), itemID: document.documentID)
                        return item
                    }
                    completion(.success(items ?? []))
                }
        }
    }
    
    func putOrder(order: Order) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            assertionFailure("Ошибка доступа к пользователю")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: order.date)
        
        let orderID = "С \(dateString) на \(String(order.countOfDay)) сут."
        for item in order.items {
            
            db.collection("users").document(userID).collection(orderID).addDocument(data: [
                "name": item.name,
                "cost": item.cost,
                "imageURL": item.imageURL,
                "manufacturer": item.manufacturer,
                "count": item.count
            ])
            db.collection("users").document(userID).collection("basket").document(item.itemID).delete { error in
                if let error = error {
                    print("Failed to delete: \(error)")
                }
            }
            
        }
        
        var array = [String]()
        
        db.collection("users").document(userID).getDocument { [weak self](snapshot, error) in
            if let data = snapshot?.data() {
                if let data = data["orders"] as? Array<String> {
                    array = data
                    print("array=data\(array)")
                }
                array.append(orderID)
                self?.updateOrdersTitle(array: array)
            }
        }
    }
    
    func updateOrdersTitle(array: [String]) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            assertionFailure("Ошибка доступа к пользователю")
            return
        }
        db.collection("users").document(userID).updateData(["orders" : array]) { error in
            if let error = error {
                print("Failed to update orderID: \(error)")
            }
        }
    }
    
    func getPreviousOrders(completion: @escaping (Result<[PreviousOrder], Error>) -> Void) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            assertionFailure("Ошибка доступа к пользователю")
            return
        }
        
        var array = [String]()
        
        var orders = [PreviousOrder]()
        
        db.collection("users").document(userID).getDocument { [weak self](snapshot, error) in
//            print("wait 1")
            if let data = snapshot?.data() {
                if let data = data["orders"] as? Array<String> {
                    array = data
//                    print("array=data\(array)")
                }
                for orderTitle in array {
//                    print("wait 2")
                    db.collection("users").document(userID).collection(orderTitle).addSnapshotListener { documentSnapshot, error in
                        
                        if let error = error {
                            completion(.failure(error))
                            return
                        } else {
                            let items = documentSnapshot?.documents.map { (document) -> BasketItem in
                                let item = BasketItem(dictionary: document.data(), itemID: document.documentID)
                                return item
                            }
                            let order = PreviousOrder(items: items ?? [], header: orderTitle)
                            orders.append(order)
                            if orderTitle == array[array.count - 1] {
//                                print("wait 3")
//                                print("orders: \(orders)")
                                completion(.success(orders))
                            }
                        }
                    }
                }
            }
        }
    }
}
