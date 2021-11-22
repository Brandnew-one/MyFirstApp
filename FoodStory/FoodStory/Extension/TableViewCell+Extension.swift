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
    
    func dateCal(nowDate: Date) -> String {
            
        let date = DateFormatter()
        let releasedDate = Calendar.current.dateComponents([.weekOfYear, .day], from: nowDate)
        let nowDateCalendar = Calendar.current.dateComponents([.weekOfYear, .day], from: Date())
        date.locale = Locale(identifier: "ko_KR")
        
        //날짜가 같은 경우 시간만 나오도록 설정
        if releasedDate.day == nowDateCalendar.day {
            date.dateFormat = "a hh:mm"
        }
        //같은주일 경우에는 요일만 나오도록 설정
        else if releasedDate.weekOfYear == nowDateCalendar.weekOfYear {
            date.dateFormat = "EEEE"
        }
        //그외의 경우에는 모든 형식이 나오도록 설정
        else {
            //date.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
            date.dateFormat = "yy.MM.dd"
        }
        let nowDateForm = date.string(from: nowDate)
        
        return nowDateForm
    }
}
