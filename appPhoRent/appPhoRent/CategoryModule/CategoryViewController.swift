//
//  CategoryViewController.swift
//  appPhoRent
//
//  Created by Александр Сетров on 30.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    var presenter: CategoryViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hallo")
        print(presenter.getCategory())
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CategoryViewController: CategoryViewProtocol {
    func success() {
        
    }
    
    func failure(error: Error) {
        
    }
    
    
}
