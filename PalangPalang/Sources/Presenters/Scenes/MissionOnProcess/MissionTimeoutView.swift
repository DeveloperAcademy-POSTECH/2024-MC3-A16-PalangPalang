//
//  MissionTimeoutView.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

struct MissionTimeoutView: View {
  let useCase: MissionCompleted
  
  var body: some View {
    ZStack(alignment: .top) {
      
      SmallTwoGhost()
      
      InfoLabelAndGoToHomeInfo(useCase: useCase)
    }
    .background {
      BigBackGroundGhost()
    }
    .background(.palangGray)
  }
}

private struct SmallTwoGhost: View {
  var body: some View {
    HStack {
      PalangPalangAsset.Assets.finalGhostLeading.swiftUIImage
        .padding(.leading, 34)
        .padding(.top, 28)
      
      Spacer()
      
      PalangPalangAsset.Assets.finalGhostTrailing.swiftUIImage
        .padding(.trailing, 36)
        .padding(.top, 87)
    }
  }
}

private struct InfoLabelAndGoToHomeInfo: View {
  let useCase: MissionCompleted
  
  var body: some View {
    VStack {
      
      Spacer()
      Text("생각 귀신에게\n먹혔어요")
        .palangFont(.textH1)
        .foregroundStyle(.palangGray)
        .multilineTextAlignment(.center)
        .padding(.bottom, 21)
      
      Text("다음엔 꼭 생각귀신을 돌파해보세요!")
        .palangFont(.textCaption02)
        .foregroundStyle(.palangGray)
        .padding(.bottom, 75)
      
      Button(
        action: {
          useCase.endAlarm()
        },
        label: {
          Text("메인으로")
            .frame(maxWidth: .infinity)
            .frame(height: 60)
        }
      )
      .palangFont(.textBody02)
      .foregroundColor(.palangText00)
      .background(.palangYellow)
      .cornerRadius(16)
      .padding(.horizontal, 44)
      .padding(.bottom, 55)
    }
    .ignoresSafeArea()
  }
}

private struct BigBackGroundGhost: View {
  var body: some View {
    VStack {
      Spacer()
      
      PalangPalangAsset.Assets
        .missionOnPrecessGhost.swiftUIImage
        .resizable()
        .scaledToFit()
        .frame(width: 637)
        .offset(y: 150)
    }
  }
}

#Preview {
  MissionTimeoutView(useCase: AlarmUseCase())
}
