//
//  BasketPresenter.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

protocol BasketViewProtocol: class {
    func showIndicator()
    func hideIndicator()
    
    func success(totalCost: Float, date: Date)
    func failure(error: Error)
}

protocol BasketPresenterProtocol: class {
    init(view: BasketViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol)
    func getItem(at: Int) -> (String, String, Int)
    func prepareData()
    func getNumberOfRow() -> Int
    
    func updateCount(newCount: Int, item: String)
    var currentOrder: Order? {get}
    var orderId: String {get set}
}

class BasketPresenter: BasketPresenterProtocol {

    weak var view: BasketViewProtocol?
    var router: RouterProtocol!
    let networkService: NetWorkServiceProtocol!
    
    var currentOrder: Order?
    var orderId: String = "1"

    required init(view: BasketViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
    }

    func prepareData() {
        view?.showIndicator()
        networkService.getOrder(orderID: orderId) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let order):
                    self.currentOrder = order
                    self.view?.success(totalCost: order.totalCost, date: order.date)
                    self.view?.hideIndicator()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func updateCount(newCount: Int, item: String) {
        networkService.setNewCount(newCount: newCount, itemTitle: item)
//        prepareData()
    }

    func getNumberOfRow() -> Int {
        return currentOrder?.items.count ?? 0
    }

    func getItem(at index: Int) -> (String, String, Int) {
        if let items = currentOrder?.items, index < items.count {
            return (items[index].title,
            String(format: "%.0f", items[index].price) + " руб./сут.",
            items[index].count)
        } else {
            return ("error", "error", 0)
        }
    }
}
