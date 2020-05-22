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
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        // Configure the view for the selected state
//    }
    
    
    func fillCell(name: String, cost: String, count: Int, imageURL: String) {
        backgroundColor = CustomColors.background
        titleLabel.text = name
        priceLabel.text = cost
        
        itemImageView.image = UIImage()
        let url = URL(string: imageURL)
        itemImageView.kf.setImage(with: url)
        countLabel.text = "Количество: \(count)"
    }
    
}
