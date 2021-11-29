//
//  ColorSet.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/23.
//

import Foundation
import UIKit

extension UIViewController {
    static let backgroundColor = "CEDCC3"
    static let contentColor = "CBD5C5"
    static let tintColor = "3F674C"
    static let testColor = "B5CDA3"
}


extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    
    convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
    
}
