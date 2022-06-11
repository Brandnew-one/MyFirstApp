//
//  UNNotificationCenter.swift
//  FoodStory
//
//  Created by 신상원 on 2021/12/08.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
  func addNotificationRequest(by alert: LocalNotification) {
    let content = UNMutableNotificationContent()
    content.title = "설정한 시간이에요"
    content.body = "식사를 기록해보세요"
    content.sound = .default
    content.badge = 0

    let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)

    let request = UNNotificationRequest(identifier: alert.id.stringValue, content: content, trigger: trigger)
    self.add(request, withCompletionHandler: nil)
  }
}
