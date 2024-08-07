//
//  AlarmMain.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

struct AlarmMain: View {
  let alarmViewModel: AlarmSettingsViewModel
  @State private var isViewAppeared = false
  
  var body: some View {
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
            .frame(maxWidth: .infinity, maxHeight: 60)
        }
      )
      .palangFont(.textBody02)
      .foregroundColor(!alarmViewModel.state.readyForStart ? .palangText03 : .palangWhite)
      .background(!alarmViewModel.state.readyForStart ? .palangButton02 : .palangGray)
      .cornerRadius(16)
      .padding(.horizontal, 45)
      .padding(.bottom, 55)
      .disabled(!alarmViewModel.state.readyForStart)
    }
    .frame(maxWidth: .infinity)
    .background(.palangYellow)
    .ignoresSafeArea()
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
