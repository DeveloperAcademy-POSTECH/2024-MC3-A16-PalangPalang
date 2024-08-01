import SwiftUI

struct AppView: View {
  let appState = AlarmUseCase.shared
  
  var body: some View {
    switch appState.alarmState {
    case .alarmOnSettings:
      AlarmMainView()
    case .alarmOnProcess:
      AlarmOnProcessView()
    case .missionOnProcess:
      MissionOnProcessView()
    case .missionTimeout:
      MissionTimeoutView()
    }
  }
}

#Preview {
  AlarmMainView()
}
