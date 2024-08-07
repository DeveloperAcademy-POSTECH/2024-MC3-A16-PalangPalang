//
//  AlarmOnSettings.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

struct AlarmOnSettings: View {
  @Bindable var alarmViewModel: AlarmSettingsViewModel
  
  var body: some View {
    VStack {
      Spacer()
        .frame(height: 170)
      
      AmpmPicker(alarmViewModel: alarmViewModel)
        .padding(.bottom, 10)
      
      ClockSetting(
        alarm: .init(
          get: {alarmViewModel.state.alarm},
          set: { alarmViewModel.effect(action: .changeAlarm($0)) }
        )
      )
      .frame(height: 240)
      
      Button(
        action: {
          alarmViewModel.effect(action: .tappedSettingsDoneButton)
        },
        label: {
          Text("완료")
            .frame(maxWidth: .infinity, maxHeight: 60)
        }
      )
      .palangFont(.textBody01Bold)
      .foregroundColor(.palangWhite)
      .background(.palangGray)
      .cornerRadius(16)
      .padding(.horizontal, 131)
      .padding(.bottom, 145)
      .padding(.top, 90)
      
    }
    .frame(maxHeight: .infinity)
    .background(.palangYellow01)
    .ignoresSafeArea()
  }
}

#Preview {
  AlarmOnSettings(alarmViewModel: .init(useCase: AlarmUseCase.init()))
}

private struct ClockSetting: View {
  @Binding var alarm: AlarmSettingsModel
  
  var body: some View {
    HStack(spacing: 0) {
      CustomPicker(data: [ValidHour.availableHours], selection: $alarm.set12Hour)
        .frame(width: 130)
      
      Text(":")
        .palangFont(.numSymbol01)
        .foregroundColor(.palangText00)
        .padding(.bottom)
      
      CustomPicker(data: [ValidMinutesOrSecond.availableMinutesOrSecond], selection: $alarm.minutes)
        .frame(width: 130)
    }
  }
}

private struct AmpmPicker: View {
  @Bindable var alarmViewModel: AlarmSettingsViewModel
  
  var body: some View {
    HStack(spacing: 0) {
      Button(action: {
        alarmViewModel.effect(action: .tappedAmButton)
      },
      label: {
        Text("AM")
          .palangFont(.textBody01Bold)
          .foregroundColor(alarmViewModel.state.isAmTapped ? .palangGray : .palangText02)
      })
      .padding(.trailing, 20)
      
      Button(action: {
        alarmViewModel.effect(action: .tappedPmButton)
      },
      label: {
        Text("PM")
          .palangFont(.textBody01Bold)
          .foregroundColor(alarmViewModel.state.isAmTapped ? .palangText02 : .palangGray)
      })
    }
  }
}
