//
//  Storable.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

protocol Storable: Codable {
  static var storageKey: String { get }
}
