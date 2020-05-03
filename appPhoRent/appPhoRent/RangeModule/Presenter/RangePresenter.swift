//
//  RangePresenter.swift
//  appPhoRent
//
//  Created by Ilya Buzyrev on 19.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

protocol RangeViewProtocol: class {
    func success()
    func failure(error: Error)
}

protocol RangePresenterProtocol: class {
    init(view: RangeViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol, category: Category)
    func getCategory()
    func tapBack()
    var items: [Item]? {get set}
}

class RangePresenter: RangePresenterProtocol {
    
    var items: [Item]?
    var category: Category?
    weak var view: RangeViewProtocol?
    var router: RouterProtocol?
    let networkService: NetWorkServiceProtocol!
    
 
    required init(view: RangeViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol, category: Category) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.category = category
    }
    
    public func getCategory() {
        guard let categoryID = category?.ID else {
            assertionFailure("Проблема с доступом к категории")
            return
        }
        networkService.getCategory(categoryID: categoryID) { [weak self] result in
        guard let self = self else { return }
        DispatchQueue.main.async {
            switch result {
            case .success(let items):
                self.items = items
            case .failure(let error):
                self.view?.failure(error: error)
            }
    }
}
}
    func tapBack() {
        router?.popToRoot()
    }
    
}
