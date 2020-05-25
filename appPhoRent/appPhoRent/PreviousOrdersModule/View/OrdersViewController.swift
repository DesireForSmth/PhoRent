//
//  OrdersViewController.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 22.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController {
    
    var presenter: OrdersPresenterProtocol!
    
    var customIdentifier = "OrdersTableViewCell"
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.prepareData()
    }
    
    func setupUI() {
        let title = UILabel()
        title.text = "Предыдущие заказы"
        title.font = .systemFont(ofSize: 17, weight: .medium)
        
        navigationItem.titleView = title
        
        view.backgroundColor = CustomColors.background
        
        tableView = UITableView()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = CustomColors.background
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: customIdentifier, bundle: nil), forCellReuseIdentifier: customIdentifier)
        tableView.allowsSelection = false
        view.addSubview(tableView)
    }
    
    
    private func createConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.getCountOfSection()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.getSectionTitle(section: section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: customIdentifier, for: indexPath)
        
        if let customTableViewCell = tableViewCell as? OrdersTableViewCell {
            //            customTableViewCell.delegate = self
            let (name, cost, count, imageURL) = presenter.getItem(at: indexPath)
            customTableViewCell.fillCell(name: name, cost: cost, count: count, imageURL: imageURL)
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getCountOfRow(at: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}

extension OrdersViewController: OrdersViewProtocol {
    func updateTable() {
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "Загрузка...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        present(alert, animated: true, completion: nil)
    }
    
    func closeAlert() {
        dismiss(animated: true, completion: nil)
    }
}
