//
//  BasketTableViewCell.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 10.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

protocol BasketTableViewCellDelegate {
    func updateCount(sender: UIStepper)
}

class BasketTableViewCell: UITableViewCell {
    
    var delegate: BasketTableViewCellDelegate?

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var stepperOutlet: UIStepper!
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        countLabel.text = "Количество: " + Int(sender.value).description
        delegate?.updateCount(sender: sender)
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
