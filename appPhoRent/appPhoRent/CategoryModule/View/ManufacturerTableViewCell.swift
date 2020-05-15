//
//  ManufacturerTableViewCell.swift
//  appPhoRent
//
//  Created by Александр Сетров on 14.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class ManufacturerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var manufacturerNameLabel: UILabel!
    
    @IBOutlet weak var checkbox: UIButton!
    
    weak var presenter: CategoryViewPresenterProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gest = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
        self.addGestureRecognizer(gest)
        self.backgroundColor = .clear
    }

    func reload(){
        self.setCheckbox()
    }
    
    @objc func tapped() {
        self.checkbox.imageView?.isHidden = !self.checkbox.imageView!.isHidden
        if self.checkbox.imageView!.isHidden {
            presenter?.reduseManufacturer(name: self.manufacturerNameLabel.text!)
        } else {
            presenter?.appendManufacturer(name: self.manufacturerNameLabel.text!)
        }
    }
    
    func setCheckbox() {
        if let presenter = self.presenter {
            checkbox.imageView?.isHidden = !presenter.containsManufacturer(name: self.manufacturerNameLabel.text!)
        } else {
            print("LoL")
            checkbox.imageView?.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
}
