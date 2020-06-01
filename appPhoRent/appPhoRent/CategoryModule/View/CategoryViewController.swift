//
//  CategoryViewController.swift
//  appPhoRent
//
//  Created by Александр Сетров on 30.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryViewController: UIViewController {
    
    var presenter: CategoryViewPresenterProtocol!
    var items: [Item]?
    
    private var alertLabel = UILabel()
    
    var updated = false
    
    var filtersButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var filtersAreAvialable = false
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertLabel.isHidden = true
        let title = UILabel()
        
        title.text = self.presenter.getCategoryName()
        title.font = .systemFont(ofSize: 17, weight: .medium)
        navigationItem.titleView = title
        
        self.presenter.getItems()
        
        let filterButton = UIButton(type: .custom)
        filterButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        filterButton.addTarget(self, action: #selector(showFiltersPopover), for: .touchUpInside)
        filtersButton = UIBarButtonItem(customView: filterButton)
        
        view.backgroundColor = CustomColors.background
        tableView.backgroundColor = CustomColors.background
        navigationItem.rightBarButtonItem = self.filtersButton
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        tableView.register(UINib(nibName: "ItemCellViewController", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 116
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.allowsSelection = false
    }

    // MARK: showFilterPopover
    
    
    @objc func showFiltersPopover() {
        if filtersAreAvialable {
            let popVC = FiltersViewController()
            popVC.modalPresentationStyle = .popover
            popVC.presenter = self.presenter
            
            let popOverVC = popVC.popoverPresentationController
            popOverVC?.delegate = self
            
            popOverVC?.barButtonItem = self.filtersButton
            popOverVC?.sourceRect = CGRect(x: 0, y: 0, width: 0, height: 0)
            
            popVC.preferredContentSize = CGSize(width: 300, height: 500)
            
            self.present(popVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func filtersTapped(_ sender: UIBarButtonItem) {
        self.showFiltersPopover()
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                
                self.presenter.pop()
            default:
                break
            }
        }
    }
    
}

// MARK: tableView extensions

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemCellViewController
        if let item = items?[indexPath.item] {
            let itemIndex = indexPath.item
            let itemImage = item.imageURL
            cell.itemName.text = item.name
            cell.itemCost.text = "\(item.cost) р./сут."
            let url = URL(string: itemImage)
            let resource = ImageResource(downloadURL: url!, cacheKey: itemImage)
            let image = UIImage(named: "delivery")
            cell.itemImage.kf.setImage(with: resource, placeholder: image)
            cell.stepperCount.value = 1
            cell.stepperCount.minimumValue = 1
            cell.stepperCount.maximumValue = Double(item.count)
            cell.countLabel.text = String(1)
            cell.buttonAction = { sender in
                self.presenter.addItemInBasket(itemID: item.ID, count: Int(cell.stepperCount.value), itemIndex: itemIndex)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CategoryViewController {
    
    func setNoItems() {
        self.view.addSubview(self.alertLabel)
        self.alertLabel.isHidden = false
        self.tableView.isHidden = true
        self.alertLabel.text = "Таких товаров нет"
        self.alertLabel.textAlignment = .center
        
        self.alertLabel.translatesAutoresizingMaskIntoConstraints = false
        self.alertLabel.topAnchor.constraint(equalToSystemSpacingBelow: self.view.topAnchor, multiplier: 10).isActive = true
        self.alertLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: self.view.centerXAnchor, multiplier: 0).isActive = true
    }
    
    func setNoInternetConnection() {
        self.view.addSubview(self.alertLabel)
        self.alertLabel.isHidden = false
        self.tableView.isHidden = true
        self.alertLabel.text = "Нет соединения с интернетом"
        self.alertLabel.textAlignment = .center
        
        self.alertLabel.translatesAutoresizingMaskIntoConstraints = false
        self.alertLabel.topAnchor.constraint(equalToSystemSpacingBelow: self.view.topAnchor, multiplier: 15).isActive = true
        self.alertLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: self.view.centerXAnchor, multiplier: 0).isActive = true
    }
}

// MARK: viewProtocol confirmation

extension CategoryViewController: CategoryViewProtocol {
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "Загрузка...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func closeAlert(completionMessage: String?) {
        if !(self.presentedViewController?.isBeingDismissed ?? true) {
            dismiss(animated: true) {
                if let competionMessage = completionMessage {
                    self.showAlert(message: competionMessage)
                }
            }
        }
    }
    
    
    
    func success() {
        tableView.reloadData()
        if self.items?.count != 0 {
            tableView.isHidden = false
            alertLabel.isHidden = true
            if !updated {
                presenter.getManufacturers()
                presenter.getCostRange()
                updated = !updated
            }
            self.filtersAreAvialable = true
        }
        else {
            setNoItems()
        }
    }
    
    func failure() {
        setNoInternetConnection()
        self.filtersAreAvialable = false
    }
    
    func setItems(items: [Item]?) {
        self.items = items 
    }
}

extension CategoryViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
