//
//  AuthViewController.swift
//  appPhoRent
//
//  Created by Александр Сетров on 25.03.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("hello from AuthViewController")
    }
    
    @IBAction func switchLogin(_ sender: UIButton) {
    }
    


}
