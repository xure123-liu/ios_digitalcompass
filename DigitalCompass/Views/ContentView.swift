import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: AppSettings
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    
    @State private var showOnboarding = false
    @State private var showLaunchSubscription = false
    
    var body: some View {
        NavigationStack {
            CompassHomeView()
        }
        .environment(\.layoutDirection, settings.isRTL ? .rightToLeft : .leftToRight)
        .id("\(settings.selectedLanguage.rawValue)-\(settings.isRTL ? "rtl" : "ltr")")
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView {
                completeOnboardingFlow()
            }
            .environmentObject(settings)
        }
        .sheet(isPresented: $showLaunchSubscription) {
            SubscriptionView()
        }
        .onAppear(perform: evaluateOnboardingAndColdStartSubscription)
    }
    
    private func evaluateOnboardingAndColdStartSubscription() {
        if !settings.hasCompletedOnboarding {
            showOnboarding = true
            return
        }
        presentColdStartSubscriptionIfNeeded()
    }
    
    private func completeOnboardingFlow() {
        showOnboarding = false
        settings.hasCompletedOnboarding = true
        AppDelegate.shouldPresentSubscriptionOnColdStart = false
        guard !subscriptionManager.isPro else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            showLaunchSubscription = true
        }
    }
    
    private func presentColdStartSubscriptionIfNeeded() {
        guard AppDelegate.shouldPresentSubscriptionOnColdStart else { return }
        AppDelegate.shouldPresentSubscriptionOnColdStart = false
        guard !subscriptionManager.isPro else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard !subscriptionManager.isPro else { return }
            showLaunchSubscription = true
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppSettings())
        .environmentObject(SubscriptionManager())
        .environmentObject(CompassManager())
        .environmentObject(QiblaManager())
}
