//
//  MissionViewModel.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.ㅁ
//

import CoreMotion
import Foundation
import UIKit

// MARK: - 디린세스 꺼
@Observable
class MissionOnProcessViewModel {
  struct State {
    @ValidMinutesOrSecond var timerM: String = ""
    @ValidMinutesOrSecond var timerS: String = ""
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
    case _reduceStep
    
    case _onAppear
    case _onDisappear
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
  
  // 가속도 데이터 관리
  private let motionManager = CMMotionManager()
  private let motionQueue = OperationQueue()
  private let shakeThreshold: Double = 2.5 // 흔들림 인식 기준 가속도
  private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
  
  init(useCase: MissionOnProcess) {
    self.useCase = useCase
  }
  
  func effect(action: Action) {
    switch action {
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
          self.stopAccelerometerUpdates()
          self.useCase.missionCompletedAlarm()
        }
        
        startTimer(for: totalSeconds)
        startAccelerometerUpdates()
        connectAppDidBecomeActive()
      }
      return
      
    case ._onDisappear:
      self.stopTimer()
      self.stopAccelerometerUpdates()
      return
      
    case ._reduceStep: // 스텝이 0이 되면 미션이 종료되는 지 확인용
      self.state.nowSteps -= 1
      impactFeedbackGenerator.impactOccurred() // 햅틱 피드백 발생
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
  // 가속도 업데이트 시작
  private func startAccelerometerUpdates() {
    guard motionManager.isAccelerometerAvailable else {
      print("Accelerometer is not available.")
      return
    }
    
    motionManager.accelerometerUpdateInterval = 0.2 // 흔들림 감지를 위해 업데이트 주기 설정
    motionManager.startAccelerometerUpdates(to: motionQueue) { [weak self] accelData, error in
      if let error = error {
        print("Accelerometer error: \(error.localizedDescription)")
        return
      }
      
      guard let self = self, let accelData = accelData else { return }
      let acceleration = accelData.acceleration
      
      // 가속도 계산
      let xWeight: Double = 0.8
      let yWeight: Double = 0.8
      let zWeight: Double = 0.8
      
      let totalAcceleration = sqrt(
        pow(acceleration.x * xWeight, 2) +
        pow(acceleration.y * yWeight, 2) +
        pow(acceleration.z * zWeight, 2)
      )
      
      DispatchQueue.main.async {
        self.handleMotion(totalAcceleration, xAccel: acceleration.x, yAccel: acceleration.y, zAccel: acceleration.z)
      }
    }
  }
  
  // 가속도 데이터 처리
  private func handleMotion(_ acceleration: Double, xAccel: Double, yAccel: Double, zAccel: Double) {
    // 흔들림 감지하여 남은 걸음 수 감소
    if acceleration > shakeThreshold {
      self.effect(action: ._reduceStep)
    }
  }
  
  private func stopAccelerometerUpdates() { // 가속도 업데이트 중지
    motionManager.stopAccelerometerUpdates()
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
