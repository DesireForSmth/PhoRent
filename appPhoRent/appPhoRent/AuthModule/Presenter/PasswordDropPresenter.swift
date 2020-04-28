//
//  PasswordDropPresenter.swift
//  appPhoRent
//
//  Created by Александр Сетров on 28.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation
import FirebaseAuth

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
    init (view: PasswordDropViewProtocol, router: RouterProtocol)
    func pop()
    func passwordDrop(email: String?)
}

class PasswordDropPresenter: PasswordDropViewPresenterProtocol {
    
    let view: PasswordDropViewProtocol?
    var router: RouterProtocol?
    
    required init(view: PasswordDropViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
  
    func passwordDrop(email: String?) {
        if let email = email {
            if !email.isEmpty {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if error != nil {
                        self.view?.failure(error: error!)
                    } else {
                        self.view?.success()
                    }
                }
            }
        }
    }
    
    func pop() {
        router?.popToRoot()
    }
}

extension PasswordDropPresenter {
    
}
