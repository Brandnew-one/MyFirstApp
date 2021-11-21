//
//  CalendarViewController.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/18.
//

import FSCalendar
import RealmSwift
import UIKit


class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var testLabel: UILabel!
    
    let localRealm = try! Realm()
    var diary: Results<UserDiary>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.dataSource = self
        calendarView.delegate = self
        diary = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDate", ascending: false)
    }
    

}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        let stringPickDate = format.string(from: date)
        let pickDate = format.date(from: stringPickDate)
        
        self.testLabel.text = "\(diary.filter("writeDate == %@", pickDate).count)"
        print(diary.filter("writeDate == %@", date).count)
        return diary.filter("writeDate == %@", pickDate).count
    }
    
}
