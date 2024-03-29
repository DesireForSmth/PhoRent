//
//  LoginPresenter.swift
//  appPhoRent
//
//  Created by Александр Сетров on 05.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

protocol LoginViewProtocol: class {
    func success()
    func failure(error: Error)
    func showNoInternetConnection()
    func closeAlertLoading()
    func showAlertLoading()
}

class LoginView: LoginViewProtocol {
    func success() {
    }
    func failure(error: Error) {
    }
    func showNoInternetConnection(){
    }
    func closeAlertLoading() {
    }
    func showAlertLoading() {
    }
}

protocol LoginViewPreseneterProtocol: class {
    init (view: LoginViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol)
    func signIn(email: String, password: String)
    func pop()
    func openPasswordDrop()
}

class LoginPresenter: LoginViewPreseneterProtocol {
    
    let view: LoginViewProtocol?
    var router: RouterProtocol?
    let networkService: NetWorkServiceProtocol!
    
    required init(view: LoginViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
    }
    
    func signIn(email: String, password: String) {
        if networkService.isConnectedToNetwork() {
            view?.showAlertLoading()
            networkService.signIn(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
                switch result {
                case .success(let helloString):
                    self.view?.success()
                    print(helloString)
                case .failure(let error):
                    self.view?.failure(error: error)
                    }
            }
        } else {
            
            view?.showNoInternetConnection()
        }
    }
    
    func openPasswordDrop() {
        router?.showPasswordDrop()
    }
    func pop(){
        router?.popToRoot()
    }
}
