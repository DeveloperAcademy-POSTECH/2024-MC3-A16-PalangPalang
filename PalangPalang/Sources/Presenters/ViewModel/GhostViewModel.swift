//
//  GhostViewModel.swift
//  PalangPalang
//
//  Created by 조민  on 8/7/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI
import Foundation

@Observable
class GhostViewModel {
  struct State {
    var allGhost: [GhostModel] = []
  }
  
  enum Action {
    case _onAppear
    case _ghostMoving
  }

  private var timer: Timer?
  private let bottomBoundaryoffset: CGFloat = 59 // 유령이 바닥의 경계를 침범하지 않도록 막는 역할
  private let screenWidth = UIScreen.main.bounds.width
  private let screenHeight = UIScreen.main.bounds.height
  
  private(set) var state: State = .init()
  private let useCase: ReadMissionCount
  
  init(useCase: ReadMissionCount) {
    self.useCase = useCase
  }
  
  deinit {
    timer?.invalidate()
  }
  
  func effect(_ action: Action) {
    switch action {
    case ._onAppear:
      if let count = useCase.readMissionCount() {
        state.allGhost = (0..<count).map{ _ in .init() }
        startTimer()
      }
      
    case ._ghostMoving:
      state.allGhost = state.allGhost.map { moveGhost($0) }
    }
  }
  
  private func startTimer() {
    self.timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] _ in
      self?.effect(._ghostMoving)
    }
  }

  private func moveGhost(_ ghost: GhostModel) -> GhostModel { //얘는 여기서만 알아도 되는 로직이라 private를 사용했고, 로직은 지피티의 도움을 받았음!
    var newGhost = ghost
    let ghostSize = GhostModel.ghostSize
    let velocity = ghost.velocity
    let position = ghost.position
    
    let newPosition = CGPoint(x: position.x + velocity.x, y: position.y + velocity.y)
    let halfGhostSize = ghostSize / 2
    
    if newPosition.x <= halfGhostSize || newPosition.x >= screenWidth - halfGhostSize {
      newGhost.velocity.x *= -1
      newGhost.isFlipped.toggle() // 이미지 반전 상태를 토글
    }
    
    if newPosition.y <= halfGhostSize || newPosition.y >= screenHeight - halfGhostSize - bottomBoundaryoffset {
      newGhost.velocity.y *= -1
    }
    
    newGhost.position = newPosition
    
    return newGhost
  }
}
