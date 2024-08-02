//
//  AlarmOnProcessViewModel.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

@Observable
class AlarmOnProcessViewModel {
  struct State {
    
  }
  
  enum Action {
    
  }
  
  private(set) var state: State = .init()
  private let useCase: AlarmOnProcess = AlarmUseCase.shared
}
