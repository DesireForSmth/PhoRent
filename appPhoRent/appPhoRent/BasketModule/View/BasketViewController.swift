//
//  BasketViewController.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 10.05.2020.
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
        navigationController?.navigationBar.topItem?.title = "Корзина"
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

extension BasketViewController: BasketTableViewCellDelegate {
    func updateCount(sender: UIStepper) {
        if let indexPath = tableView?.indexPath(for: ((sender.superview?.superview) as! BasketTableViewCell)) {
            let newCount = Int(sender.value)
            let (title, _, _) = presenter.getItem(at: indexPath.row)
            presenter.updateCount(newCount: newCount, item: title)
        }
    }
}

extension BasketViewController {
    private func setupUI() {
        view.backgroundColor = CustomColors.background
        
        tableView = UITableView()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: customIdentifier, bundle: nil), forCellReuseIdentifier: customIdentifier)
        tableView.allowsSelection = false
        
        totalLabel = UILabel()
        totalLabel.text = "    Итого: "
        totalLabel.backgroundColor = .white
        totalLabel.textColor = CustomColors.textLabel
        totalLabel.backgroundColor = CustomColors.backgroundButton
              
        
        orderButton = UIButton(type: .system)
        orderButton.setTitle("К оформлению", for: .normal)
        orderButton.setTitleColor(CustomColors.textLabel, for: .normal)
        orderButton.backgroundColor = CustomColors.backgroundButton
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
    
    func success(totalCost: Float, date: Date) {
        totalLabel.text = "Итого: " + String(totalCost)
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

extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: customIdentifier, for: indexPath)
        
        if let customTableViewCell = tableViewCell as? BasketTableViewCell {
            customTableViewCell.delegate = self
            let (title, price, count) = presenter.getItem(at: indexPath.row)
            customTableViewCell.fillCell(title: title, price: price, count: count)
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
