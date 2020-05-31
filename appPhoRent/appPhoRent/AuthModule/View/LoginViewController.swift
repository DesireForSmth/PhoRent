//
//  LoginViewController.swift
//  appPhoRent
//
//  Created by Александр Сетров on 01.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var presenter: LoginViewPreseneterProtocol!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var email: String = ""
    var password: String = ""
    
    @IBAction func nextAction(_ sender: Any) {
        presenter.pop()
    }
    
    @IBAction func passwordDropAction(_ sender: Any) {
        presenter.openPasswordDrop()
    }
    
    override func viewDidLoad() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        emailTextField.keyboardType = .emailAddress
        // Do any additional setup after loading the view.
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func signIn() {
        email = emailTextField.text!
        password = passwordTextField.text!
        
        print(email)
        print(password)
        
        if !email.isEmpty && !password.isEmpty {
            self.signInUser(email: email, password: password)
        } else {
            showAlert()
        }
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        self.signIn()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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

extension LoginViewController {
    func showAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func showAuthError() {
        let alert = UIAlertController(title: "Ошибка", message: "Неверный email или пароль", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Попробовать ещё раз", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func signInUser(email: String, password: String) {
        presenter.signIn(email: email, password: password)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == emailTextField) {
            let nextField = passwordTextField!
            nextField.becomeFirstResponder()
        } else {
            self.signIn()
        }
        return true
    }
    
}

extension LoginViewController: LoginViewProtocol {
    
    func success() {
        //presenter.pop()
    }
    
    func failure(error: Error) {
        closeAlertLoading()
        showAuthError()
    }
    
    func showNoInternetConnection() {
        let alert = UIAlertController(title: "Ошибка", message: "Нет соединения с Интернетом", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Попробовать позже", style: .default, handler: {action in self.navigationController?.popViewController(animated: true)}))
        present(alert, animated: true, completion: nil)
    }
}
