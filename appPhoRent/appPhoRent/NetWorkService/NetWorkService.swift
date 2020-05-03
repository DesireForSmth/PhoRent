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
    func getItems(category: String, completion: @escaping (Result<[Item]?, Error>) -> Void)
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
