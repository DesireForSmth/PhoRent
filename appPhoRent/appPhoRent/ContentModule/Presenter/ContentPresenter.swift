//
//  ContentPresenter.swift
//  appPhoRent
//
//  Created by Александр Сетров on 05.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation
import Firebase

protocol ContentViewProtocol: class {
    
}

protocol ContentViewPresenterProtocol: class {
    init (view: ContentViewProtocol, router: RouterProtocol)
    func logOut()
}

class ContentPresenter: ContentViewPresenterProtocol {
    
    weak var view: ContentViewProtocol?
    var router: RouterProtocol?
    
    required init(view: ContentViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func logOut() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        router?.popToRoot()
    }
    
}
