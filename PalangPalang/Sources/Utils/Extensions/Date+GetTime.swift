//
//  Date.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/3/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

extension Date {
  func getHour() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH" // 24시간 형식
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return dateFormatter.string(from: self)
  }
  
  func getMinute() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "mm" // 분 형식
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return dateFormatter.string(from: self)
  }
  
  func getSecond() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "ss" // 초 형식
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return dateFormatter.string(from: self)
  }
}
