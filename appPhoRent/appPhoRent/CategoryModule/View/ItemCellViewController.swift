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
        self.setUp()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension ItemCellViewController {
    func setUp(){
        self.addItemInBasket.translatesAutoresizingMaskIntoConstraints = false
        self.addItemInBasket.topAnchor.constraint(equalTo: self.stepperCount.topAnchor, constant: 0).isActive = true
        self.addItemInBasket.rightAnchor.constraint(equalTo: self.itemName.rightAnchor, constant: 0).isActive = true
    }
}
