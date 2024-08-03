//
//  MissionCompletedView.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

struct MissionCompletedView: View {
  let useCase: MissionCompleted
  
  var body: some View {
    Button(
      action: {
        useCase.endAlarm()
      },
      label: {
        Text("귀신을 이겨냈어영!!")
      }
    )
  }
}

#Preview {
  MissionCompletedView(useCase: AlarmUseCase())
}
