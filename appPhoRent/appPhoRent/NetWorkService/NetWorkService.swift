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
import SystemConfiguration

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
    func getPreviousOrders(completion: @escaping (Result<[Order], Error>) -> Void)
    func addItemInBasket(itemID: String, categoryID: String, count: Int, completion: @escaping (Result<String, Error>) -> Void)
    func removeFromBasket(itemID: String, dbItemID: String, categoryID: String, completion: @escaping (Result<String, Error>) -> Void)
    func saveImage(dataImage: Data)
    func putOrder(order: Order, completion: @escaping (Result<String, Error>) -> Void)
    func fillPreviousItem(categoryID: String, itemID: String, completion: @escaping (Result<(String, Int, String,String), Error>) -> Void)
    func isConnectedToNetwork() -> Bool
}

class NetworkService: NetWorkServiceProtocol {
    
  func isConnectedToNetwork() -> Bool {
      var zeroAddress = sockaddr_in()
      zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
      zeroAddress.sin_family = sa_family_t(AF_INET)
      guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
          $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
              zeroSockAddress in SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)}
      } ) else {
          return false
      }
      var flags : SCNetworkReachabilityFlags = []
      if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {return false}
      let isReachable = flags.contains(.reachable)
      let needsConnection = flags.contains(.connectionRequired)
      return (isReachable && !needsConnection)
  }
    
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
        completion(.success("Товар успешно добавлен в корзину!"))
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
        completion(.success("Товар удален из корзины!"))
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
    
    func putOrder (order: Order, completion: @escaping (Result<String, Error>) -> Void) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            assertionFailure("Ошибка доступа к пользователю")
            return
        }
        
        var items = Array<Dictionary<String, Any>>()
        var newItem = Dictionary<String, Any>()
        for item in order.items {
            newItem = [:]
            newItem["categoryID"] = item.categoryID
            newItem["itemID"] = item.dbItemID
            newItem["count"] = item.count
            items.append(newItem)
        }
        
        
        db.collection("users").document(userID).collection("orders").addDocument(data: [
            "items": items,
            "status": "В работе",
            "startDate": order.date,
            "countOfDay": order.countOfDay
        ]) { err in
            if let err = err {
                completion(.failure(err))
                print("error write document: \(err)")
            } else {
                completion(.success("success write document"))
            }
        }
        for item in order.items {
            db.collection("users").document(userID).collection("basket").document(item.itemID).delete { error in
                if let error = error {
                    completion(.failure(error))
                    print("Failed to delete: \(error)")
                }
            }
        }
    }
    
    func getPreviousOrders(completion: @escaping (Result<[Order], Error>) -> Void) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            assertionFailure("Ошибка доступа к пользователю")
            return
        }
        
        db.collection("users").document(userID).collection("orders").addSnapshotListener { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                let orders = documentSnapshot?.documents.map { (document) -> Order in
                    var order = Order(orderID: "", date: document.data()["startDate"] as? String ?? "", countOfDay: document.data()["countOfDay"] as? Int ?? 1, status: document.data()["status"] as? String ?? "", items: [])
                    var itemsInOrder: BasketItem?
                    let arrayItems = document.data()["items"] as? Array<Dictionary<String, Any>> ?? []
                    
                    for element in arrayItems {
                        itemsInOrder = BasketItem(dictionary: element, itemID: "")
                        order.items.append(itemsInOrder!)
                    }
                    return order
                }
                completion(.success(orders ?? []))
            }
        }
    }
    
    func fillPreviousItem(categoryID: String, itemID: String, completion: @escaping (Result<(String, Int, String,String), Error>) -> Void) {
        let db = Firestore.firestore()
        var name = ""
        var cost = 1000
        var imageURL = ""
        var manufacturer = ""
        db.collection("categories").document(categoryID ).collection("items").document(itemID).getDocument { (docSnap, error) in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                if let data = docSnap?.data() {
                    name = data["name"] as? String ?? ""
                    cost = data["cost"] as? Int ?? 1000
                    imageURL = data["imageURL"] as? String ?? ""
                    manufacturer = data["manufacturer"] as? String ?? ""
                }
                completion(.success((name, cost, imageURL, manufacturer)))
            }
        }
    }
}
