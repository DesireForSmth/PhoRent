//
//  SignUpPresenter.swift
//  appPhoRent
//
//  Created by Александр Сетров on 05.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation
import Firebase

protocol SignUpViewProtocol: class {
    func success()
    func failure(error: Error)
}

class SignUpView: SignUpViewProtocol {
    func success() {
    }
    
    func failure(error: Error) {
    }
    
}

protocol SignUpViewPreseneterProtocol: class {
    init (view: SignUpViewProtocol, router: RouterProtocol)
    func signUp(username: String, email: String, password: String)
    func pop()
}

class SignUpPresenter: SignUpViewPreseneterProtocol {
    
    let view: SignUpViewProtocol?
    var router: RouterProtocol?
    
    func signUp(username: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil{
                if let result = result{
                    print(result.user.uid)
                    let ref = Database.database().reference().child("users")
                    ref.child(result.user.uid).updateChildValues(["name" : username, "email": email])
                }
                self.view?.success()
            }
            else{
                self.view?.failure(error: error!)
            }
        }
    }
    
    required init(view: SignUpViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func pop() {
        router?.popToRoot()
    }
}
