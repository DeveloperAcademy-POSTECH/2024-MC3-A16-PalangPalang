//
//  LocalNotificationService.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation
import UserNotifications

// MARK: - 로컬 알림 설정
struct LocalNotificationService {
  init() {
    requestNotificationPermission()
  }
  
  // 알림 권한 요청
  private func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
        print("알림 권한 요청 오류: \(error)")
      }
    }
  }
  
  // 특정 시간에 알림 예약
  func scheduleNotification(title: String, body: String, at date: Date) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    content.badge = 1
    
    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("알림 예약 실패: \(error)")
      }
    }
  }
  
  // 즉시 알림 발송
  func sendNotification(title: String, body: String) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
    
    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("즉시 알림 발송 실패: \(error)")
      }
    }
  }
}
