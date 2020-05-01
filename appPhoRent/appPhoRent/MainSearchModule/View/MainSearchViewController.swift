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
    
    @IBOutlet weak var navBar: UINavigationBar!

    @IBOutlet weak var tableView: UITableView!
    
    var presenter: MainSearchPresenterProtocol!
    
    override func viewDidLoad() {
        print("loaded")
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MainSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 100
        navBar.topItem?.title = "Search"
    }
    /*
    @IBAction func filtersTapAction(_ sender: Any) {
        self.presenter.filtersTapped
    }
    */
}

extension MainSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainSearchTableViewCell
        
        let categoryName = presenter.categories?[indexPath.item].name
        let categoryImage = presenter.categories?[indexPath.item].imageName
        cell.categoryName.text = categoryName
        let url = URL(string: categoryImage!)
        let resource = ImageResource(downloadURL: url!, cacheKey: categoryImage)
        cell.categoryImage.kf.setImage(with: resource)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell: MainSearchTableViewCell = tableView.cellForRow(at: indexPath) as? MainSearchTableViewCell {
            if let categoryName = cell.categoryName.text {
                self.presenter.cellPicked(categoryName: categoryName)
            }
        }
    }
}

extension MainSearchViewController: MainSearchViewProtocol{
    func success() {
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    /*
    func dismissTable() {
        self.tableView.isHidden = true;
    }
    */
    
}
