//
//  AlarmOnProcessViewModel.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

@Observable
class AlarmOnProcessViewModel {
  struct State {
    var dueTime: String
    @ValidHour var timerH: String = ""
    @ValidMinutesOrSecond var timerM: String = ""
    @ValidMinutesOrSecond var timerS: String = ""
    var progress: ProgressStep = .init(ratio: 0)
    
    enum ProgressStep: Double, CaseIterable {
      case first = 0.0
      case second = 0.25
      case third = 0.5
      case fourth = 0.75
      
      init(ratio: Double) {
        let adjustedRatio = max(0, min(ratio, 1)) // ratio를 0과 1 사이로 조정
        
        // 각 case와의 차이를 계산하여 가장 작은 차이를 가지는 case를 선택
        self = ProgressStep.allCases.min(
          by: { abs($0.rawValue - adjustedRatio) < abs($1.rawValue - adjustedRatio) }
        ) ?? .fourth
      }
      
      static let partsCount = ProgressStep.allCases.count
    }
  }
  
  enum Action {
    case tappedAlarmCancel
    
    case _onAppear
    case _timeElapsed(totalSec: Int) // ViewModel 내부 로직
    case _timerOver
  }
  
  private(set) var state: State = .init(dueTime: "00:00")
  private let useCase: AlarmOnProcess
  
  private var dueDate: Date?
  private var timer: Timer?
  private var totalSecondsToDueDate: Double?
  private var timeRemaining: Int = 0 {
    willSet {
      if newValue >= 0 {
        effect(action: ._timeElapsed(totalSec: newValue))
      } else { // 0초 이전 동작
        effect(action: ._timerOver)
      }
    }
  }
  
  init(useCase: AlarmOnProcess) {
    self.useCase = useCase
  }
  
  // MARK: - ViewModel 내 모든 상태 변경 / 외부 서비스 호출 장소
  func effect(action: Action) {
    switch action {
    case ._onAppear:
      if let (startDate, dueDate) = useCase.readAlarmDate() {
        let timeInterval = dueDate.timeIntervalSince(.now)
        let timeIntervalStartToDue = dueDate.timeIntervalSince(startDate)
        let totalSeconds = Int(timeInterval)
        
        let timerInfo = calculateTimeInterval(totalSeconds: totalSeconds)
        let dueTime = dueDateToString(dueDate)
        
        self.state.timerH = timerInfo.hour
        self.state.timerM = timerInfo.minute
        self.state.timerS = timerInfo.seconds
        self.state.dueTime = dueTime
        
        self.dueDate = dueDate // 포그라운드 복귀 시 사용
        self.totalSecondsToDueDate = Double(timeIntervalStartToDue)
        
        startTimer(for: totalSeconds)
        connectAppDidBecomeActive()
      }
      return
      
    case .tappedAlarmCancel:
      stopTimer()
      useCase.deleteAlarm()
      
    case let ._timeElapsed(nowSeconds):
      let timerInfo = calculateTimeInterval(totalSeconds: nowSeconds)
      state.timerH = timerInfo.hour
      state.timerM = timerInfo.minute
      state.timerS = timerInfo.seconds
      
      let totalSeconds = totalSecondsToDueDate ?? 1.0
      let nowSecondsD = Double(nowSeconds)
      let progressRatio = (totalSeconds-nowSecondsD)/totalSeconds
      state.progress = .init(ratio: progressRatio)
      
    case ._timerOver:
      stopTimer()
    }
  }
  
  private func dueDateToString(_ dueDate: Date) -> String {
    let twentyFourHour = Int(dueDate.getHour()) ?? 0
    let numHour = twentyFourHour <= 12 ? twentyFourHour : twentyFourHour-12
    let hour = String(format: "%02d", numHour)
    let min = dueDate.getMinute()
    
    return "\(hour):\(min)"
  }
  
  private func calculateTimeInterval(totalSeconds: Int) -> (hour: String, minute: String, seconds: String) {
    let hours = String(totalSeconds / 3600)
    let minutes = String((totalSeconds % 3600) / 60)
    let seconds = String(totalSeconds % 60)
    
    return (hours, minutes, seconds)
  }
}

// MARK: - Timer 관리 메서드
extension AlarmOnProcessViewModel {
  private func connectAppDidBecomeActive() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(verifyAndChangeTimerState),
      name: .appDidBecomeActive,
      object: nil
    )
  }
  
  @objc private func verifyAndChangeTimerState() {
    guard let dueDate else { return }
    let timeInterval = dueDate.timeIntervalSince(.now)
    let totalSeconds = Int(timeInterval)
    resetTimeRemaining(for: totalSeconds)
  }
  
  private func startTimer(for time: Int) {
    stopTimer() // 이전 타이머가 있으면 종료
    resetTimeRemaining(for: time)
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      guard let self else { return }
      self.resetTimeRemaining(for: self.timeRemaining-1)
    }
  }
  
  private func resetTimeRemaining(for time: Int) {
    timeRemaining = time
  }
  
  private func stopTimer() {
    timer?.invalidate()
  }
}

