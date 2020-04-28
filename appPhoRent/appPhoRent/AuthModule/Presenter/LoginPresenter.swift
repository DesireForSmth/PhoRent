//
//  LoginPresenter.swift
//  appPhoRent
//
//  Created by Александр Сетров on 05.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation
import Firebase

protocol LoginViewProtocol: class {
    func success()
    func failure(error: Error)
}

class LoginView: LoginViewProtocol {
    
    func success() {
    }
    func failure(error: Error) {
    }
    
}

protocol LoginViewPreseneterProtocol: class {
    init (view: LoginViewProtocol, router: RouterProtocol)
    func signIn(email: String, password: String)
    func pop()
    func openPasswordDrop()
}

class LoginPresenter: LoginViewPreseneterProtocol {
    
    let view: LoginViewProtocol?
    var router: RouterProtocol?
    
    required init(view: LoginViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil{
                self.view?.success()
            }else{
                self.view?.failure(error: error!)
            }
        }
    }
    func openPasswordDrop() {
        router?.showPasswordDrop()
    }
    func pop(){
        router?.popToRoot()
    }
}
