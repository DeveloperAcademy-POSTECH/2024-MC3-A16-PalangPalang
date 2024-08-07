//
//  MissionOnProcessView.swift
//  PalangPalang
//
//  Created by 조민 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

struct MissionOnProcessView: View {
  let viewModel: MissionOnProcessViewModel
  
  var body: some View {
    VStack(spacing: 0) {
      
      Text("남은 시간 안에 \n생각 귀신을 이겨내세요!")
        .palangFont(.textH1)
        .foregroundStyle(.palangYellow)
        .multilineTextAlignment(.center)
        .padding(.top, 47)
      
      PalangPalangAsset.Assets
        .missionOnPrecessGhost.swiftUIImage
        .resizable()
        .frame(width: 266, height: 310)
        .padding(.top, 55)
      
      Rectangle()
        .fill(.palangGray01)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .frame(width: 145, height: 60)
        .overlay {
          Text("\(viewModel.state.timerM):\(viewModel.state.timerS)")
            .palangFont(.textH1)
            .foregroundStyle(.palangYellow)
            .multilineTextAlignment(.center)
        }
        .padding(.top, 29)
      
      Spacer()
      
      RemainingStepText(viewModel: viewModel)
    }
    .background(.palangGray)
    .ignoresSafeArea(.all, edges: .bottom)
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

struct RemainingStepText: View {
  let viewModel: MissionOnProcessViewModel
  
  var body: some View {
    ZStack {
      PalangPalangAsset.Assets
        .remainingStepCircle.swiftUIImage
        .resizable()
        .frame(maxWidth: .infinity, maxHeight: 196)
      
      HStack(spacing: 9) {
        Text("\(viewModel.state.nowSteps)")
          .palangFont(.numH4)
          .padding(.horizontal, 17)
          .padding(.vertical, 7.5)
          .background(
            RoundedRectangle(cornerRadius: 16)
              .fill(.palangButton02)
          )
        
        Text("걸음")
          .palangFont(.textH2)
          .foregroundStyle(.palangText00)
      }
    }
  }
}
