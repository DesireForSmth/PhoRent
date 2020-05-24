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
    }

    
    @IBAction func exitAction(_ sender: Any) {
        presenter.pop()
    }
    
    @IBAction func passwordDropAction(_ sender: Any) {
        presenter.passwordDrop(email: emailTextField.text)
    }
}

extension PasswordDropViewController: UITextFieldDelegate{
    
}

extension PasswordDropViewController: PasswordDropViewProtocol {
    
    func showAuthError(){
        let alert = UIAlertController(title: "Оповещение", message: "На вашу почту отправлены инструкции по сбросу пароля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отлично!", style: .default, handler: {
            action in
            self.presenter.pop()
        }
        ))
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Попробовать снова", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showWrongFormat() {
        let alert = UIAlertController(title: nil, message: "Неверный формат почты", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func success() {
        showAuthError()
    }
    
    func failure(error: Error) {
        showErrorAlert()
    }
    
}
