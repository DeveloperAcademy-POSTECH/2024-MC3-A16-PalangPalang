//
//  MissionTimeoutView.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

struct MissionTimeoutView: View {
  let useCase: MissionCompleted
  
  var body: some View {
    Button {
      useCase.endAlarm()
    } label: {
      Text("시간오버~ - 알림삭제")
    }
  }
}

#Preview {
  MissionTimeoutView(useCase: AlarmUseCase())
}
