//
//  SignUpPresenter.swift
//  appPhoRent
//
//  Created by Александр Сетров on 05.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

protocol SignUpViewProtocol: class {
    func success()
    func failure(error: Error)
    func showNoInternetConnection()
    func showAlertLoading()
    func closeAlertLoading()
}

class SignUpView: SignUpViewProtocol {
    func success() {
    }
    
    func failure(error: Error) {
    }
    
    func showNoInternetConnection() {
    }
    
    func showAlertLoading() {
    }
    
    func closeAlertLoading() {
    }
}

protocol SignUpViewPreseneterProtocol: class {
    init (view: SignUpViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol)
    func signUp(username: String, email: String, password: String)
    func pop()
}

class SignUpPresenter: SignUpViewPreseneterProtocol {
    
    let view: SignUpViewProtocol?
    var router: RouterProtocol?
    let networkService: NetWorkServiceProtocol!
    
    required init(view: SignUpViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
    }
    
    func signUp(username: String, email: String, password: String) {
        if networkService.isConnectedToNetwork() {
            view?.showAlertLoading()
            networkService.signUp(username: username, email: email, password: password) { [weak self] result in
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
    
    func pop() {
        router?.popToRoot()
    }
}
