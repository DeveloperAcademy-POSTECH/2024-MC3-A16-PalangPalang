import SwiftUI

struct AppView: View {
  let appStatus: AlarmStaus = AlarmUseCase.shared
  
  var body: some View {
    switch appStatus.alarmStatus {
    case .main:
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
