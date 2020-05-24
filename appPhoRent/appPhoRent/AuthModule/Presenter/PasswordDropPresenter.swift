//
//  PasswordDropPresenter.swift
//  appPhoRent
//
//  Created by Александр Сетров on 28.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

protocol PasswordDropViewProtocol: class {
    func showWrongFormat()
    func success()
    func failure(error: Error)
}

class PasswordDropView: PasswordDropViewProtocol {
    func success() {
    }
    func failure(error: Error) {
    }
    func showWrongFormat() {}
}

protocol PasswordDropViewPresenterProtocol: class {
    init (view: PasswordDropViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol)
    func pop()
    func passwordDrop(email: String?)
}

class PasswordDropPresenter: PasswordDropViewPresenterProtocol {
    
    let view: PasswordDropViewProtocol?
    var router: RouterProtocol?
    let networkService: NetWorkServiceProtocol!
    
    required init(view: PasswordDropViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
    }
    
    func passwordDrop(email: String?) {
        if isValidEmail(email ?? "") {
        networkService.passwordDrop(email: email) { [weak self] result in
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
            view?.showWrongFormat()
        }
    }
    
    func pop() {
        router?.popToRoot()
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

extension PasswordDropPresenter {
    
}
