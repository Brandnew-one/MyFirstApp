//
//  AlarmTableViewCell.swift
//  FoodStory
//
//  Created by 신상원 on 2021/12/07.
//

import RealmSwift
import UIKit
import UserNotifications

class AlarmTableViewCell: UITableViewCell {

  var localRealm = try! Realm()
  var localNotificationList: Results<UserNotification>!
  let userNotificationCenter = UNUserNotificationCenter.current()
  static let identifier = "AlarmTableViewCell"

  @IBOutlet weak var alarmLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var alarmSwitch: UISwitch!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func configureCell() {
    timeLabel.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: 40)!
  }

  @IBAction func alaramSwitchClicked(_ sender: UISwitch) {
    localNotificationList = localRealm.objects(UserNotification.self).sorted(byKeyPath: "userIndex", ascending: true)
    let taskToUpdate = localNotificationList[sender.tag]
    try! localRealm.write {
      taskToUpdate.userSettingisOn = sender.isOn
    }
    if sender.isOn {
      let row = localNotificationList[sender.tag]
      let userNoti = LocalNotification(id: row._id, date: row.userSettingTime!, isOn: row.userSettingisOn)
      userNotificationCenter.addNotificationRequest(by: userNoti)
    }
    else {
      let row = localNotificationList[sender.tag]
      userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [row._id.stringValue])
    }
  }
}
