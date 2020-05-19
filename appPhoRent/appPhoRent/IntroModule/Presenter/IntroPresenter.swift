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
//    func success()
//    func failure()
}

protocol IntroViewPresenterProtocol: class {
    init (view: IntroViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol)
//    func checkSignedIn()
    func openSignUp()
    func openSignIn()
//    func openContent()
}

class IntroPresenter: IntroViewPresenterProtocol {
    
    weak var view: IntroViewProtocol?
    var router: RouterProtocol?
    let networkService: NetWorkServiceProtocol!
    
    required init(view: IntroViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
    }
    
//    func checkSignedIn() {
//            Auth.auth().addStateDidChangeListener { (auth, user) in
//                if user == nil{
//                    self.view?.failure()
//                }else{
//                    self.view?.success()
//             }
//        }
//    }
    
//    func openContent() {
//        router?.showContent()
//    }

    func openSignUp() {
        router?.showSignUp()
    }
    
    func openSignIn() {
        router?.showLogin()
    }
    
}
