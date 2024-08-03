import SwiftUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  let alarmUseCase = AlarmUseCase()
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    
    
    let appView = AppView(alarmUseCase: alarmUseCase)
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = UIHostingController(rootView: appView)
    window?.makeKeyAndVisible()
    return true
  }
}
