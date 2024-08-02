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
    return dueDate.addingTimeInterval(AlarmModel.timeLimit)
  }
  
  static let storageKey: String = "alarm"
  static let timeLimit: TimeInterval = 3
}
