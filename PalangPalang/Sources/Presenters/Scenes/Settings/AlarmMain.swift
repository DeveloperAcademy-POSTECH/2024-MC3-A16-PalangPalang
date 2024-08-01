//
//  AlarmMain.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

struct AlarmMain: View {
  let alarmViewModel: AlarmViewModel

  var body: some View {
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

#Preview {
  AlarmMain(alarmViewModel: .init())
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
