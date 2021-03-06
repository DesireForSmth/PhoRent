//
//  MainSearchTableViewCell.swift
//  appPhoRent
//
//  Created by Ilya Buzyrev on 22.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class MainSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    
    @IBOutlet weak var categoryName: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = CustomColors.backgroundCell
        categoryName.textColor = .black
        categoryName.textAlignment = .right
    }
}
