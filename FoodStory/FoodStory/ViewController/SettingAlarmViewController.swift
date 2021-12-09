//
//  SettingAlarmViewController.swift
//  FoodStory
//
//  Created by 신상원 on 2021/12/08.
//

import RealmSwift
import UIKit

class SettingAlarmViewController: UIViewController {
    
    var localRealm = try! Realm()
    var passedNotification: UserNotification = UserNotification(userIndex: 0, userSettingTime: nil, userSettingisOn: true)
    var pickedDate: ((_ date: Date) -> Void)?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = passedNotification.userSettingTime!
    }
    
    
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        let taskToUpdate = passedNotification
        try! localRealm.write {
            taskToUpdate.userSettingTime = datePicker.date
        }
        pickedDate?(self.datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
