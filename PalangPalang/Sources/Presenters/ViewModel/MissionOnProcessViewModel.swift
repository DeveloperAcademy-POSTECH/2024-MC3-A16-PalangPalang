//
//  MissionViewModel.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

// MARK: - 디린세스 꺼
@Observable
class MissionOnProcessViewModel {
  struct State {
    @ValidHour var timerH: String = ""
    @ValidMinutesOrSecond var timerM: String = ""
    var nowSteps: Int = MissionCompletedModel.targetStep {
      willSet {
        if newValue == 0 {
          zeroStepAction()
        }
      }
    }
    var zeroStepAction: () -> Void
    
    init(zeroStepAction: @escaping () -> Void) {
      self.zeroStepAction = zeroStepAction
    }
  }
  
  enum Action {
    case _디리니를위한강제로스텝줄이기
    
    case _onAppear
    case _timeElapsed(totalSeconds: Int) // ViewModel 내부 로직
    case _missionFailure
  }
  
  private(set) var state: State = .init(zeroStepAction: {  })
  private let useCase: MissionOnProcess
  
  private var timer: Timer?
  private var missionDueDate: Date?
  private var timeRemaining: Int = Int(MissionCompletedModel.limitSeconds) {
    willSet {
      if newValue >= 0 {
        effect(action: ._timeElapsed(totalSeconds: newValue))
      } else { // 0초에 동작
        effect(action: ._missionFailure)
      }
    }
  }
  
  init(useCase: MissionOnProcess) {
    self.useCase = useCase
  }
  
  func effect(action: Action) {
    switch action {
      
    case ._디리니를위한강제로스텝줄이기: // 스텝이 0이 되면 미션이 종료되는 지 확인용
      self.state.nowSteps -= 1
      return
      
      /// 타이머 실행
    case ._onAppear:
      if let timeOutDate = useCase.readTimeoutDate() {
        let timeInterval = timeOutDate.timeIntervalSince(.now)
        let totalSeconds = Int(timeInterval)
        
        let timerInfo = calculateTimeInterval(totalSeconds: totalSeconds)
        
        self.state.timerM = timerInfo.minute
        self.state.timerS = timerInfo.seconds
        self.missionDueDate = timeOutDate // 포그라운드 복귀 시 사용
        self.state.zeroStepAction = { [weak self] in
          guard let self else { return }
          self.stopTimer()
          self.useCase.missionCompletedAlarm()
        }
        
        startTimer(for: totalSeconds)
        connectAppDidBecomeActive()
      }
      return
      
      /// 보여줄 시간 줄어듦
    case let ._timeElapsed(totalSteps):
      let timerInfo = calculateTimeInterval(totalSeconds: totalSteps)
      
      state.timerM = timerInfo.minute
      state.timerS = timerInfo.seconds
      return
      
    case ._missionFailure:
      stopTimer()
      return
    }
  }
  
  private func calculateTimeInterval(totalSeconds: Int) -> (minute: String, seconds: String) {
    let minutes = String((totalSeconds % 3600) / 60)
    let seconds = String(totalSeconds % 60)
    
    return (minutes, seconds)
  }
}

extension MissionOnProcessViewModel {
  private func connectAppDidBecomeActive() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(verifyAndChangeTimerState),
      name: .appDidBecomeActive,
      object: nil
    )
  }
  
  @objc private func verifyAndChangeTimerState() {
    guard let missionDueDate else { return }
    
    let timeInterval = missionDueDate.timeIntervalSince(.now)
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
