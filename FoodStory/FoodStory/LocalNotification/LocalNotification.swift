//
//  LocalNotification.swift
//  FoodStory
//
//  Created by 신상원 on 2021/12/08.
//

import Foundation
import RealmSwift

struct LocalNotification: Codable {
  var id: ObjectId
  var date: Date
  var isOn: Bool
}
