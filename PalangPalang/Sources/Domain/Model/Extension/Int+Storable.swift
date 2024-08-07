//
//  Int+Storage.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/8/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

extension Int: Storable {
  static var storageKey: String {
    return "IntStorageKey"
  }
}
