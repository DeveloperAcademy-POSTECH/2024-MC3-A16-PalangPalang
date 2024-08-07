//
//  MissionCompletedView.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

struct MissionCompletedView: View {
  @State private var remaingMinutes: String = "0"
  let useCase: MissionCompleted
  
  var body: some View {
    VStack(spacing: 0) {
      Spacer()
      
      Text("생각 귀신\n돌파에 성공했어요!")
        .multilineTextAlignment(.center)
        .palangFont(.textBody01Bold)
        .foregroundStyle(.palangText00)
        .padding(.bottom, 22)
      
      Text("생각 귀신 Get")
        .palangFont(.textBody02)
        .foregroundStyle(.palangGray)
      
      TwinkleGhost()
        .padding(.bottom, -10)
      
      Text("\(remaingMinutes)분 몰입했어요")
        .palangFont(.textH2)
        .foregroundStyle(.palangText00)
        .padding(.bottom, 133)
      
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
      .foregroundColor(.palangWhite)
      .background(.palangGray)
      .cornerRadius(16)
      .padding(.horizontal, 44)
      .padding(.bottom, 55)
    }
    .frame(maxWidth: .infinity)
    .frame(maxHeight: .infinity)
    .ignoresSafeArea()
    .background(
      ZStack {
        Color.palangGray
          .ignoresSafeArea()
        
        YellowLight()
        .position(x: UIScreen.main.bounds.width / 2 - 2, y: 800)
      }
    )
    .onAppear {
      guard let dateMin = useCase.missionOnProcessMinutes() else { return }
      remaingMinutes = dateMin
    }
  }
}

#Preview {
  MissionCompletedView(useCase: AlarmUseCase())
}


private struct YellowLight: View {
  @State private var moveDistance: CGFloat = 0 // 이동 거리
  var body: some View {
    ZStack {
      TrianglePath(moveDistance: moveDistance)
        .foregroundStyle(.palangYellow)
        .frame(height: 3000)
        .scaleEffect(x: -1, y: 1)
        .offset(x: 1)
        .animation(
          .easeInOut(duration: 1),
          value: moveDistance
        )
      
      TrianglePath(moveDistance: moveDistance)
        .foregroundStyle(.palangYellow)
        .frame(height: 3000)
        .offset(x: -1)
        .animation(.easeInOut(duration: 1), value: moveDistance)
    }
    .onAppear {
      withAnimation(.easeInOut(duration: 0.4)) {
        moveDistance = 200 // 선 길이를 10으로 증가
      }
    }
  }
}

private struct TrianglePath: Shape {
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

private struct TwinkleGhost: View {
  
  var body: some View {
    PalangPalangAsset.Assets.ghostOpenEyes.swiftUIImage
      .resizable()
      .scaledToFit()
      .frame(width: 101)
      .scaleEffect(x: -1, y: 1, anchor: .center) // x축을 반전
      .overlay(
        alignment: .topTrailing,
        content: {
          Twinkle()
            .offset(x: 30, y: -20)
        }
      )
      .overlay(
        alignment: .topLeading,
        content: {
          Twinkle()
            .offset(x: -35, y: 22)
        }
      )
      .overlay(
        alignment: .bottomTrailing,
        content: {
          Twinkle()
            .offset(x: 30, y: 12)
        }
      )
      .frame(width: 184)
      .frame(height: 300)
  }
}

private struct Twinkle: View {
  var body: some View {
    LottieView(
      animationFileName: "GetGhost",
      loopMode: .playOnce
    )
    .frame(width: 20, height: 20)
  }
}
