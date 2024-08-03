//
//  MissionModel.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/3/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

struct MissionCompletedModel: Storable {
  static let targetStep = 3
  static let limitSeconds: TimeInterval = 10
  
  static var storageKey: String { return "mission" }
}
