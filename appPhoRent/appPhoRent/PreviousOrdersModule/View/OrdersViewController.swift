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
    
    var emptyLabel: UILabel!
    
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
        
        tableView.estimatedSectionHeaderHeight = 66
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: customIdentifier, bundle: nil), forCellReuseIdentifier: customIdentifier)
        tableView.allowsSelection = false
        
        emptyLabel = UILabel()
        emptyLabel.text = "У вас нет оформленных заказов"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = CustomColors.textLabel
        emptyLabel.backgroundColor = CustomColors.background
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
    }
    
    
    private func createConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            emptyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            emptyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let number = presenter.getCountOfSection()
        if number == 0 {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: customIdentifier, for: indexPath)
        
        if let customTableViewCell = tableViewCell as? OrdersTableViewCell {
            let (name, cost, count, imageURL) = presenter.getItem(at: indexPath)
            customTableViewCell.fillCell(name: name, cost: cost, count: count, imageURL: imageURL)
            return customTableViewCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getCountOfRow(at: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = CustomColors.background
        label.text = presenter.getSectionTitle(section: section)
        
        headerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: headerView.topAnchor),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
        ])
        return headerView
    }
}

extension OrdersViewController: OrdersViewProtocol {
    func updateTable() {
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
        let showError =  { [weak self] in
            guard let self = self else { return }
            self.showAlert(message: "Нет соединения с интернетом")
        }
        closeAlert(completion: showError)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    
    func closeAlert(completion: (() -> ())? ) {
        dismiss(animated: true) {
            if let completion = completion {
                completion()
            }
        }
    }
    
    func closeAlert() {
        dismiss(animated: true, completion: nil)
    }
}
