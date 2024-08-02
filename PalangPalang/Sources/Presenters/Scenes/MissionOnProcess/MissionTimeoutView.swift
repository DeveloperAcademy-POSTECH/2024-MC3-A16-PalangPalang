//
//  MissionTimeoutView.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

struct MissionTimeoutView: View {
  var body: some View {
    Button {
      AlarmUseCase.shared.deleteAlarm()
    } label: {
      Text("MissionTimeoutView - 알림삭제")
    }
  }
}

#Preview {
  MissionTimeoutView()
}
