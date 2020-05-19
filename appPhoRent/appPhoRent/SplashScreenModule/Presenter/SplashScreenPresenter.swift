//
//  SplashScreenPresenter.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 14.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation
import Firebase


protocol SplashScreenViewProtocol: class {
    func success()
    func failure()
}

protocol SplashScreenPresenterProtocol: class {
    init (view: SplashScreenViewProtocol, router: RouterProtocol)
    func checkSignedIn()
    func openContent()
    func openIntro()
}

class SplashScreenPresenter: SplashScreenPresenterProtocol {
    var router: RouterProtocol?
    var view: SplashScreenViewProtocol
    
    required init(view: SplashScreenViewProtocol, router: RouterProtocol) {
        self.router = router
        self.view = view
    }

    func checkSignedIn() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                self.view.failure()
            } else {
                self.view.success()
            }
        }
    }
    func openContent() {
        router?.showContent()
    }
    
    func openIntro() {
        router?.showIntro()
    }
}
