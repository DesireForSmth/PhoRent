//
//  MainSearchPresenter.swift
//  appPhoRent
//
//  Created by Ilya Buzyrev on 21.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol MainSearchViewProtocol: class {
    func success()
    func failure(error: Error)
    //func dismissTable()
}

protocol MainSearchPresenterProtocol: class {
    init(view: MainSearchViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol)
    func getCategories()
    var categories: [Category]? {get}
    func cellPicked(category: Category)
    
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
    
    func cellPicked(category: Category) {
        self.router?.showCategoryPage(category: category)
    }
    
    
}
       

