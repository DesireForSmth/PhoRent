//
//  ItemCellViewController.swift
//  appPhoRent
//
//  Created by Александр Сетров on 03.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class ItemCellViewController: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemCost: UILabel!
    @IBOutlet weak var addItemInBasket: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var stepperCount: UIStepper!
    
    var button: UIButton!
    var buttonAction: ((Any) -> Void)?
    
    @IBAction func addInBasket(_ sender: Any) {
        self.buttonAction?(sender)
    }
    
    @IBAction func countStepper(_ sender: UIStepper) {
        countLabel.text = String(Int(sender.value))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = CustomColors.backgroundCell
        [itemName,
        itemCost,
        countLabel].forEach {
            $0?.textColor = .black
        }
        
        stepperCount.backgroundColor = CustomColors.backgroundButton
        stepperCount.layer.cornerRadius = 8
        
        addItemInBasket.backgroundColor = CustomColors.backgroundButton
        addItemInBasket.setTitleColor(CustomColors.textButton, for: .normal)
        addItemInBasket.layer.cornerRadius = 13
        
        self.setUp()
    }
}

extension ItemCellViewController {
    
    // MARK: constraints setup
    
    func setUp(){
        self.addItemInBasket.translatesAutoresizingMaskIntoConstraints = false
        self.addItemInBasket.centerYAnchor.constraint(equalTo: self.stepperCount.centerYAnchor).isActive = true
        self.addItemInBasket.rightAnchor.constraint(equalTo: self.itemName.rightAnchor, constant: 0).isActive = true
        self.addItemInBasket.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        self.itemCost.translatesAutoresizingMaskIntoConstraints = false
        self.itemCost.rightAnchor.constraint(equalTo: self.itemName.rightAnchor, constant: 0).isActive = true
        self.itemCost.centerYAnchor.constraint(equalTo: self.countLabel.centerYAnchor, constant: 0).isActive = true
        
        self.stepperCount.translatesAutoresizingMaskIntoConstraints = false
        self.stepperCount.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        self.stepperCount.leftAnchor.constraint(equalTo: self.itemImage.rightAnchor, constant: 10).isActive = true
        
        self.countLabel.font = UIFont.systemFont(ofSize: 12)
        self.countLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
