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
  @ValidMinutesOrSecond var minutes: String
  var isAM: Bool { return hour.toInt <= 12 }
  
  var set12Hour: String //{ return isAM ? "\(hour)":"\(hour.toInt)-12"}
  
  /// 입력한 hour, minutes 정보를 토대로 Date 반환 계산속성
  var convertDate: Date? {
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
  
  
  init(hour: String, minutes: String, set12Hour: String) {
    self.hour = hour
    self.minutes = minutes
    self.set12Hour = set12Hour
  }
  
  // 현재 시각으로 시, 분 초기화
  init() {
    self.init(hour: "", minutes: "", set12Hour: "")
    let now = Date.now
    self.hour = now.getHour()
    self.minutes = now.getMinute()
    self.set12Hour = convert12Hour()
  }

  func convert12Hour() -> String {
    return isAM ? "\(hour)" : hour.toInt<22 ? "0\(hour.toInt-12)" : "\(hour.toInt-12)"
  }
}

extension String {
  var toInt: Int {
    return Int(self) ?? 0
  }
}
