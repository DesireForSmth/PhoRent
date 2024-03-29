//
//  CategoryPresenter.swift
//  appPhoRent
//
//  Created by Александр Сетров on 30.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol CategoryViewProtocol: class {
    func success()
    func failure()
    func setItems(items: [Item]?)
    
    
    func showAlert(message: String)
    func showAlert()
    func closeAlert(completionMessage: String?)
    
}

protocol CategoryViewPresenterProtocol: class {
    init (view: CategoryViewProtocol, router: RouterProtocol, category: Category, networkService: NetWorkServiceProtocol)
    func filtersPicked()
    func pop()
    func getCategoryName() -> String
    func getItems()
    func needDownload() -> Bool
    var items: [Item]? {get}
    var shownItems: [Item]? {get}
    var manufacturers: Set<String> { get }
    var checkManufacturers: Set<String> { get }
    var costRange: Dictionary<String, CGFloat> { get }
    func getMaxCost() -> Int?
    func getMinCost() -> Int?
    func getMinCurCost() -> CGFloat?
    func getMaxCurCost() -> CGFloat?
    func getManufacturers()
    func appendManufacturer(name: String)
    func reduseManufacturer(name: String)
    func closeFilters()
    func containsManufacturer(name: String) -> Bool
    func setCostRange(minCost: CGFloat, maxCost: CGFloat)
    func getCostRange()
    func addItemInBasket(itemID: String, count: Int, itemIndex: Int)
    func reloadDataAfterAdd()
    
}

class CategoryPresenter: CategoryViewPresenterProtocol {
    
    let view: CategoryViewProtocol?
    var router: RouterProtocol?
    var category: Category?
    var items: [Item]?
    var shownItems: [Item]?
    var manufacturers: Set<String>
    let networkService: NetWorkServiceProtocol!
    var checkManufacturers: Set<String>
    var costRange: Dictionary<String, CGFloat>
    
    func needDownload() -> Bool {
        return self.items == nil
    }
    
    func getCostRange() {
        if let minCost = self.getMinCost(), let maxCost = self.getMaxCost() {
            self.costRange.updateValue(CGFloat(minCost), forKey: "minCost")
            self.costRange.updateValue(CGFloat(maxCost), forKey: "maxCost")
        }
    }
    
    func setCostRange(minCost: CGFloat, maxCost: CGFloat) {
        self.costRange.updateValue(CGFloat(minCost), forKey: "minCost")
        self.costRange.updateValue(CGFloat(maxCost), forKey: "maxCost")
    }
    
    func containsManufacturer(name: String) -> Bool {
        return checkManufacturers.contains(name)
    }
    
    func reduseManufacturer(name: String) {
        self.checkManufacturers.remove(name)
    }
    
    func appendManufacturer(name: String) {
        self.checkManufacturers.insert(name)
    }
    
    func closeFilters() {
        filterItems()
        view?.setItems(items: self.shownItems)
        view?.success()
    }
    
    // MARK: filter func
    
    func filterItems() {
        self.shownItems = []
        
        if let items = self.items {
            for item in items {
                if self.checkManufacturers.contains(item.manufacturer) && CGFloat(integerLiteral: item.cost) >= self.costRange["minCost"]! && CGFloat(integerLiteral: item.cost) <= self.costRange["maxCost"]! {
                    self.shownItems?.append(item)
                }
            }
        }
    }
    
    // MARK: init
    
    required init(view: CategoryViewProtocol, router: RouterProtocol, category: Category, networkService: NetWorkServiceProtocol) {
        self.category = category
        self.networkService = networkService
        self.view = view
        self.router = router
        self.manufacturers = []
        self.checkManufacturers = []
        self.costRange = [:]
    }
    
    func getManufacturers() {
        if let items = items {
            self.manufacturers = Set(items.map {$0.manufacturer})
            self.checkManufacturers = self.manufacturers
        }
    }
    
    func filtersPicked() {
        self.router?.showFilters(presenter: self)
    }
    
    func pop() {
        self.router?.popToRoot()
    }
    
    func getCategoryName() -> String {
        guard let name = self.category?.name else {
            return ""
        }
        return name
    }
    
    // MARK: items loading
    
    public func getItems() {
        guard let categoryID = self.category?.ID else {
            
            assertionFailure("Проблема с доступом к категории")
            return
        }
        
        networkService.getItems(categoryID: categoryID) { [weak self] result in
        guard let self = self else { return }
        DispatchQueue.main.async {
            
            switch result {
            case .success(let items):
                self.items = items
                self.shownItems = items
                self.view?.setItems(items: self.shownItems)
                
                self.view?.success()
            case .failure(let error):
                self.view?.failure()
                }
            }
        }
    }
    
    // MARK: order assembling
    
    func addItemInBasket(itemID: String, count: Int, itemIndex: Int) {
        if networkService.isConnectedToNetwork() {
            guard let categoryID = self.category?.ID else {
                assertionFailure("Проблема с доступом к категории")
                return
            }
            
            networkService.addItemInBasket(itemID: itemID, categoryID: categoryID, count: count) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result{
                    case .success(let message):
                        self.items?[itemIndex].count -= count
                        self.reloadDataAfterAdd()
                        self.addItemDone(message: message)
                    case .failure(let error):
                        self.addItemDone(message: "Не удалось добавить товар в корзину!")
                    }
                }
            }
            view?.showAlert()
        }else{
            view?.failure()
        }
    }
    
    func addItemDone(message: String) {
        view?.closeAlert(completionMessage: message)
    }
        
    
    
    func getMaxCurCost() -> CGFloat? {
        let cost = self.costRange["maxCost"]
        return cost
    }
    
    func getMinCurCost() -> CGFloat? {
        let cost = self.costRange["minCost"]
        return cost
    }
    
    func getMaxCost() -> Int? {
        guard (self.items != nil) else { return nil }
        if let maxCostItem = self.items?.max(by: {a, b in a.cost < b.cost}) {
            let maxCost = maxCostItem.cost
            
            return (maxCost)
        } else { return (nil) }
    }
    
    func getMinCost() -> Int? {
        guard (self.items != nil) else { return nil }
        if let minCostItem = self.items?.min(by: {a, b in a.cost < b.cost}) {
            let minCost = minCostItem.cost
            
            return (minCost)
        } else { return (nil) }
    }
   
    func reloadDataAfterAdd() {
        self.shownItems = []
        self.shownItems = self.items?.filter {$0.count > 0}
        self.view?.setItems(items: self.shownItems)
        self.view?.success()
    }
}
