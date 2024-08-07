//
//  ValidHour.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

@propertyWrapper
struct ValidHour {
  private var value: String
  private let range = 0...24
  private let initialValue = "00"
  
  var wrappedValue: String {
    get { value }
    set { value = ValidHour.validate(newValue, range: range, initialValue: initialValue) }
  }
  
  init(wrappedValue: String) {
    self.value = ValidHour.validate(wrappedValue, range: range, initialValue: initialValue)
  }
  
  private static func validate(_ newValue: String, range: ClosedRange<Int>, initialValue: String) -> String {
    if let intValue = Int(newValue), range.contains(intValue) {
      return intValue < 10 ? "0\(intValue)" : "\(intValue)"
    } else {
      return initialValue
    }
  }
  
  static var availableHours: [String] {
    (0...12).map { String(format: "%02d", $0) }
  }
}
