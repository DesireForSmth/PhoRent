//
//  SignUpViewController.swift
//  appPhoRent
//
//  Created by Александр Сетров on 01.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    var presenter: SignUpViewPreseneterProtocol!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var username: String = ""
    var email: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        errorLabel.alpha = 0
    }
    
    
    
    @IBAction func signUpAction(_ sender: UIButton) {
        
        username = usernameTextField.text!
        email = emailTextField.text!
        password = passwordTextField.text!
        
        print(username)
        print(email)
        print(password)
        if(!username.isEmpty && !email.isEmpty && !password.isEmpty){
            self.signUpUser(username: username, email: email, password: password)
        }else{
            showAlert()
        }
    }


}

extension SignUpViewController{
    func showAlert(){
        let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func showAuthError(){
        let alert = UIAlertController(title: "Ошибка", message: "Щит хэппенс", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Попробовать ещё раз", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func signUpUser(username: String, email: String, password: String) {
        self.presenter.signUp(username: username, email: email, password: password)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == usernameTextField){
            let nextField = emailTextField!
            nextField.becomeFirstResponder()
        }else{
            if (textField == emailTextField){
            let nextField = passwordTextField!
            nextField.becomeFirstResponder()
            }
        }
        
        username = usernameTextField.text!
        email = emailTextField.text!
        password = passwordTextField.text!
        
        print(username)
        print(email)
        print(password)
        
        return true
    }
    
}

extension SignUpViewController: SignUpViewProtocol {
    func failure(error: Error) {
        showAuthError()
    }
    
    func success() {
        //presenter.pop()
    }
    
    
}
