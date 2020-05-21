//
//  BasketTableViewCell.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 10.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit
import Kingfisher

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
    
    func fillCell(name: String, cost: String, count: Int, imageURL: String) {
        
//        let itemImage = item.imageURL
//        cell.itemName.text = item.name
//        cell.itemCost.text = "\(item.cost)"
//        let url = URL(string: itemImage)
//        let resource = ImageResource(downloadURL: url!, cacheKey: itemImage)
//        cell.itemImage.kf.setImage(with: resource)
        
        
        
        titleLabel.text = name
        priceLabel.text = cost
//        itemImageView.image = UIImage(systemName: "house")
        
        itemImageView.image = UIImage()
        let url = URL(string: imageURL)
        itemImageView.kf.setImage(with: url)
        stepperOutlet.value = Double(count)
        countLabel.text = "Количество: \(count)"
    }

}
