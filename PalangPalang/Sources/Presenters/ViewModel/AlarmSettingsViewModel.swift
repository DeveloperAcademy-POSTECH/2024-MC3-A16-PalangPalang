//
//  AlarmSettingsViewModel.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

@Observable
class AlarmSettingsViewModel {
  struct State {
    var alarm: AlarmSettingsModel = .init()
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
  private let useCase: MainAlarmSettings = AlarmUseCase.shared
  
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
      guard let alarmDueDate = state.alarm.convertDate else { print("알람 변환실패"); return }
      let newAlarm = AlarmModel(dueDate: alarmDueDate)
      useCase.addAlarm(alarm: newAlarm)
      
    }
  }
}
