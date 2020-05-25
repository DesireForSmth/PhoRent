//
//  OrdersTableViewCell.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 22.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }    
    
    func fillCell(name: String, cost: String, count: Int, imageURL: String) {
        backgroundColor = CustomColors.backgroundCell
        titleLabel.text = name
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        priceLabel.text = cost
        
        
        itemImageView.image = UIImage()
        let url = URL(string: imageURL)
        itemImageView.kf.setImage(with: url)
        countLabel.text = "Количество: \(count)"
        
        [titleLabel,
        priceLabel,
        countLabel].forEach {
            $0?.textColor = .black
        }
    }
    
}
