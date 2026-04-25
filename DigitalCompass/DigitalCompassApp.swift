import SwiftUI

@main
struct DigitalCompassApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appSettings = AppSettings()
    @StateObject private var subscriptionManager = SubscriptionManager()
    @StateObject private var compassManager = CompassManager()
    @StateObject private var qiblaManager = QiblaManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appSettings)
                .environmentObject(subscriptionManager)
                .environmentObject(compassManager)
                .environmentObject(qiblaManager)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    /// Set to `true` only in `application(_:didFinishLaunchingWithOptions:)` (new process / cold start).
    static var shouldPresentSubscriptionOnColdStart = false
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        AppDelegate.shouldPresentSubscriptionOnColdStart = true
        return true
    }
}
