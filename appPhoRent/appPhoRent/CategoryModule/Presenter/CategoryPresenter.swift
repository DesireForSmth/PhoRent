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
    func failure(error: Error)
    func setItems(items: [Item]?)
    func showAlert()
    func closeAlert()
}

protocol CategoryViewPresenterProtocol: class {
    init (view: CategoryViewProtocol, router: RouterProtocol, category: Category, networkService: NetWorkServiceProtocol)
    func filtersPicked()
    func pop()
    func getCategoryName() -> String
    func getItems()
    func needDownload() -> Bool
    var items: [Item]? {get}
}

class CategoryPresenter: CategoryViewPresenterProtocol {
    
    let view: CategoryViewProtocol?
    var router: RouterProtocol?
    var category: Category?
    var items: [Item]?
    let networkService: NetWorkServiceProtocol!
    
    required init(view: CategoryViewProtocol, router: RouterProtocol, category: Category, networkService: NetWorkServiceProtocol) {
        self.category = category
        self.networkService = networkService
        self.view = view
        self.router = router
    }
    
    
    func filtersPicked() {
        print("I'm in")
        //view?.success()
        self.router?.showFilters()
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
                self.view?.setItems(items: self.items)
                self.view?.success()
//                self.view?.closeAlert()
            case .failure(let error):
                self.view?.failure(error: error)
                }
            }
        }
    }
    func needDownload() -> Bool {
        return self.items == nil
    }
   
}
