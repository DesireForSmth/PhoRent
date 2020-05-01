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
}

class NetworkService: NetWorkServiceProtocol {
    func getCategories(completion: @escaping (Result<[Category]?, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("categories").getDocuments() { (querySnapshot, error) in
        if let error = error {
        completion(.failure(error))
            return
        }
            do {
                var obj = [Category]()
            for document in querySnapshot!.documents {
                let category = Category(name: document.get("categoryName") as! String, imageName: (document.get("imageURL") as? String)!, ID: document.documentID )
                obj.append(category)
                             }
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
    
        }
    }
    /*
    func getCategory(completion: @escaping (Result<[Item]?, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("categories").getDocu { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
        }
    }
    */
}
