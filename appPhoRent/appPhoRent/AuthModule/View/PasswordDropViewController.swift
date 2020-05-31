//
//  PasswordDropViewController.swift
//  appPhoRent
//
//  Created by Александр Сетров on 28.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class PasswordDropViewController: UIViewController {

    var presenter: PasswordDropViewPresenterProtocol!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func exitAction(_ sender: Any) {
        presenter.pop()
    }
    
    @IBAction func passwordDropAction(_ sender: Any) {
        dropPassword()
    }
    
    func dropPassword() {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespaces)
        if (isValidEmail(email ?? "")) {
            presenter.passwordDrop(email: email)
        } else {
            showWrongFormat()
        }
    }
}

extension PasswordDropViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dropPassword()
        return true
    }
}

extension PasswordDropViewController: PasswordDropViewProtocol {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func showAuthError(){
        let alert = UIAlertController(title: "Оповещение", message: "На вашу почту отправлены инструкции по сбросу пароля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отлично!", style: .default, handler: {
            action in
            self.presenter.pop()
        }
        ))
        present(alert, animated: true, completion: nil)
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
    
    func showErrorAlert() {
        print("works")
        
        let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Попробовать снова", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showWrongFormat() {
        //closeAlertLoading()
        let alert = UIAlertController(title: nil, message: "Неверный формат почты", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func success() {
        closeAlertLoading()
        showAuthError()
    }
    
    func failure(error: Error) {
        closeAlertLoading()
        showErrorAlert()
    }
    
    func showNoInternetConnection() {
        let alert = UIAlertController(title: "Ошибка", message: "Нет соединения с Интернетом", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Попробовать позже", style: .default, handler: {action in self.navigationController?.popViewController(animated: true)}))
        present(alert, animated: true, completion: nil)
    }
    
}
