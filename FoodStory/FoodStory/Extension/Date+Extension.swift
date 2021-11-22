//
//  Date+Extension.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/22.
//

import Foundation
import UIKit

extension UIViewController {
    
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
            date.dateFormat = "yyyy년 MM월 dd일"
        }
        let nowDateForm = date.string(from: nowDate)
        
        return nowDateForm
    }
}


