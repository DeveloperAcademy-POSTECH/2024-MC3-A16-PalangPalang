//
//  ValidMinutes.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

@propertyWrapper
struct ValidMinutes {
  private var value: String
  private let range = 0...59
  private let initialValue = "00"
  
  var wrappedValue: String {
    get { value }
    set { value = ValidMinutes.validate(newValue, range: range, initialValue: initialValue) }
  }
  
  init(wrappedValue: String) {
    self.value = ValidMinutes.validate(wrappedValue, range: range, initialValue: initialValue)
  }
  
  private static func validate(_ newValue: String, range: ClosedRange<Int>, initialValue: String) -> String {
    if let intValue = Int(newValue), range.contains(intValue) {
      return intValue < 10 ? "0\(intValue)" : "\(intValue)"
    } else {
      return initialValue
    }
  }
  
  static var availableMinutes: [String] {
    (0...59).map { String(format: "%02d", $0) }
  }
}
