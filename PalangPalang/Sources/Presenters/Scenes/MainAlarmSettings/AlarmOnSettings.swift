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
      ampmPicker(alarmViewModel: alarmViewModel)
      
      ClockSetting(alarm: .init(
        get: {alarmViewModel.state.alarm},
        set: { alarmViewModel.effect(action: .changeAlarm($0)) }
      )
      )
      .frame(height: 100)
      
      Button(
        action: {
          alarmViewModel.effect(action: .tappedSettingsDoneButton)
        },
        label: {
          Text("완료")
            .palangFont(.textBody01Bold)
            .foregroundColor(.palangWhite)
        }
      ).frame(maxWidth: .infinity, maxHeight: 60)
        .background(.palangGray)
        .cornerRadius(16)
        .padding(.horizontal,131)
      
    }.frame(maxHeight: .infinity)
    .background(.palangYellow01)
      
  }
}

#Preview {
  AlarmOnSettings(alarmViewModel: .init(useCase: AlarmUseCase.init()))
}

private struct ClockSetting: View {
  @Binding var alarm: AlarmSettingsModel
  
  var body: some View {
    HStack {
      Picker("시간", selection: $alarm.set12Hour) {
        ForEach(ValidHour.availableHours, id: \.self) { hour in
          Text(hour)
            .tag(hour)
        }
      }
      .pickerStyle(WheelPickerStyle())
      
      Picker("분", selection: $alarm.minutes) {
        ForEach(ValidMinutesOrSecond.availableMinutesOrSecond, id: \.self) { minute in
          Text(minute)
            .tag(minute)
        }
      }
      .pickerStyle(WheelPickerStyle())
    }
  }
}

private struct ampmPicker: View {
  @Bindable var alarmViewModel: AlarmSettingsViewModel
  
  var body: some View {
    HStack(spacing: 0){
      Button(action: {
        alarmViewModel.effect(action: .tappedAmButton)
      }, label: {
        Text("AM")
          .palangFont(.textBody01Bold)
          .foregroundColor(alarmViewModel.state.isAmTapped ? .palangGray : .palangText02)
      })
      .padding(.trailing,20)
      
      Button(action: {
        alarmViewModel.effect(action: .tappedPmButton)
      }, label: {
        Text("PM")
          .palangFont(.textBody01Bold)
          .foregroundColor(alarmViewModel.state.isAmTapped ? .palangText02 : .palangGray)
      })
    }
  }
}
