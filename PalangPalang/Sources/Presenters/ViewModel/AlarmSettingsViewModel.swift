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
    var isAmTapped: Bool
    //처음 ampm 버튼 설정
    init(){
      self.isAmTapped = alarm.isAM
    }
  }
  
  enum Action {
    case tappedSettingsButton
    case tappedSettingsDoneButton
    case changeAlarm(AlarmSettingsModel)
    case tappedStartAlarm
    case tappedAmButton
    case tappedPmButton
  }
  
  private(set) var state: State = .init()
  private let useCase: MainAlarmSettings
  
  init(useCase: MainAlarmSettings) {
    self.useCase = useCase
  }
  
  func effect(action: Action) {
    switch action {
    case .tappedSettingsButton:
      state.onSettings = true
      
    case .tappedSettingsDoneButton:
      state.onSettings = false
      state.readyForStart = true
      //12시간으로 변경된 값을 alarm.hour로 다시 넣어줄 때 24로 변경해서 넣어줌
      state.alarm.hour = state.isAmTapped ? state.alarm.set12Hour : "\((Int(state.alarm.set12Hour) ?? 00) + 12)"
      
    case let .changeAlarm(newAlarm):
      state.alarm = newAlarm
      
    case .tappedStartAlarm:
      guard let alarmDueDate = state.alarm.convertDate else { print("알람 변환실패"); return }
      let newAlarm = AlarmModel(dueDate: alarmDueDate)
      useCase.addAlarm(alarm: newAlarm)
      
    case .tappedAmButton:
      state.isAmTapped = true
      
    case .tappedPmButton:
      state.isAmTapped = false
    }
  }
}
