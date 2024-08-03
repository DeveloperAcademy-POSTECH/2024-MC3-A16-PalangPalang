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
      Text("이 시간 안에 도망가시옹 \(viewModel.state.timerH):\(viewModel.state.timerM)")
      Text("\(viewModel.state.nowSteps)")
      
      Button(
        action: {
          viewModel.effect(action: ._디리니를위한강제로스텝줄이기)
        },
        label: {
          Text("누르면 스텝 한 개씩 줄어드는 임시 버튼")
        }
      )
    }
    .task {
      viewModel.effect(action: ._onAppear)
    }
  }
}

#Preview {
  MissionOnProcessView(viewModel: .init(useCase: AlarmUseCase.init()))
}
