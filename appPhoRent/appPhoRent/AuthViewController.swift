//
//  AuthViewController.swift
//  appPhoRent
//
//  Created by Александр Сетров on 25.03.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {

    var signUp = true{
        willSet{
            if newValue{
                titleLabel.text = "Регистрация"
                nameField.isHidden = false
                enterButton.setTitle("Войти", for: .normal)
                questionLabel.isHidden = false
            }
            else{
                titleLabel.text = "Вход"
                nameField.isHidden = true
                enterButton.setTitle("Регистрация", for: .normal)
                questionLabel.isHidden = true
            }
        }
    }
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("hello from AuthViewController")
    }
    
    @IBAction func switchLogin(_ sender: UIButton) {
        signUp = !signUp
    }
    

    func showAlert(){
        let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension AuthViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        if (textField == nameField){
            let nextField = emailField!
            nextField.becomeFirstResponder()
        }else{
            if (textField == emailField){
            let nextField = passwordField!
            nextField.becomeFirstResponder()
            }
        }
        
        let name = nameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        if (textField == passwordField){
            if (signUp){
                if(!name.isEmpty && !email.isEmpty && !password.isEmpty){
                    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                        if error == nil{
                            if let result = result{
                                print(result.user.uid)
                                let ref = Database.database().reference().child("users")
                                ref.child(result.user.uid).updateChildValues(["name" : name, "email": email])
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }else{
                    showAlert()
                }
            }else{
                if(!email.isEmpty && !password.isEmpty){
                    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                        if error == nil{
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }else{
                    showAlert()
                }
            }
        }
        return true
    }
}
