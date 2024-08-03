//
//  ValidMinutes.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

@propertyWrapper
struct ValidMinutesOrSecond {
  private var value: String
  private let range = 0...59
  private let initialValue = "00"
  
  var wrappedValue: String {
    get { value }
    set { value = ValidMinutesOrSecond.validate(newValue, range: range, initialValue: initialValue) }
  }
  
  init(wrappedValue: String) {
    self.value = ValidMinutesOrSecond.validate(wrappedValue, range: range, initialValue: initialValue)
  }
  
  private static func validate(_ newValue: String, range: ClosedRange<Int>, initialValue: String) -> String {
    if let intValue = Int(newValue), range.contains(intValue) {
      return intValue < 10 ? "0\(intValue)" : "\(intValue)"
    } else {
      return initialValue
    }
  }
  
  static var availableMinutesOrSecond: [String] {
    (0...59).map { String(format: "%02d", $0) }
  }
}
