//
//  IntroViewController.swift
//  appPhoRent
//
//  Created by Александр Сетров on 05.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    var presenter: IntroViewPresenterProtocol!
    
    @IBOutlet weak var mainLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    
//        self.presenter.checkSignedIn()
    }


    @IBAction func signUpAction(_ sender: Any) {
        presenter.openSignUp()
    }
    
    @IBAction func signInAction(_ sender: Any) {
        presenter.openSignIn()
    }

}

extension IntroViewController: IntroViewProtocol {
//    
//    func success() {
//        presenter.openContent()
//    }
//    
//    func failure() {
//        
//    }
    
}
