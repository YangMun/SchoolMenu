import SwiftUI
import GoogleMobileAds
import Firebase

class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    GADMobileAds.sharedInstance().start(completionHandler: nil)

    FirebaseApp.configure()
    return true
  }
}

@main
struct YeonsungApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AppStartView()
        }
    }
}
