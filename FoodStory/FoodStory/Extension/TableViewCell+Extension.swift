//
//  TableViewCell+Extension.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/21.
//

import UIKit
import Foundation


extension UITableViewCell {
    
    func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let filePath = documentDirectory.appendingPathComponent("Image")
        if !FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let imageURL = filePath.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: imageURL.path)
    }
    
    func fillStarImage(userRating: Double, starImages: [UIImageView]) {
        var value = userRating
        for i in 0...4 {
            if value > 0.5 {
                value -= 1
                starImages[i].image = UIImage(systemName: "star.fill")
            }
            else if value > 0 && value <= 0.5 {
                value -= 0.5
                starImages[i].image = UIImage(systemName: "star.leadinghalf.filled")
            }
            else {
                starImages[i].image = UIImage(systemName: "star")
            }
        }
    }
}
