//
//  BasketTableViewCell.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 24.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class BasketTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var stepperOutlet: UIStepper!
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        countLabel.text = "Количество: " + Int(sender.value).description
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fillCell(title: String, price: String, count: Int) {
        titleLabel.text = title
        priceLabel.text = price
        itemImageView.image = UIImage(systemName: "house")
        stepperOutlet.value = Double(count)
        countLabel.text = "Количество: \(count)"
    }
    
}
