//
//  MainSearchViewController.swift
//  appPhoRent
//
//  Created by Ilya Buzyrev on 21.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit
import Kingfisher

class MainSearchViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var presenter: MainSearchPresenterProtocol!
    var categories: [Category]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if presenter.needDownload(){
            showAlert()
        }
        //self.navBar.translatesAutoresizingMaskIntoConstraints = false
        let backButton = UIButton()
        
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButton
        self.view.backgroundColor = CustomColors.background
        self.navigationController?.navigationBar.topItem?.title = "Поиск"
        view.backgroundColor = CustomColors.background
        tableView.backgroundColor = CustomColors.background
        navigationItem.backBarButtonItem?.title = ""
        presenter.getCategories()
        tableView.register(UINib(nibName: "MainSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 100
        
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
}

extension MainSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainSearchTableViewCell
        let categoryName = categories?[indexPath.item].name
        let categoryImage = categories?[indexPath.item].imageName
        cell.categoryName.text = categoryName
        let url = URL(string: categoryImage!)
        let resource = ImageResource(downloadURL: url!, cacheKey: categoryImage)
        cell.categoryImage.kf.setImage(with: resource)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let category = presenter.categories?[indexPath.row] else {
            assertionFailure("Категория не найдена!")
            return
        }
        self.presenter.cellPicked(category: category)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}

extension MainSearchViewController: MainSearchViewProtocol{
    
    func success() {
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    func setCategories(categories: [Category]?) {
        self.categories = categories
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
