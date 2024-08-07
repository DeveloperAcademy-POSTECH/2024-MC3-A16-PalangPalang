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
  @State private var ghostViewModels: [GhostViewModel] = [] // 수정 🥰
  
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
      
      VStack {
        Spacer()
      
        Text(alarmViewModel.state.alarm.isAM ? "AM":"PM")
          .foregroundStyle(.palangGray)
          .palangFont(.textBody01Bold)
      
        Clock(alarm: alarmViewModel.state.alarm)
          .padding(.bottom, 10)
      
        Button(
          action: {
            alarmViewModel.effect(action: .tappedSettingsButton)
          },
          label: {
           SettingButton()
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
        .palangFont(.textBody02)
        .foregroundColor(!alarmViewModel.state.readyForStart ? .palangText03 : .palangWhite)
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(!alarmViewModel.state.readyForStart ? .palangButton02 : .palangGray)
        .cornerRadius(16)
        .padding(.horizontal, 45)
        .padding(.bottom,55)
        .disabled(!alarmViewModel.state.readyForStart)
      }
    }
    .frame(maxWidth: .infinity)
    .background(.palangYellow)
    .ignoresSafeArea()
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

private struct SettingButton: View{
  
  var body: some View {
    
    HStack(spacing: 0) {
      
      Text("목표시간 설정하기")
        .palangFont(.textCaption01)
      
      Image(systemName: "chevron.right")
        .padding(.horizontal, 2)
        .fontWeight(.medium)
    }
    .foregroundColor(.palangText00)
    
  }
}

private struct Clock: View {
  let alarm: AlarmSettingsModel
  
  var body: some View {
    HStack(spacing: 7) {
      Text(alarm.set12Hour)
        .palangFont(.numH2)
      
      Text(":")
        .palangFont(.numSymbol02)
      
      Text("\(alarm.minutes)")
        .palangFont(.numH2)
    }
    .foregroundColor(.palangText00)
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
