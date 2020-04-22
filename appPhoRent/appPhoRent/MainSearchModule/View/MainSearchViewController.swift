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
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MainSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        navBar.topItem?.title = "Search"
    }
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
}

extension MainSearchViewController: MainSearchViewProtocol{
    func success() {
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}
