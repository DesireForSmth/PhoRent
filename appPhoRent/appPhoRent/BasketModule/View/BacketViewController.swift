//
//  BacketViewController.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 22.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class BasketViewController: UIViewController {
    var presenter: BasketPresenterProtocol!
    
    var customIdentifier = "BasketTableViewCell"
    
    var indicatorView: UIActivityIndicatorView!
    
    var tableView: UITableView!
    var totalLabel: UILabel!
    var orderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        createConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.prepareData()
    }
    
    
    @objc func orderAction(_ sender: Any) {
        
    }
}

extension BasketViewController {
    private func setupUI() {
        
        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: customIdentifier, bundle: nil), forCellReuseIdentifier: customIdentifier)
        
        totalLabel = UILabel()
        totalLabel.text = "    Итого: "
        totalLabel.backgroundColor = .white
        
        orderButton = UIButton(type: .system)
        orderButton.setTitle("К оформлению", for: .normal)
        orderButton.setTitleColor(.black, for: .normal)
        orderButton.backgroundColor = .white
        orderButton.addTarget(self, action: #selector(orderAction), for: .touchUpInside)
        
        indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.hidesWhenStopped = true
        
        [tableView,
         totalLabel,
         orderButton,
         indicatorView].forEach { view.addSubview($0) }
    }
    
    private func createConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        orderButton.translatesAutoresizingMaskIntoConstraints = false
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalLabel.topAnchor, constant: -16),
            
            orderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            orderButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            orderButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            orderButton.heightAnchor.constraint(equalToConstant: 50),
            
            totalLabel.bottomAnchor.constraint(equalTo: orderButton.topAnchor, constant: -16),
            totalLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            totalLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}

extension BasketViewController: BasketViewProtocol {
    
    func showIndicator() {
        indicatorView.startAnimating()
    }
    
    func hideIndicator() {
        indicatorView.stopAnimating()
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func setTotalCost(total: Float) {
        totalLabel.text = "Итого: " + String(total)
    }
}

extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: customIdentifier, for: indexPath)
        if let customTableViewCell = tableViewCell as? BasketTableViewCell {
            let (title, price, count) = presenter.getItem(at: indexPath.row)
            customTableViewCell.fillCell(title: title, price: price, count: count)
            customTableViewCell.stepperOutlet.tag = indexPath.row
        }
        return tableViewCell
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfRow()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
}
