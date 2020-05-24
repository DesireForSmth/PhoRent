//
//  CustomColors.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

struct CustomColors {
    static let background = UIColor.secondarySystemBackground
    static let textLabel = UIColor.label
    static let backgroundButton = UIColor.tertiarySystemFill
    static let textButton = UIColor.secondaryLabel
    static let textLabelSecond = UIColor.systemTeal
    
    static let mercuryColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    
    public static var backgroundCell: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return CustomColors.mercuryColor
                } else {
                    return .white
                }
            }
        } else {
            return .white
        }
    }()

    
}


