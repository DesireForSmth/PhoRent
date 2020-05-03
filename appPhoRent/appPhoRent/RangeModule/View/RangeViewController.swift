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
}
    @IBAction func tapBackButton(_ sender: Any) {
        presenter.tapBack()
    }
    
}

extension RangeViewController: RangeViewProtocol{
    func success() {
        <#code#>
    }
    
    func failure(error: Error) {
        <#code#>
    }
    
    
}
