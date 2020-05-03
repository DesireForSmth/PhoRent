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
    func getCategory(categoryID: String, completion: @escaping (Result<[Item]?, Error>) -> Void)
}

class NetworkService: NetWorkServiceProtocol {
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
