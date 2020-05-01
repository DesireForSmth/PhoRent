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
    init (view: CategoryViewProtocol, router: RouterProtocol, categoryName: String)
    func getCategory() -> String
}

class CategoryPresenter: CategoryViewPresenterProtocol {
    
    let view: CategoryViewProtocol?
    var router: RouterProtocol?
    var categoryName: String?
    
    required init(view: CategoryViewProtocol, router: RouterProtocol, categoryName: String) {
        self.view = view
        self.router = router
        self.categoryName = categoryName
    }
    
    func getCategory() -> String{
        return categoryName!
    }
    
}
