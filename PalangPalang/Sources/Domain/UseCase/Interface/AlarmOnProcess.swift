//
//  AlarmOnProcess.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

protocol AlarmOnProcess {
  func readAlarmDate() -> (start: Date, due: Date)?
  func deleteAlarm()
}
