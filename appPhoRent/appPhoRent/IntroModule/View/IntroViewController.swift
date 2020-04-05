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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.presenter.checkSignedIn()
        // Do any additional setup after loading the view.
    }


    @IBAction func signUpAction(_ sender: Any) {
        presenter.openSignUp()
    }
    
    @IBAction func signInAction(_ sender: Any) {
        presenter.openSignIn()
    }

}

extension IntroViewController: IntroViewProtocol {
    
    func success() {
        presenter.openContent()
    }
    
    func failure() {
        
    }
    
}
