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
    
    static let backgroundLabel = UIColor.tertiarySystemFill
    static let textLabelSecond = UIColor.systemTeal
    
    static var backgroundCell = UIColor.white
    
    static let mercuryColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    static let blueColor = UIColor(red: 90/255, green: 190/255, blue: 255/255, alpha: 1)
    static let orangeColor = UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 1)
    
    
    public static var textButton: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return .black
                } else {
                    return .white
                }
            }
        } else {
            return .white
        }
    }()
    
    public static var backgroundButton: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return orangeColor
                } else {
                    return blueColor
                }
            }
        } else {
            return blueColor
        }
    }()
    
    public static var backgroundButtonOut: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return .white
                } else {
                    return .white
                }
            }
        } else {
            return .white
        }
    }()
}


