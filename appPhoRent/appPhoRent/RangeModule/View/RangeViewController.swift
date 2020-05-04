//
//  RangeViewController.swift
//  appPhoRent
//
//  Created by Ilya Buzyrev on 19.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class RangeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var presenter: RangePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getCategory()
        tableView.register(UINib(nibName: "RangeTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        navBar.topItem?.title
}
    @IBAction func tapBackButton(_ sender: Any) {
        presenter.tapBack()
    }
}

extension RangeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RangeTableViewCell
    }
    
    
}

extension RangeViewController: RangeViewProtocol{
    func success() {
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    
}
