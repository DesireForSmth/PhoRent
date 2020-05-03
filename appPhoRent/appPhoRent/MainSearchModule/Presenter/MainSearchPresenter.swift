//
//  MainSearchPresenter.swift
//  appPhoRent
//
//  Created by Ilya Buzyrev on 21.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

protocol MainSearchViewProtocol: class {
    func success()
    func failure(error: Error)
}

protocol MainSearchPresenterProtocol: class {
    init(view: MainSearchViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol)
    func getCategories()
    func tapOnCategory(category: Category?)
    var categories: [Category]? {get}
<<<<<<< HEAD
=======
    func cellPicked(categoryName: String)
    
<<<<<<< HEAD
>>>>>>> f0b0d0299be63dfa6ef382d61b877c5378e180c1
=======
>>>>>>> f0b0d0299be63dfa6ef382d61b877c5378e180c1
}

class MainSearchPresenter: MainSearchPresenterProtocol {
    
    var categories: [Category]?
    weak var view: MainSearchViewProtocol?
    var router: RouterProtocol?
    let networkService: NetWorkServiceProtocol!
    
    required init(view: MainSearchViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        getCategories()
    }
    
    func getCategories() {
        networkService.getCategories { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self.categories = categories
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
<<<<<<< HEAD
    func tapOnCategory(category: Category?) {
        guard let category = category else {
            assertionFailure("Ошибка доступа к категории")
            return
        }
        router?.showCategory(category: category)
=======
    
    func cellPicked(categoryName: String) {
        self.router?.showCategoryPage(categoryName: categoryName)
        //self.view?.dismissTable()
    }
    
    
    /*
    func filtersTapped() {
        
>>>>>>> f0b0d0299be63dfa6ef382d61b877c5378e180c1
    }
}
       

