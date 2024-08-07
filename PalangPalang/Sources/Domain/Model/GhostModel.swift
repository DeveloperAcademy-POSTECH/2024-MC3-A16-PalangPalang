//
//  GhostModel.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/8/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

struct GhostModel: Identifiable {
  let id: UUID = .init()
  
  var position: CGPoint
  var velocity: CGPoint
  var isFlipped: Bool = false
  let image: Image
  
  init() {
    let newX = CGFloat.random(in: 61...(UIScreen.main.bounds.width - 61))
    let newY = CGFloat.random(in: 61...(UIScreen.main.bounds.height - 100))
    self.position = .init(x: newX, y: newY)
    self.velocity = .init(x: 1.0, y: 1.0)
    self.image = Bool.random() ? PalangPalangAsset.Assets.ghost1.swiftUIImage :PalangPalangAsset.Assets.ghost2.swiftUIImage
  }
  
  static let ghostSize: CGFloat = 60
}
