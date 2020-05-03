//
//  CategoryPresenter.swift
//  appPhoRent
//
//  Created by Александр Сетров on 30.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

protocol CategoryViewProtocol: class {
    func success()
    func failure(error: Error)
}

class CategoryView: CategoryViewProtocol {
    func success() {
        
    }
    func failure(error: Error) {
        
    }
}

protocol CategoryViewPresenterProtocol: class {
    init (view: CategoryViewProtocol, router: RouterProtocol, categoryName: String, networkService: NetWorkServiceProtocol)
    func getCategory() -> String
    func filtersPicked()
    func pop()
    //func getItems() ->
    func getItems()
    var items: [Item]? {get}
}

class CategoryPresenter: CategoryViewPresenterProtocol {

    
    let view: CategoryViewProtocol?
    var router: RouterProtocol?
    var categoryName: String?
    var items: [Item]?
    let networkService: NetWorkServiceProtocol!
    
    required init(view: CategoryViewProtocol, router: RouterProtocol, categoryName: String, networkService: NetWorkServiceProtocol) {
        self.categoryName = categoryName
        self.networkService = networkService
        self.view = view
        self.router = router
        getItems()
    }
    
    func getCategory() -> String{
        guard let categoryName = self.categoryName else { return "" }
        return categoryName
    }
    
    func filtersPicked() {
        print("I'm in")
        //view?.success()
        self.router?.showFilters()
    }
    
    func pop() {
        self.router?.popToRoot()
    }
    
    func getItems() {
        networkService.getItems(category: categoryName ?? "") { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self.items = items
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error )
                }
            }
        }
    }
    
}
