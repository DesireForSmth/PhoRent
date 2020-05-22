//
//  AboutUsPresenter.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

protocol AboutUsViewProtocol: class {
    
}


protocol AboutUsPresenterProtocol: class {
    init(view: AboutUsViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol)
    
    func logOut()
    func changeSchemeColor()
    func showOrders()
}


class AboutUsPresenter: AboutUsPresenterProtocol {
    
    weak var view: AboutUsViewProtocol?
    var router: RouterProtocol?
    let networkService: NetWorkServiceProtocol!
    
    required init(view: AboutUsViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
    }
    
    func logOut() {
        
        networkService.signOut { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Error: ")
                    print(error.localizedDescription)
                case .success(let message):
                    print(message)
                    UserManager.shared.currentUser = nil
                    self.router?.logOut()
                }
            }
        }
    }
    
    func changeSchemeColor() {
        router?.changeSchemeColor()
    }
    
    func showOrders() {
        router?.showOrders()
    }
}
