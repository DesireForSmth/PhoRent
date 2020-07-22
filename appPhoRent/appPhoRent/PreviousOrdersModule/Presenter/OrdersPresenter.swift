//
//  OrdersPresenter.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 22.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation
protocol OrdersViewProtocol: class {
    func updateTable()
    func showAlert()
    func closeAlert()
    func failure(error: Error)
    func showNoInternetConnection()
}

protocol OrdersPresenterProtocol: class {
    init(view: OrdersViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol)
    func prepareData()
    func getItem(at indexPath: IndexPath) -> (String, String, Int, String)
    func getSectionTitle(section: Int) -> String?
    func getSectionFooter(section: Int) -> String?
    func getCountOfSection() -> Int
    func getCountOfRow(at section: Int) -> Int
}


class OrdersPresenter: OrdersPresenterProtocol {
    
    weak var view: OrdersViewProtocol?
    var router: RouterProtocol?
    let networkService: NetWorkServiceProtocol!
    
    var orders: [Order] = []
    
    required init(view: OrdersViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
    }
    
    func prepareData() {
        if networkService.isConnectedToNetwork() {
            view?.showAlert()
            networkService.getPreviousOrders() { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let orders):
                        self.orders = orders
                        if orders.count == 0 {
                                self.setTable(orders: self.orders)
                                self.view?.closeAlert()
                        }
                        self.fillItems()
                    case .failure(let error):
                            self.view?.failure(error: error)
                    }
                }
            }
        } else {
            view?.showNoInternetConnection()
        }
    }
    
    func fillItems() {
        var count = 0
        for indexOrder in 0..<orders.count {
            count += orders[indexOrder].items.count
        }
        
        for indexOrder in 0..<orders.count {
            for indexItem in 0..<orders[indexOrder].items.count {
                networkService.fillPreviousItem(categoryID: orders[indexOrder].items[indexItem].categoryID, itemID: orders[indexOrder].items[indexItem].dbItemID, completion: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let data):
                        self.orders[indexOrder].items[indexItem].name = data.0
                        self.orders[indexOrder].items[indexItem].cost = data.1
                        self.orders[indexOrder].items[indexItem].imageURL = data.2
                        self.orders[indexOrder].items[indexItem].manufacturer = data.3
                        
                        count -= 1
                        if count == 0 {
                            DispatchQueue.main.async {
                                self.setTable(orders: self.orders)
                                self.view?.closeAlert()
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.view?.failure(error: error)
                        }
                    }
                })
            }
        }
        
    }
    
    func setTable(orders: [Order]) {
        self.orders = orders
        view?.updateTable()
    }
    
    func getSectionTitle(section: Int) -> String? {
        let dateString = orders[section].date
        let title = "С \(dateString) на \(orders[section].countOfDay) сут."
        return title
    }
    
    func getSectionFooter(section: Int) -> String? {
        let title = "\(orders[section].status)"
        return title
    }
    
    func getCountOfSection() -> Int {
        return orders.count
    }
    
    func getCountOfRow(at section: Int) -> Int {
        if section < orders.count {
            return orders[section].items.count
        } else {
            return 0
        }
    }
    
    
    func getItem(at indexPath: IndexPath) -> (String, String, Int, String) {
        if indexPath.section < orders.count, indexPath.row < orders[indexPath.section].items.count  {
            let item = orders[indexPath.section].items[indexPath.row]
            return (item.name,
                String(item.cost) + " руб./сут.",
                item.count,
                item.imageURL)
        } else {
            return ("error", "error", 0, "")
        }
    }
    
}
