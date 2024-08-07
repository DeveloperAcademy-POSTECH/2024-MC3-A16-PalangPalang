import SwiftUI

struct AppView: View {
  private let _alarmUseCase: AlarmUseCase
  private var appStatus: AlarmStaus {
    return _alarmUseCase
  }
  
  init(alarmUseCase: AlarmUseCase) {
    self._alarmUseCase = alarmUseCase
  }
  
  var body: some View {
    switch appStatus.alarmStatus {
    case .mainAlarmSettings:
      AlarmMainView(alarmViewModel: .init(useCase: _alarmUseCase), ghostViewModel: .init(useCase: _alarmUseCase))
    case .alarmOnProcess:
      AlarmOnProcessView(viewModel: .init(useCase: _alarmUseCase))
    case .missionOnProcess:
      MissionOnProcessView(viewModel: .init(useCase: _alarmUseCase))
    case .missionTimeout:
      MissionTimeoutView(useCase: _alarmUseCase)
    case .missionCompleted:
      MissionCompletedView(useCase: _alarmUseCase)
    }
  }
}

#Preview {
  AppView(alarmUseCase: AlarmUseCase())
}
