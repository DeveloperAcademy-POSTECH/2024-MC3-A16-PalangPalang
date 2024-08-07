//
//  MissionCompleted.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/3/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

protocol MissionCompleted {
  func missionOnProcessMinutes() -> String?
  func endAlarm()
}
