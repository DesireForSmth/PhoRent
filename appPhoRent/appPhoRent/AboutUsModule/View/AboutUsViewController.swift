//
//  AboutUsViewController.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    var presenter: AboutUsViewPresenterProtocol!
    
    var firstLabel: UILabel!
    var secondLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        createConstraints()
    }
}

// MARK: - Create UI

extension AboutUsViewController {
    private func setupUI() {
        
        firstLabel = UILabel()
        firstLabel.text = "PhoRent"
        firstLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        firstLabel.textAlignment = .center
        
        secondLabel = UILabel()
        secondLabel.text = "Какая-то информация"
        secondLabel.font = UIFont.systemFont(ofSize: 20)
        secondLabel.numberOfLines = 0
        secondLabel.textAlignment = .center
        
        view.addSubview(firstLabel)
        view.addSubview(secondLabel)
        
    }
    
    private func createConstraints() {
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
            secondLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constraints.bottom)
        ])
    }
}

extension AboutUsViewController: AboutUsViewProtocol {
    
}
