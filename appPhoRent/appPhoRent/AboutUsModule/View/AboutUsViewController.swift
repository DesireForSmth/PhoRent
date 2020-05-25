//
//  AboutUsViewController.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    var presenter: AboutUsPresenterProtocol!
    
    var firstLabel: UILabel!
    var secondLabel: UILabel!
    var schemeColorButton: UIButton!
    var logOutButton: UIButton!
    
    var showOrdersButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createConstraints()
    }
}

// MARK: - Button Actions
extension AboutUsViewController {
    
    @objc func showOrderAction(_ sender: UIButton) {
        presenter.showOrders()
    }
    
    @objc func logOutAction(_ sender: UIButton) {
        presenter.logOut()
    }
    
    @objc func schemeColorAction(_ sender: UIButton) {
        presenter.changeSchemeColor()
    }
}

// MARK: - Create UI

extension AboutUsViewController {
    private func setupUI() {
        
        let title = UILabel()
        title.text = "Настройки"
        title.font = .systemFont(ofSize: 17, weight: .medium)
        
        navigationItem.titleView = title
        
        
        view.backgroundColor = CustomColors.background
        
        firstLabel = UILabel()
        firstLabel.text = "PhoRent"
        firstLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        firstLabel.textAlignment = .center
        firstLabel.textColor = CustomColors.textLabelSecond
        
        secondLabel = UILabel()
        secondLabel.text = "- приложение для аренды фототехники"
        secondLabel.font = UIFont.systemFont(ofSize: 20)
        secondLabel.numberOfLines = 0
        secondLabel.textAlignment = .center
        secondLabel.textColor = CustomColors.textLabel
        
        showOrdersButton = UIButton(type: .system)
        showOrdersButton.setTitle("Предыдущие заказы", for: .normal)
        showOrdersButton.setTitleColor(CustomColors.textButton, for: .normal)
        showOrdersButton.backgroundColor = CustomColors.backgroundButton
//        showOrdersButton.layer.borderColor = UIColor.systemGray.cgColor
//        showOrdersButton.layer.borderWidth = 0.5
        
        showOrdersButton.addTarget(self, action: #selector(showOrderAction), for: .touchUpInside)
        
        schemeColorButton = UIButton(type: .system)
        schemeColorButton.setTitle("Сменить тему", for: .normal)
        schemeColorButton.setTitleColor(CustomColors.textButton, for: .normal)
        schemeColorButton.backgroundColor = CustomColors.backgroundButton
//        schemeColorButton.layer.borderColor = UIColor.systemGray.cgColor
//        schemeColorButton.layer.borderWidth = 0.5
        
        schemeColorButton.addTarget(self, action: #selector(schemeColorAction), for: .touchUpInside)
        
        logOutButton = UIButton(type: .system)
        logOutButton.setTitle("Выйти из аккаунта", for: .normal)
        logOutButton.setTitleColor(.systemRed, for: .normal)
        logOutButton.backgroundColor = CustomColors.backgroundButton
//        logOutButton.layer.borderColor = UIColor.systemGray.cgColor
//        logOutButton.layer.borderWidth = 0.5
        
        logOutButton.addTarget(self, action: #selector(logOutAction), for: .touchUpInside)
        
        view.addSubview(firstLabel)
        view.addSubview(secondLabel)
        view.addSubview(schemeColorButton)
        view.addSubview(logOutButton)
        view.addSubview(showOrdersButton)
    }
    
    private func createConstraints() {
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        schemeColorButton.translatesAutoresizingMaskIntoConstraints = false
        showOrdersButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constraints.top),
            firstLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            firstLabel.widthAnchor.constraint(equalToConstant: 200),
            firstLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: Constraints.top),
            secondLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constraints.leading),
            secondLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constraints.trailing),
            secondLabel.bottomAnchor.constraint(equalTo: showOrdersButton.topAnchor, constant: Constraints.bottom)
        ])
        
        NSLayoutConstraint.activate([
            showOrdersButton.bottomAnchor.constraint(equalTo: schemeColorButton.topAnchor, constant: Constraints.bottom),
            showOrdersButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            showOrdersButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            showOrdersButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            schemeColorButton.bottomAnchor.constraint(equalTo: logOutButton.topAnchor, constant: Constraints.bottom),
            schemeColorButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            schemeColorButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            schemeColorButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            logOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constraints.bottom),
            logOutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            logOutButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension AboutUsViewController: AboutUsViewProtocol {
    
}
