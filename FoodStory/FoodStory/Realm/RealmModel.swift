//
//  RealmModel.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/19.
//

import RealmSwift
import Foundation


// MARK: - Food Diary Model
class UserDiary: Object {
  @Persisted var writeDate: Date // 날짜
  @Persisted var userRating: Double // 별점
  @Persisted var foodTitle: String // 음식이름
  @Persisted var foodMemo: String // 다이어리 내용

  @Persisted(primaryKey: true) var _id: ObjectId

  convenience init(writeDate: Date, userRating: Double, foodTitle: String, foodMemo: String) {
    self.init()
    self.writeDate = writeDate
    self.userRating = userRating
    self.foodTitle = foodTitle
    self.foodMemo = foodMemo
  }
}

// MARK: - Profile Model
class Userprofile: Object {
  @Persisted var userName: String // 유저이름
  @Persisted var userIntroduction: String // 유저설명

  // MARK: - PK(필수) : Int, String, UUID, ObjectID 네 가지 사용가능 (ObjectID 는 자동으로)
  @Persisted(primaryKey: true) var _id: ObjectId

  convenience init(userName: String, userIntroduction: String) {
    self.init()
    self.userName = userName
    self.userIntroduction = userIntroduction
  }
}

// MARK: - Notification Model
class UserNotification: Object {
  @Persisted var userIndex: Int
  @Persisted var userSettingTime: Date? // 설정시간
  @Persisted var userSettingisOn: Bool // ON,Off 설정
  @Persisted(primaryKey: true) var _id: ObjectId

  convenience init(userIndex: Int, userSettingTime: Date?, userSettingisOn: Bool) {
    self.init()
    self.userIndex = userIndex
    self.userSettingTime = userSettingTime
    self.userSettingisOn = userSettingisOn
  }
}
