//
//  BasketPresenter.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

protocol BasketViewProtocol: class {
    func showAlert()
    func closeAlert()
    
    //    func success(totalCost: Int, date: Date)
    func failure(error: Error)
    func updateDateLabel(newDate: String)
    func updateTotal(newTotalCost: Int)
    func updateTable()
}

protocol BasketPresenterProtocol: class {
    init(view: BasketViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol)
    func getItem(at: Int) -> (String, String, Int, String)
    func prepareData()
    func getNumberOfRow() -> Int
    
    func updateCount(newCount: Int, index: Int)
    func updateDate(newDate: Date)
    func getDate() -> Date
    var currentOrder: Order? {get}
    
    //    var orderId: String {get set}
}

class BasketPresenter: BasketPresenterProtocol {
    
    
    weak var view: BasketViewProtocol?
    var router: RouterProtocol!
    let networkService: NetWorkServiceProtocol!
    
    var currentOrder: Order?
    //    var orderId: String = "1"
    
    required init(view: BasketViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
    }
    
    func prepareData() {
        view?.showAlert()
        networkService.getOrder() { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self.setOrder(items: items)
                    //                    self.currentOrder = order
                    //                    self.view?.success(totalCost: order.totalCost, date: order.date)
                    self.view?.closeAlert()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func setOrder(items: [BasketItem]) {
        
        currentOrder = Order(orderID: "", date: Date(), items: items, totalCost: countTotal(items: items))
        if let order = currentOrder {
            view?.updateTable()
            view?.updateTotal(newTotalCost: order.totalCost)
            updateDate(newDate: order.date)
        }
    }
    
    func countTotal(items: [BasketItem]) -> Int {
        var totalCost = 0
        for item in items {
            totalCost += item.cost * item.count
        }
        return totalCost
    }
    
    func updateCount(newCount: Int, index: Int) {
        if let item = currentOrder?.items[index] {
            if newCount == 0 {
                currentOrder?.items.remove(at: index)
                networkService.removeFromBasket(itemID: item.itemID)
                let total = countTotal(items: currentOrder!.items)
                currentOrder?.totalCost = total
                view?.updateTotal(newTotalCost: total)
                view?.updateTable()
                
            } else {
                networkService.setNewCount(newCount: newCount, itemID: item.itemID)
                currentOrder!.items[index].count = newCount
                let total = countTotal(items: currentOrder!.items)
                currentOrder?.totalCost = total
                view?.updateTotal(newTotalCost: total)
            }
            
            
        }
        //        if let itemID = currentOrder?.items[index].itemID {
        //            networkService.setNewCount(newCount: newCount, itemID: itemID)
        //        }
        
        //        prepareData()
    }
    
    func updateDate(newDate: Date) {
        currentOrder?.date = newDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        //        dateFormatter.dateStyle = DateFormatter.Style.medium
        let dateString = dateFormatter.string(from: newDate)
        view?.updateDateLabel(newDate: dateString)
    }
    
    func getDate() -> Date {
        return currentOrder?.date ?? Date()
    }
    
    func getNumberOfRow() -> Int {
        return currentOrder?.items.count ?? 0
    }
    
    func getItem(at index: Int) -> (String, String, Int, String) {
        if let items = currentOrder?.items, index < items.count {
            return (items[index].name,
                    //                    String(format: "%.0f", items[index].cost) + " руб./сут.",
                String(items[index].cost) + " руб./сут.",
                items[index].count,
                items[index].imageURL)
        } else {
            return ("error", "error", 0, "")
        }
    }
}
