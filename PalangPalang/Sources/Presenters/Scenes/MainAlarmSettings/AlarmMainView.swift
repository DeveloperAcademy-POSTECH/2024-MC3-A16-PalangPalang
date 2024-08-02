//
//  MainView.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

struct AlarmMainView: View {
  let alarmViewModel: AlarmSettingsViewModel = .init()
  
  var body: some View {
    VStack {
      if !alarmViewModel.state.onSettings {
        AlarmMain(alarmViewModel: alarmViewModel)
      } else {
        AlarmOnSettings(alarmViewModel: alarmViewModel)
      }
    }
  }
}

#Preview {
  AlarmMainView()
}
