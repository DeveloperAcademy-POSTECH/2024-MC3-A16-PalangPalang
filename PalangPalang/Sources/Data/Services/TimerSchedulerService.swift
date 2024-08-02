//
//  TimerSchedulerService.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation
import UserNotifications

// MARK: - 설정한 알람의 시간과 미션 종료 시간을 감지하고 알려주는 메서드
class TimerSchedulerService {
  let onMissionStart: () -> Void
  let onMissionTimeout: () -> Void
  private var alarmTimer: Timer?
  private var missionTimer: Timer?
  
  init(alarm: AlarmModel? = nil, onMissionStart: @escaping () -> Void, onMissionFinish: @escaping () -> Void) {
    self.onMissionStart = onMissionStart
    self.onMissionTimeout = onMissionFinish
    guard let alarm else { return }
    scheduleAlarmAndMissionTimers(alarm)
  }

  func scheduleAlarmAndMissionTimers(_ alarm: AlarmModel) {
    let dueDate = alarm.dueDate
    let missionCompleted = alarm.missionDueDate
    scheduleAlarmNotification(dueDate: dueDate)
    scheduleMissionNotification(missionCompleted: missionCompleted)
  }
  
  // 모든 타이머를 종료하는 메서드
  func invalidateAllTimers() {
    invalidateAlarmTimer()
    invalidateMissionTimer()
    print("모든 타이머가 종료되었습니다.")
  }
  
  // 미션 시작시간에 알림 설정
  private func scheduleAlarmNotification(dueDate: Date) {
    let timeInterval = dueDate.timeIntervalSinceNow
    guard timeInterval > 0 else { return }
      alarmTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(startMission), userInfo: nil, repeats: false)
  }
  
  // 미션 시간오버 시간에 알림 설정
  private func scheduleMissionNotification(missionCompleted: Date) {
    let timeInterval = missionCompleted.timeIntervalSinceNow
    guard timeInterval > 0 else { return }
      missionTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timeoutMission), userInfo: nil, repeats: false)
  }
  
  // 개별 타이머 종료 메서드
  private func invalidateAlarmTimer() {
    alarmTimer?.invalidate()
    alarmTimer = nil
  }
  
  private func invalidateMissionTimer() {
    missionTimer?.invalidate()
    missionTimer = nil
  }
  
  @objc private func startMission() {
    // 화면 상태를 갱신할 필요가 있음
    onMissionStart()
  }
  
  @objc private func timeoutMission() {
    // 화면 상태를 갱신할 필요가 있음
    onMissionTimeout()
  }
  
  deinit {
    alarmTimer?.invalidate()
    missionTimer?.invalidate()
  }
}
