import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var settings: AppSettings
    @State private var page = 0
    
    let onComplete: () -> Void
    
    private var pageCount = 3
    
    var body: some View {
        ZStack {
            Color(hex: "#1A1A2E")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $page) {
                    OnboardingPage(
                        title: settings.localizedString("onboarding_title_1"),
                        bodyText: settings.localizedString("onboarding_body_1"),
                        systemImage: "location.north.circle.fill"
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        title: settings.localizedString("onboarding_title_2"),
                        bodyText: settings.localizedString("onboarding_body_2"),
                        systemImage: "waveform.path.ecg"
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        title: settings.localizedString("onboarding_title_3"),
                        bodyText: settings.localizedString("onboarding_body_3"),
                        systemImage: "location.fill.viewfinder"
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .tint(Color(hex: "#00E676"))
                
                HStack {
                    if page < pageCount - 1 {
                        Button(action: { onComplete() }) {
                            Text(settings.localizedString("onboarding_skip"))
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "#8A8AA0"))
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
                
                if page < pageCount - 1 {
                    Button(action: { withAnimation { page += 1 } }) {
                        Text(settings.localizedString("onboarding_next"))
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "#1A1A2E"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(hex: "#00E676"))
                            .cornerRadius(28)
                    }
                    .padding(.horizontal, 24)
                } else {
                    Button(action: { onComplete() }) {
                        Text(settings.localizedString("onboarding_get_started"))
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "#1A1A2E"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(hex: "#00E676"))
                            .cornerRadius(28)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .padding(.bottom, 40)
        }
    }
}

private struct OnboardingPage: View {
    let title: String
    let bodyText: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: systemImage)
                .font(.system(size: 72))
                .foregroundColor(Color(hex: "#00E676"))
                .padding(.top, 60)
            
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Text(bodyText)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#8A8AA0"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(onComplete: {})
        .environmentObject(AppSettings())
}
