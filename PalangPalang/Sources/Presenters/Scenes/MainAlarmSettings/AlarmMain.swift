//
//  AlarmMain.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI
import UIKit

struct AlarmMain: View {
  @State private var ghostViewModels: [GhostViewModel] = []
  
  let alarmViewModel: AlarmSettingsViewModel
  private let screenWidth = UIScreen.main.bounds.width // uikit개념인 것 같아서 geometryreader를 써보려고 했는데 오히려 그게 더 코드 길어지는 것 같아서 그냥 이거 쓰려구해요!! 근데 궁금한게 import uikit안해도 되던데 그건 원래 그런건지? 궁금합니다.
  private let screenHeight = UIScreen.main.bounds.height
  
  var body: some View {
    
    ZStack{ // 이거를 alarmmain에 둔 이유는 alarmmainview에서는 이미 alarmmain과 alarmonsetting이라는 값을 분간하는 것 같아서 UI와 관련한 것들은 여기서 처리하는 것 같아서 처리했어요! 그리고 color부터 foreach를 따로 빼지 않은 이유는 
      Color(.palangYellow)
        .ignoresSafeArea()
        .onTapGesture {
          addGhost()
        }
      ForEach(ghostViewModels.indices, id: \.self) { index in // 아직 foreach 반복문을 이해하지 못해서 문법은 도움을 받았어요!
        let viewModel = ghostViewModels[index]
        GhostImage(viewModel: viewModel) // GhostImage라는 하위 뷰로 분리하여 관리하는게 더 낫다고 판단했습니다. 이미지와 관련한 값들을 받아야해서!
      }
      VStack{
        
        Spacer()
        Clock(alarm: alarmViewModel.state.alarm)
        
        Button(
          action: {
            alarmViewModel.effect(action: .tappedSettingsButton)
          },
          label: {
            Text("설정하기")
          }
        )
        
        Spacer()
        
        Button(
          action: {
            alarmViewModel.effect(action: .tappedStartAlarm)
          },
          label: {
            Text("시작하기")
          }
        )
        .disabled(!alarmViewModel.state.readyForStart)
      }
      }
  }
  
  private func addGhost() { // 이 친구는 view에서 더 직접적인 친구라고 생각해서 여기에 넣었어요 어차피 로직 바뀔 것 같아서!?
    let randomX = CGFloat.random(in: 61...(screenWidth - 61))
    let randomY = CGFloat.random(in: 61...(screenHeight - 100))
    let randomImage = Bool.random() ? "ghost1" : "ghost2"
    
    let newGhostViewModel = GhostViewModel(initialPosition: CGPoint(x: randomX, y: randomY), imageName: randomImage)
    
    ghostViewModels.append(newGhostViewModel)
  }
}

#Preview {
  AlarmMain(alarmViewModel: .init(useCase: AlarmUseCase.init()))
}

private struct Clock: View {
  let alarm: AlarmSettingsModel
  
  var body: some View {
    HStack {
      Text("\(alarm.hour)")
      Text(":")
      Text("\(alarm.minutes)")
    }
  }
}

private struct GhostImage: View { //Ghostview로 따로 빼서 관리
  @ObservedObject var viewModel: GhostViewModel
  
  var body: some View {
    Image(viewModel.imageName)
      .resizable()
      .frame(width: 61, height: 59)
      .scaleEffect(x: viewModel.isFlipped ? -1 : 1, anchor: .center) // 좌우 반전을 위한 모디파이어? 라고 부르는거 맞나
      .position(viewModel.position)
  }
}
