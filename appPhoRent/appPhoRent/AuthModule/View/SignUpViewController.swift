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
    
    @IBAction func exitAction(_ sender: Any) {
        presenter.pop()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        emailTextField.keyboardType = .emailAddress
        errorLabel.alpha = 0
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func signUp() {
        username = usernameTextField.text!
        email = emailTextField.text!
        password = passwordTextField.text!
        guard validation(email: email, password: password) else {
            print(isValidEmail(email))
            print(isValidPassword(password))
            print(email)
            print(password)
            self.validationError()
            return
        }
        if(!username.isEmpty && !email.isEmpty && !password.isEmpty){
            self.signUpUser(username: username, email: email, password: password)
        }else{
            showAlert()
        }
    }
    
    func validationError() {
        let alert = UIAlertController(title: "Ошибка", message: "неверный формат email или пароля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Попробовать еще раз", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool{
        print(password)
        let passwRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[_d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&_#]{8,}"
        let passwPred = NSPredicate(format: "SELF MATCHES %@", passwRegEx)
        return passwPred.evaluate(with: password)
    }
    
    func validation(email: String, password: String) -> Bool{
        return isValidEmail(email) && isValidPassword(password)
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        self.signUp()
    }
    
    
    func showAlertLoading() {
        let alert = UIAlertController(title: nil, message: "Загрузка...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        present(alert, animated: true, completion: nil)
    }

    func closeAlertLoading() {
        dismiss(animated: true, completion: nil)
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
            } else {
                self.signUp()
            }
        }
        return true
    }
    
}

extension SignUpViewController: SignUpViewProtocol {
    func failure(error: Error) {
        closeAlertLoading()
        showAuthError()
    }
    
    func success() {
        //presenter.pop()
    }
    
    func showNoInternetConnection() {
        let alert = UIAlertController(title: "Ошибка", message: "Нет соединения с Интернетом", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Попробовать позже", style: .default, handler: {action in self.navigationController?.popViewController(animated: true)}))
        present(alert, animated: true, completion: nil)
    }
    
}
