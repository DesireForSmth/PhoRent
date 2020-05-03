//
//  NetWorkService.swift
//  appPhoRent
//
//  Created by Ilya Buzyrev on 22.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol NetWorkServiceProtocol {
    func getCategories(completion: @escaping (Result<[Category]?, Error>) -> Void)
<<<<<<< HEAD
<<<<<<< HEAD
    func getCategory(categoryID: String, completion: @escaping (Result<[Item]?, Error>) -> Void)
=======
    func getItems(category: String, completion: @escaping (Result<[Item]?, Error>) -> Void)
>>>>>>> f0b0d0299be63dfa6ef382d61b877c5378e180c1
=======
    func getItems(category: String, completion: @escaping (Result<[Item]?, Error>) -> Void)
>>>>>>> f0b0d0299be63dfa6ef382d61b877c5378e180c1
}

class NetworkService: NetWorkServiceProtocol {
    
    func getItems(category: String, completion: @escaping (Result<[Item]?, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("categories").getDocuments() { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                var obj = [Item]()
                for document in querySnapshot!.documents {
                    if let tempCategory: String = document.get("categoryName") as? String {
                        if tempCategory == category {
                            print(document.documentID)
                            let doc = db.collection("categories").document(document.documentID)
                            doc.collection("items").getDocuments() { (snap, error) in
                                if let error = error {
                                    completion(.failure(error))
                                    return
                                }
                                do {
                                for document2 in snap!.documents {
                                    print(document2.documentID)
                                    print(document2.get("cost"))
                                    //let cost = document2.get("cost")
                                    //let price = cost.integerValue
                                    let item = Item(name: document2.get("name") as! String, cost: document2.get("cost") as! String, manufacturer: document2.get("manufacturer") as! String, imageURL: document2.get("imageURL") as! String)
                                    obj.append(item)
                                                 }
                                    completion(.success(obj))
                                } catch {
                                    completion(.failure(error))
                                }
                            }
                            break
                        }
                    }
                    
                }
            } catch {
                completion(.failure(error))
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
                guard let categoryName = document.get("CategoryName") as? String else {
                                   assertionFailure("Ошибка доступа к имени категории")
                                   return
                               }
                guard let categoryImage = document.get("ImageURL") as? String else {
                                   assertionFailure("Ошибка доступа к изображению категории")
                                   return
                               }
                let category = Category(name:  categoryName, imageName: categoryImage, ID: document.documentID)
                obj.append(category)
                             }
                completion(.success(obj))
        }
    }
    
    func getCategory(categoryID: String, completion: @escaping (Result<[Item]?, Error>) -> Void) {
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
                guard let itemCost = document.get("cost") as? String else {
                    assertionFailure("Ошибка доступа к цене товара")
                    return
                }
                guard let itemManufacturer = document.get("manufacturer") as? String else {
                    assertionFailure("Ошибка доступа к производителю товара")
                    return
                }
                guard let itemCount = document.get("count") as? UInt else {
                    assertionFailure("Ошибка доступа к количеству товара")
                    return
                }
                let item = Item(name: itemName, cost: itemCost, manufacturer: itemManufacturer, imageURL: itemImage, count: itemCount)
                obj.append(item)
                             }
                completion(.success(obj))
        }
    }
    
    
    
}
