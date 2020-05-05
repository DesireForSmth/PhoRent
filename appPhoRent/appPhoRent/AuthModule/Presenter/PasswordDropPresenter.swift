//
//  PasswordDropPresenter.swift
//  appPhoRent
//
//  Created by Александр Сетров on 28.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

protocol PasswordDropViewProtocol: class {
    func success()
    func failure(error: Error)
}

class PasswordDropView: PasswordDropViewProtocol {
    func success() {
    }
    func failure(error: Error) {
    }
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
  
//    func passwordDrop(email: String?) {
//        if let email = email {
//            if !email.isEmpty {
//                Auth.auth().sendPasswordReset(withEmail: email) { error in
//                    if error != nil {
//                        self.view?.failure(error: error!)
//                    } else {
//                        self.view?.success()
//                    }
//                }
//            }
//        }
//    }
    
    func passwordDrop(email: String?) {
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
    }
    
    func pop() {
        router?.popToRoot()
    }
}

extension PasswordDropPresenter {
    
}
