//
//  RealmQuery.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/22.
//

import RealmSwift
import Foundation
import UIKit

extension UIViewController {
    
    func searchSameDay(date: Date) -> Results<UserDiary> {
        let localRealm = try! Realm()
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        
        //Date 형식을 바로 포맷 적용하는 메서드는 없을까?
        let refDate = Date(timeInterval: (60*60*24), since: date) //선택한 다음날을 기준으로 설정
        
        //Date를 포맷을 적용한 String 으로 변경
        let stringPickDate = format.string(from: date)
        let pickDate = format.date(from: stringPickDate)
        
        //포맷이 적용된 String 를 다시 Date 로 변경
        let stringRefDate = format.string(from: refDate)
        let pickRefDate = format.date(from: stringRefDate)
        
        let search = localRealm.objects(UserDiary.self).filter("writeDate >= %@ AND writeDate < %@ ",pickDate, pickRefDate)
        return search
    }
    
}
