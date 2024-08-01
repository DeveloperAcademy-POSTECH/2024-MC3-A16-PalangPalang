//
//  AlarmViewModel.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

@Observable
class AlarmViewModel {
  struct State {
    var alarm: AlarmSettingsModel = .init()
    var formattedAlarmDate: String {
      guard let alarmDate = alarm.alarmDate else {
        return "Invalid Date"
      }
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
      
      return dateFormatter.string(from: alarmDate)
    }
    var onSettings: Bool = false
    var readyForStart: Bool = false
  }
  
  enum Action {
    case tappedSettingsButton
    case tappedSettingsDoneButton
    case changeAlarm(AlarmSettingsModel)
    case tappedStartAlarm
  }
  
  private(set) var state: State = .init()
  private let useCase: AlarmSettings = AlarmUseCase.shared
  
  func effect(action: Action) {
    switch action {
    case .tappedSettingsButton:
      state.onSettings = true
    case .tappedSettingsDoneButton:
      state.onSettings = false
      state.readyForStart = true
    case let .changeAlarm(newAlarm):
      state.alarm = newAlarm
    case .tappedStartAlarm:
      guard let alarmDueDate = state.alarm.alarmDate else { print("알람 변환실패"); return }
      let newAlarm = AlarmModel(dueDate: alarmDueDate)
      useCase.addAlarm(alarm: newAlarm)
      
    }
  }
}
