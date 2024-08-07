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
  var alarmStatus: AlarmState = .mainAlarmSettings
  private var timerService: TimerSchedulerService?
  
  init() {
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
    let nowMissionCompleted = DataStoreService<MissionCompletedModel>().load()
    let nowAlarm = DataStoreService<AlarmModel>().load()
    self.alarmStatus = determineAppState(completedMission: nowMissionCompleted, alarm: nowAlarm)
  }
  
  /// Alarm 값을 토대로 Alarm 상태 분석
  private func determineAppState(completedMission: MissionCompletedModel?, alarm: AlarmModel?) -> AlarmState {
    let currentDate = Date()
    guard completedMission == nil else { return .missionCompleted }
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
    LocalNotificationService.init().scheduleNotification(title: "미션시작", body: "귀신 퇴치하러 갑시당!", at: alarm.dueDate.addingTimeInterval(1)) //1초 지연 뒤 알림
    timerService?.scheduleAlarmAndMissionTimers(alarm.delayBySeconds(1)) // 1초 지연 뒤 검증
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
  
  /// 알람 진행 중에 삭제 합니다
  func deleteAlarm() {
    DataStoreService<AlarmModel>.init().remove()
    timerService?.invalidateAllTimers()
    verifyAndChangeAlarmState()
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
  
  /// 미션 성공! Mission 성공을 의미하는 값을 저장하고 알람을 삭제합니다
  func missionCompletedAlarm() {
    guard let alarmDate = DataStoreService<AlarmModel>.init().load() else { return }
    
    let timeInterval = alarmDate.dueDate.timeIntervalSince(alarmDate.startDate)
    let doubleTime = Double(timeInterval)
    let missionCompletedModel: MissionCompletedModel = .init(missionOnProcessMinutes: String(Int(ceil(timeInterval / 60))))
    
    DataStoreService<MissionCompletedModel>.init().save(missionCompletedModel)
    DataStoreService<AlarmModel>.init().remove()
    timerService?.invalidateAllTimers()
    verifyAndChangeAlarmState()
  }
}

extension AlarmUseCase: MissionCompleted {
  func missionOnProcessMinutes() -> String? {
    return DataStoreService<MissionCompletedModel>.init().load()?.missionOnProcessMinutes
  }
  
  /// 알람을 삭제하고 미션을 종료합니다
  func endAlarm() {
    DataStoreService<AlarmModel>.init().remove()
    DataStoreService<MissionCompletedModel>.init().remove()
    timerService?.invalidateAllTimers()
    verifyAndChangeAlarmState()
  }
}
