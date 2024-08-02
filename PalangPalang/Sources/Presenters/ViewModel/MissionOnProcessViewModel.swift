//
//  MissionViewModel.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

@Observable
class MissionOnProcessViewModel {
  struct State {
    
  }
  
  enum Action {
    
  }
  
  private(set) var state: State = .init()
  private let useCase: MissionOnProcess = AlarmUseCase.shared
}
