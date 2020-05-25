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
}


protocol OrdersPresenterProtocol: class {
    init(view: OrdersViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol)
    func prepareData()
    func getItem(at indexPath: IndexPath) -> (String, String, Int, String)
    func getSectionTitle(section: Int) -> String?
    func getCountOfSection() -> Int
    func getCountOfRow(at section: Int) -> Int
}


class OrdersPresenter: OrdersPresenterProtocol {
    
    
    weak var view: OrdersViewProtocol?
    var router: RouterProtocol?
    let networkService: NetWorkServiceProtocol!
    
    var orders: [PreviousOrder] = []
    
    required init(view: OrdersViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
    }
    
    
    func prepareData() {
        view?.showAlert()
        networkService.getPreviousOrders() { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self.setTable(orders: items)
                    self.view?.closeAlert()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    
    func setTable(orders: [PreviousOrder]) {
        
        self.orders = orders

        view?.updateTable()
    }
    
    func getSectionTitle(section: Int) -> String? {
        return orders[section].header
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
                    //                    String(format: "%.0f", items[index].cost) + " руб./сут.",
                String(item.cost) + " руб./сут.",
                item.count,
                item.imageURL)
        } else {
            return ("error", "error", 0, "")
        }
    }
    
}
