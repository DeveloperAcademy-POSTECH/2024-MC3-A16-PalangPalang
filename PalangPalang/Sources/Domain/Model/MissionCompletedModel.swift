//
//  MissionCompletedModel.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/3/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

struct MissionCompletedModel: Storable {
  static let targetStep = 30
  static let limitSeconds: TimeInterval = 20
  
  static var storageKey: String { return "mission" }
}
