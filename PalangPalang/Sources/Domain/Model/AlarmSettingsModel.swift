//
//  AlarmSettingsModel.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

struct AlarmSettingsModel {
  @ValidHour var hour: String
  @ValidMinutes var minutes: String
  var isAM: Bool { return hour.toInt <= 12 }
  
  var alarmDate: Date? {
    let calendar = Calendar.current
    let now = Date()
    
    guard let alarmHour = Int(hour), let alarmMinutes = Int(minutes) else {
      return nil // 알람 시간이 유효하지 않을 경우 nil 반환
    }
    
    // 오늘의 알람 시간 설정
    var components = calendar.dateComponents([.year, .month, .day], from: now)
    components.hour = alarmHour
    components.minute = alarmMinutes
    components.second = 0
    
    guard let alarmDate = calendar.date(from: components) else {
      return nil
    }
    
    // 현재 시간보다 알람 시간이 이전이면 다음 날로 설정
    if alarmDate <= now {
      return calendar.date(byAdding: .day, value: 1, to: alarmDate)
    }
    
    return alarmDate
  }
  
  
  init(hour: String, minutes: String) {
    self.hour = hour
    self.minutes = minutes
  }
  
  // 현재 시각으로 시, 분 초기화
  init() {
    self.init(hour: "", minutes: "")
    self.hour = getCurrentHour()
    self.minutes = getCurrentMinute()
  }
  
  private func getCurrentHour() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "H" // 24시간 형식
    return dateFormatter.string(from: Date())
  }
  
  private func getCurrentMinute() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "m" // 분 형식
    return dateFormatter.string(from: Date())
  }
}

private extension String {
  var toInt: Int {
    return Int(self) ?? 0
  }
}
