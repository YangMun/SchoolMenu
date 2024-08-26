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

func runUpdateIfNeeded() {
    let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    
    if hasLaunchedBefore {
        // 사용자가 이전에 앱을 실행한 적이 있으면 업데이트 실행
        checkAndUpdateMenu()
    } else {
        // 첫 실행 시 플래그를 설정하고 업데이트 실행 건너뛰기
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        print("첫 실행, checkAndUpdateMenu() 건너뜀")
    }
}

@main
struct YeonsungApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainSelectView()
                .onAppear {
                    runUpdateIfNeeded()
                }
        }
    }
}
