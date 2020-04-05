//
//  IntroPresenter.swift
//  appPhoRent
//
//  Created by Александр Сетров on 01.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation
import Firebase

protocol IntroViewProtocol: class {
    func success()
    func failure()
}

protocol IntroViewPresenterProtocol: class {
    init (view: IntroViewProtocol, router: RouterProtocol)
    func checkSignedIn()
    func openSignUp()
    func openSignIn()
    func openContent()
}

class IntroPresenter: IntroViewPresenterProtocol {
    
    
    
    weak var view: IntroViewProtocol?
    var router: RouterProtocol?
    
    required init(view: IntroViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func checkSignedIn() {
            Auth.auth().addStateDidChangeListener { (auth, user) in
                if user == nil{
                    self.view?.failure()
                }else{
                    self.view?.success()
             }
        }
    }
    
    func openContent() {
        router?.showContent()
    }

    func openSignUp() {
        router?.showSignUp()
    }
    
    func openSignIn() {
        router?.showLogin()
    }
    
}
