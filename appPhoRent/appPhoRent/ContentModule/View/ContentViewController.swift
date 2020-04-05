//
//  ContentViewController.swift
//  appPhoRent
//
//  Created by Александр Сетров on 05.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    var presenter: ContentViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    @IBAction func logOutAction(_ sender: UIButton) {
        presenter.logOut()
    }
    

}

extension ContentViewController: ContentViewProtocol {
    
}
