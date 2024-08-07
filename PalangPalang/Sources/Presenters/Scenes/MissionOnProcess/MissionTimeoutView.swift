//
//  MissionTimeoutView.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

struct MissionTimeoutView: View {
  @State private var moveDistance: CGFloat = 0 // 이동 거리
  @State private var isTrailing = false
  @State private var lineLength: CGFloat = 0 // 초기 선 길이
  let useCase: MissionCompleted
  
  var body: some View {
    ZStack(alignment: .top) {
      
      HStack {
        PalangPalangAsset.Assets.finalGhostLeading.swiftUIImage
          .padding(.leading, 34)
          .padding(.top, 28)
        
        Spacer()
        
        PalangPalangAsset.Assets.finalGhostTrailing.swiftUIImage
          .padding(.trailing, 36)
          .padding(.top, 87)
      }
      
      VStack {
        
        Spacer()
        
        Text("생각 귀신에게\n먹혔어요")
          .palangFont(.textH1)
          .foregroundStyle(.gray)
          .multilineTextAlignment(.center)
          .padding(.bottom, 21)
        
        Text("다음엔 꼭 생각귀신을 돌파해보세요!")
          .palangFont(.textCaption02)
          .foregroundStyle(.gray)
          .padding(.bottom, 75)
        
        Button {
          useCase.endAlarm()
        } label: {
          Text("메인으로")
        }
      }
    }
    .background(.palangGray)
  }
}


struct TrianglePath: Shape {
  var moveDistance: CGFloat
  
  // 애니메이션 가능한 데이터를 지정
  var animatableData: CGFloat {
    get { moveDistance }
    set { moveDistance = newValue }
  }
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    // A, B, C 좌표 설정
    let A = CGPoint(x: rect.midX, y: rect.minY)
    let B = CGPoint(x: rect.midX, y: rect.midY)
    let C = CGPoint(x: rect.midX + moveDistance, y: rect.midY)
    
    path.move(to: A)
    path.addLine(to: B)
    path.addLine(to: C)
    path.addLine(to: A)
    
    return path
  }
}

#Preview {
  MissionTimeoutView(useCase: AlarmUseCase())
}
