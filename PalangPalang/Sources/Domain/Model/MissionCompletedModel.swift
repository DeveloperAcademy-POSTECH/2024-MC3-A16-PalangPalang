//
//  MissionCompletedModel.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/3/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

struct MissionCompletedModel: Storable {
  var missionOnProcessMinutes: String
  
  static let targetStep = 10
  static let limitSeconds: TimeInterval = 60
  
  static var storageKey: String { return "mission" }
}
