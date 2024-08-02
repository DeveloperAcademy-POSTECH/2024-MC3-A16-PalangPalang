//
//  AppStatusNotificationCentre.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

protocol AlarmSettings {
  func addAlarm(alarm: AlarmModel)
}

protocol AlarmOnProcess {
  func readMissionDate() -> Date?
}

protocol MissionOnProcess {
  func readTimeoutDate() -> Date?
  func deleteAlarm()
}

protocol CheckAlarmStatus {
  func verifyAndChangeAlarmState()
}

@Observable
class AlarmUseCase: CheckAlarmStatus {
  static let shared = AlarmUseCase()
  
  
  var alarmState: AlarmState = .alarmOnSettings
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
        print("미션 시작 시 불리는 메서드")
        self?.verifyAndChangeAlarmState()
      }, onMissionFinish: { [weak self] in
        print("미션 종료 시 불리는 메서드 ")
//        print("미션 TimeOver")
        self?.verifyAndChangeAlarmState()
      }
    )
  }
  
  /// 상태 갱신 요청
  func verifyAndChangeAlarmState() {
    let nowAlarm = DataStoreService<AlarmModel>().load()
    self.alarmState = determineAppState(alarm: nowAlarm)
  }
  
  /// Alarm 값을 토대로 Alarm 상태 분석
  private func determineAppState(alarm: AlarmModel?) -> AlarmState {
    let currentDate = Date()
    
    // AlarmModel이 없는 경우
    guard let alarm = alarm else { return .alarmOnSettings }

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

extension AlarmUseCase: AlarmSettings {
  func addAlarm(alarm: AlarmModel) {
    DataStoreService<AlarmModel>.init().save(alarm)
    LocalNotificationService.init().scheduleNotification(title: "미션시작", body: "귀신 퇴치하러 갑시당!", at: alarm.dueDate)
    timerService?.scheduleAlarmAndMissionTimers(alarm)
    verifyAndChangeAlarmState()
  }
}

extension AlarmUseCase: AlarmOnProcess {
  func readMissionDate() -> Date? {
    if let dueDate = DataStoreService<AlarmModel>.init().load()?.dueDate {
      return dueDate
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
