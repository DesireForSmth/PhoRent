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
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }
}
