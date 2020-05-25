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
    
    func showAlert(message: String)
    
    func clearData()
}

protocol BasketPresenterProtocol: class {
    init(view: BasketViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol)
    func getItem(at: Int) -> (String, String, Int, String)
    func prepareData()
    func getNumberOfRow() -> Int
    
    func removeFromBasket(index: Int)
    func updateDate(newDate: Date)
    func updateCountOfDay(newCount: Int)
    func getDate() -> Date
    func putOrder()
    var currentOrder: Order? {get}
}

class BasketPresenter: BasketPresenterProtocol {
    
    weak var view: BasketViewProtocol?
    var router: RouterProtocol!
    let networkService: NetWorkServiceProtocol!
    
    var currentOrder: Order?
    
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
                    self.view?.closeAlert()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func setOrder(items: [BasketItem]) {
        if currentOrder != nil {
            currentOrder?.items = items
        } else {
            currentOrder = Order(orderID: "", date: Date(), countOfDay: 1, items: items)
        }
        view?.updateTable()
        view?.updateTotal(newTotalCost: countTotal(items: currentOrder?.items))
        updateDate(newDate: currentOrder?.date ?? Date())
    }
    
    func countTotal(items: [BasketItem]?) -> Int {
        var totalCost = 0
        for item in items ?? [] {
            totalCost += item.cost * item.count
        }
        totalCost *= currentOrder?.countOfDay ?? 1
        return totalCost
    }
    
    func updateCountOfDay(newCount: Int) {
        currentOrder?.countOfDay = newCount
        view?.updateTotal(newTotalCost: countTotal(items: currentOrder?.items))
    }
    
    func removeFromBasket(index: Int) {
        if let item = currentOrder?.items[index] {
            currentOrder?.items.remove(at: index)
            networkService.removeFromBasket(itemID: item.itemID, dbItemID: item.dbItemID, categoryID: item.categoryID){ [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result{
                    case .success(let message):
                        let total = self.countTotal(items: self.currentOrder!.items)
                        self.view?.updateTotal(newTotalCost: total)
                        self.view?.updateTable()
                        print(message)
                    case . failure(let error):
                        self.view?.failure(error: error)
                    }
                }
            }
        }
    }
    
    func updateDate(newDate: Date) {
        currentOrder?.date = newDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
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
    
    func putOrder() {
        if let order = currentOrder, order.items.count != 0 {
            networkService.putOrder(order: order)
            currentOrder = nil
            setOrder(items: [])
            view?.showAlert(message: "Заказ оформлен")
            
            view?.clearData()
        } else {
            view?.showAlert(message: "Корзина пуста!")
        }
    }
}
