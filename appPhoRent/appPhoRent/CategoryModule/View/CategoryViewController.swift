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
    
    var updated = false
    
    @IBOutlet weak var filtersButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!

    private var filtersAreAvialable = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        presenter.getItems()
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.register(UINib(nibName: "ItemCellViewController", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 80
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        self.navigationBar.topItem?.title = presenter.getCategoryName()
        self.navigationController?.isNavigationBarHidden = true
    }

    func showFiltersPopover() {
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
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        self.presenter.pop()
    }
    @IBAction func filtersTapped(_ sender: UIBarButtonItem) {
        self.showFiltersPopover()
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
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

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemCellViewController
        if let item = items?[indexPath.item] {
            let itemImage = item.imageURL
            cell.itemName.text = item.name
            cell.itemCost.text = "\(item.cost)"
            let url = URL(string: itemImage)
            let resource = ImageResource(downloadURL: url!, cacheKey: itemImage)
            cell.itemImage.kf.setImage(with: resource)
            cell.itemID = item.ID
            cell.buttonAction = { sender in
                self.presenter.addItemInBasket(itemID: item.ID)
            }
        }
        return cell
    }
}

extension CategoryViewController {
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Выполнено", message: "Вы добавили товар в заказ!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showFailureAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так! Попробуйте повторить заказ.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ну ошибка и ошибка", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension CategoryViewController: CategoryViewProtocol {
    func successAddingItem(message: String) {
        showSuccessAlert()
        print(message)
    }
    
    func failAddingItem(error: Error) {
        showFailureAlert()
        print(error.localizedDescription)
    }
    
    
    func success() {
        
        tableView.reloadData()
        //tableView.reloadSections(IndexSet(integersIn: 0...0), with: UITableView.RowAnimation.top)
        if self.items?.count != 0 {
            if !updated {
                presenter.getManufacturers()
                presenter.getCostRange()
                updated = !updated
            }
            self.filtersAreAvialable = true
        }
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
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
    
    func setItems(items: [Item]?) {
        self.items = items 
    }
}

extension CategoryViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
