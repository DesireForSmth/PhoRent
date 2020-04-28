//
//  BasketPresenter.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 22.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

//import Foundation

import Firebase


protocol BasketViewProtocol: class {
    func reloadTableView()
    func setTotalCost(total: Float)
    func showIndicator()
    func hideIndicator()
}

protocol BasketPresenterProtocol: class {
    init(view: BasketViewProtocol, router: RouterProtocol)
    func getItem(at: Int) -> (String, String, Int)
    func prepareData()
    func getNumberOfRow() -> Int
    var currentCost: Float { get }
}


class BasketPresenter: BasketPresenterProtocol {
    
    
    weak var view: BasketViewProtocol?
    var router: RouterProtocol?
    
    var currentItems: [BasketItem] = []
    var currentCost: Float = 6500
    var ref: DatabaseReference?
    var userID: String?
    
    required init(view: BasketViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        
        
    }
    
    func prepareData() {
        ref = Database.database().reference()
        userID = Auth.auth().currentUser?.uid
        
        currentItems = []
        //        ref?.child("users/\(userID!)/orders/1/items/sony/count").setValue(2)
        //        ref?.child("users/\(userID!)/orders/1/items/sony/price").setValue(1000)
        
        view?.showIndicator()
        ref?.child("users").child("\(userID!)/orders/1/items").observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            self?.view?.hideIndicator()
            
            if let value = snapshot.value as? NSDictionary {
                for item in value {
                    guard let attr = item.value as? NSDictionary else { return }
                    guard let title = item.key as? String, let count = attr["count"] as? Int, let price = attr["price"] as? Float else { return }
                    let newItem = BasketItem(title: title, price: price, count: count)
                    self?.currentItems.append(newItem)
                }
                self?.view?.reloadTableView()
                self?.view?.setTotalCost(total: self?.currentCost ?? 0)
            }
            
        }) { (error) in
            print("Error: ")
            print(error.localizedDescription)
        }
        print(currentItems.count)
    }
    
    func getNumberOfRow() -> Int {
        return currentItems.count
    }
    
    
    func getItem(at index: Int) -> (String, String, Int) {
        if index < currentItems.count {
            return (currentItems[index].title,
                    String(format: "%.0f", currentItems[index].price) + " руб./сут.",
                    currentItems[index].count)
        } else {
            return ("error", "error", 0)
        }
        
    }
}


