//
//  MissionOnProcessView.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

//import SwiftUI
//
//struct MissionOnProcessView: View {
//  let viewModel: MissionOnProcessViewModel
//
//  var body: some View {
//    VStack {
//      Text("이 시간 안에 도망가시옹 \(viewModel.state.timerM):\(viewModel.state.timerS)")
//      Text("\(viewModel.state.nowSteps)")
//    }
//    .onAppear {
//      viewModel.effect(action: ._onAppear)
//    }
//    .onDisappear {
//      viewModel.effect(action: ._onDisappear)
//    }
//  }
//}
//
//#Preview {
//  MissionOnProcessView(viewModel: .init(useCase: AlarmUseCase.init()))
//}

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
      
      Image("MissionOnPrecessGhost")
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
    HStack(spacing: 0){
      ZStack{
        Image("RemainingStepCircle")
          .resizable()
          .frame(maxWidth: .infinity, maxHeight: 196)
        
        HStack(spacing: 9){
          Rectangle()
            .fill(.palangButton02)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(maxWidth: 90, maxHeight: 72)
            .overlay {
              Text("\(viewModel.state.nowSteps)")
                .palangFont(.numH4)
            }
          
          Text("걸음")
            .palangFont(.textH2)
            .foregroundStyle(.palangText00)
        }
      }
    }
  }
}
