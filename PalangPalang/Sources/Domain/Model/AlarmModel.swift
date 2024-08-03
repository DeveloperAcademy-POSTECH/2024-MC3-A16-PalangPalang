//
//  AlarmModel.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

struct AlarmModel: Storable {
  var startDate: Date = .now
  var dueDate: Date
  var missionDueDate: Date {
    return dueDate.addingTimeInterval(MissionCompletedModel.limitSeconds)
  }
  
  static let storageKey: String = "alarm"
  
  func delayBySeconds(_ seconds: Int) -> Self {
    let timeInterval = TimeInterval(seconds)
    let delayStartDate = startDate.addingTimeInterval(timeInterval)
    let delayDueDate = dueDate.addingTimeInterval(timeInterval)
    return AlarmModel(startDate: delayStartDate, dueDate: delayDueDate)
  }
}
