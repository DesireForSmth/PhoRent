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
    func deleteRow(sender: UIButton)
}

class BasketTableViewCell: UITableViewCell {
    
    var delegate: BasketTableViewCellDelegate?

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteAction(_ sender: UIButton) {
        delegate?.deleteRow(sender: sender)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
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
