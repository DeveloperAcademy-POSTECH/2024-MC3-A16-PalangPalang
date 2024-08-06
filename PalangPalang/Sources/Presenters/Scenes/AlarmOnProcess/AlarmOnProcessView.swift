//
//  AlarmOnProcessView.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

struct AlarmOnProcessView: View {
  
  let viewModel: AlarmOnProcessViewModel
  @State var deleteAlert: Bool = false
  
  var body: some View {
    VStack(spacing: 0) {
      
      Spacer()
      DueDateInfoText(dueTime: viewModel.state.dueTime)
        .padding(.bottom, 31)
      
      DueDataTimer(viewModel: viewModel)
        .padding(.bottom, 41)
      
      ZStack {
        let progressState = viewModel.state.progress
          PalangPalangAsset.Assets
            .progressBar1.swiftUIImage
            .opacity(progressState == .first ? 1 : 0)
        
          PalangPalangAsset.Assets
            .progressBar2.swiftUIImage
            .opacity(progressState == .second ? 1 : 0)

          PalangPalangAsset.Assets
            .progressBar3.swiftUIImage
            .opacity(progressState == .third ? 1 : 0)
        
          PalangPalangAsset.Assets
            .progressBar4.swiftUIImage
            .opacity(progressState == .fourth ? 1 : 0)
      }
      .frame(width: 393, height: 214)
      .animation(.smooth, value: viewModel.state.progress)
        .padding(.bottom, 61)
      
      
      Button(
        action: {
          deleteAlert = true
        },
        label: {
          PalangPalangAsset.Assets.cancealAlarmButton.swiftUIImage
            .resizable()
            .scaledToFit()
            .frame(width: 62)
        }
      )
      .padding(.bottom, 85)
    }
    .frame(maxHeight: .infinity)
    .background(.palangGray)
    .alert(isPresented: $deleteAlert) {
      Alert(
        title: Text("중단"),
        message: Text("알림을 중단하고 메인 화면으로 돌아갈까요?"),
        primaryButton: .default(Text("확인")) {
          viewModel.effect(action: .tappedAlarmCancel)
          deleteAlert = false
        },
        secondaryButton: .cancel(Text("취소")) {
          deleteAlert = false
        }
      )
    }
    .onAppear {
      viewModel.effect(action: ._onAppear)
    }
  }
}

private struct DueDateInfoText: View {
  let dueTime: String
  
  var body: some View {
    HStack(spacing: 0) {
      Text(dueTime)
        .palangFont(.textBody01Bold)
        .foregroundStyle(.palangYellow)
      Text("에 나가야 해...")
        .palangFont(.textBody01)
        .foregroundStyle(.palangWhite)
    }
  }
}

private struct DueDataTimer: View {
  let viewModel: AlarmOnProcessViewModel
  
  var body: some View {
    HStack(alignment: .top, spacing: 5) {
      Text(viewModel.state.timerH)
        .palangFont(.numH3)
      Text(":")
        .palangFont(.numSymbol03)
      Text(viewModel.state.timerM)
        .palangFont(.numH3)
      Text(":")
        .palangFont(.numSymbol03)
      Text(viewModel.state.timerS)
        .palangFont(.numH3)
    }
    .foregroundStyle(.palangYellow)
  }
}

#Preview {
  AlarmOnProcessView(viewModel: .init(useCase: AlarmUseCase.init()))
}
