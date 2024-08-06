//
//  MissionOnProcessView.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

struct MissionOnProcessView: View {
  let viewModel: MissionOnProcessViewModel
  
  var body: some View {
    VStack {
      Text("이 시간 안에 도망가시옹 \(viewModel.state.timerM):\(viewModel.state.timerS)")
      Text("\(viewModel.state.nowSteps)")
    }
    .onAppear {
      viewModel.effect(action: ._onAppear)
    }
    .onDisappear {
      viewModel.effect(action: ._onDisappear)
    }
  }
}

#Preview {
  MissionOnProcessView(viewModel: .init(useCase: AlarmUseCase.init()))
}
