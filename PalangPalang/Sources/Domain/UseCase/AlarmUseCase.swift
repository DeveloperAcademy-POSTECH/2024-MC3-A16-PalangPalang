//
//  AppStatusNotificationCentre.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

@Observable
class AlarmUseCase: AlarmStaus {
  static let shared = AlarmUseCase()
  
  var alarmStatus: AlarmState = .mainAlarmSettings
  private var timerService: TimerSchedulerService?
  
  private init() {
    self.verifyAndChangeAlarmState()
    self.setupTimerService()
  }
  
  private func setupTimerService() {
    let alarm = DataStoreService<AlarmModel>.init().load()
    timerService = TimerSchedulerService.init(
      alarm: alarm,
      onMissionStart: { [weak self] in
        self?.verifyAndChangeAlarmState()
      }, onMissionFinish: { [weak self] in
        self?.verifyAndChangeAlarmState()
      }
    )
  }
  
  /// 상태 갱신 요청
  func verifyAndChangeAlarmState() {
    let nowAlarm = DataStoreService<AlarmModel>().load()
    self.alarmStatus = determineAppState(alarm: nowAlarm)
  }
  
  /// Alarm 값을 토대로 Alarm 상태 분석
  private func determineAppState(alarm: AlarmModel?) -> AlarmState {
    let currentDate = Date()
    
    // AlarmModel이 없는 경우
    guard let alarm = alarm else { return .mainAlarmSettings }

    // AlarmModel이 있는 경우
    if currentDate < alarm.dueDate {
      return .alarmOnProcess
    } else if currentDate < alarm.missionDueDate {
      return .missionOnProcess
    } else {
      return .missionTimeout
    }
  }
}

extension AlarmUseCase: MainAlarmSettings {
  func addAlarm(alarm: AlarmModel) {
    DataStoreService<AlarmModel>.init().save(alarm)
    LocalNotificationService.init().scheduleNotification(title: "미션시작", body: "귀신 퇴치하러 갑시당!", at: alarm.dueDate)
    timerService?.scheduleAlarmAndMissionTimers(alarm)
    verifyAndChangeAlarmState()
  }
}

extension AlarmUseCase: AlarmOnProcess {
  func readAlarmDate() -> (start: Date, due: Date)? {
    if let alarm = DataStoreService<AlarmModel>.init().load() {
      return (alarm.startDate, alarm.dueDate)
    } else {
      verifyAndChangeAlarmState() // 데이터가 없다면 상태 갱신 요청
      return nil
    }
  }
}

extension AlarmUseCase: MissionOnProcess {
  func readTimeoutDate() -> Date? {
    if let dueDate = DataStoreService<AlarmModel>.init().load()?.missionDueDate {
      return dueDate
    } else {
      verifyAndChangeAlarmState() // 데이터가 없다면 상태 갱신 요청
      return nil
    }
  }
  
  func deleteAlarm() {
    DataStoreService<AlarmModel>.init().remove()
    verifyAndChangeAlarmState()
  }
}
