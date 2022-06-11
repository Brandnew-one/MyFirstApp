//
//  File.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/25.
//

import UIKit

//for family in UIFont.familyNames {
//  print(family)
//
//  for sub in UIFont.fontNames(forFamilyName: family) {
//    print("=======> \(sub)")
//  }
//}

extension UIFont {
  //    =======> SpoqaHanSansNeo-Regular
  //    =======> SpoqaHanSansNeo-Thin
  //    =======> SpoqaHanSansNeo-Light
  //    =======> SpoqaHanSansNeo-Medium
  //    =======> SpoqaHanSansNeo-Bold
  var mainRegular: UIFont {
    return UIFont(name: "SpoqaHanSansNeo-Regular", size: 15)!
  }

  var mainThin: UIFont {
    return UIFont(name: "SpoqaHanSansNeo-Thin", size: 15)!
  }

  var mainLight: UIFont {
    return UIFont(name: "SpoqaHanSansNeo-Light", size: 15)!
  }

  var mainMedium: UIFont {
    return UIFont(name: "SpoqaHanSansNeo-Medium", size: 15)!
  }

  var mainBold: UIFont {
    return UIFont(name: "SpoqaHanSansNeo-Bold", size: 15)!
  }

}


