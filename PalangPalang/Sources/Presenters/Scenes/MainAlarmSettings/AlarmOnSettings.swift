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
      //Text(alarmViewModel.state.alarm.isAM ? "AM" : "PM")
      
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
          Text("설정완료")
        }
      )
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
      Picker("시간", selection: $alarm.hour) {
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
