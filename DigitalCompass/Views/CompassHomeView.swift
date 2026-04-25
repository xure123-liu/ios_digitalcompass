import SwiftUI

struct CompassHomeView: View {
    @EnvironmentObject var settings: AppSettings
    @EnvironmentObject var compassManager: CompassManager
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @EnvironmentObject var qiblaManager: QiblaManager
    
    @State private var showSettings = false
    @State private var showHelp = false
    @State private var showCalibration = false
    @State private var showQibla = false
    @State private var showSubscription = false
    
    var colors: AppColors { settings.themeColors }
    
    var body: some View {
        ZStack {
            colors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerBar
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        directionDisplay
                        compassDial
                        accuracyStatus
                        actionButtons
                        bottomDisclaimer
                    }
                    .padding(.vertical, 20)
                }
            }
        }
        .navigationDestination(isPresented: $showSettings) {
            SettingsView()
        }
        .navigationDestination(isPresented: $showCalibration) {
            CalibrationView()
        }
        .navigationDestination(isPresented: $showQibla) {
            QiblaView()
        }
        .sheet(isPresented: $showSubscription) {
            SubscriptionView()
        }
        .sheet(isPresented: $showHelp) {
            HelpView()
        }
        .onAppear {
            compassManager.setSettings(settings)
            compassManager.startUpdates()
        }
        .onDisappear {
            compassManager.stopUpdates()
        }
    }
    
    private var headerBar: some View {
        HStack {
            Text(settings.localizedString("app_name"))
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(colors.textPrimary)
            
            Spacer()
            
            Button(action: { showSettings = true }) {
                Image(systemName: "gear")
                    .font(.system(size: 20))
                    .foregroundColor(colors.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(colors.backgroundTertiary)
                    .clipShape(Circle())
            }
            
            Button(action: { showHelp = true }) {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 20))
                    .foregroundColor(colors.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(colors.backgroundTertiary)
                    .clipShape(Circle())
            }
        }
    }
    
    private var directionDisplay: some View {
        VStack(spacing: 8) {
            Text(settings.localizedString("current_direction") + ": " + compassManager.directionDisplayName())
                .font(.system(size: 18))
                .foregroundColor(colors.textSecondary)
            
            Text(String(format: "%03.0f°", compassManager.heading))
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(colors.textPrimary)
                .monospacedDigit()
        }
    }
    
    private var compassDial: some View {
        ZStack {
            Circle()
                .fill(colors.backgroundSecondary)
                .frame(width: 300, height: 300)
                .overlay(
                    Circle()
                        .stroke(colors.strokePrimary, lineWidth: 4)
                )
            
            Circle()
                .fill(Color(hex: "#16162A"))
                .frame(width: 260, height: 260)
                .overlay(
                    Circle()
                        .stroke(Color(hex: "#5A5A7A"), lineWidth: 2)
                )
            
            compassDirections
            
            needle
        }
        .frame(width: 300, height: 300)
    }
    
    private var compassDirections: some View {
        ZStack {
            Text("N")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color(hex: "#FF5252"))
                .offset(y: -125)
            
            Text("S")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(colors.textSecondary)
                .offset(y: 125)
            
            Text("E")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(colors.textSecondary)
                .offset(x: settings.isRTL ? -125 : 125)
            
            Text("W")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(colors.textSecondary)
                .offset(x: settings.isRTL ? 125 : -125)
        }
    }
    
    private var needle: some View {
        ZStack {
            Rectangle()
                .fill(Color(hex: "#00E676"))
                .frame(width: 4, height: 140)
            
            Circle()
                .fill(Color(hex: "#FF5252"))
                .frame(width: 16, height: 16)
        }
        .rotationEffect(.degrees(-compassManager.heading))
    }
    
    private var accuracyStatus: some View {
        VStack(spacing: 8) {
            ZStack(alignment: settings.isRTL ? .trailing : .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(compassManager.accuracyStatus.color.opacity(0.25))
                    .frame(width: 120, height: 6)
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(compassManager.accuracyStatus.color)
                    .frame(width: 120 * compassManager.accuracyPercentage, height: 6)
            }
            .frame(width: 120)
            
            Text(settings.localizedString("accuracy_status") + ": " + settings.localizedString(compassManager.accuracyStatus.localizedKey))
                .font(.system(size: 14))
                .foregroundColor(compassManager.accuracyStatus.color)
            
            if settings.isAccuracyTipsEnabled {
                Text(settings.localizedString("avoid_interference"))
                    .font(.system(size: 12))
                    .foregroundColor(colors.textTertiary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button(action: { showCalibration = true }) {
                HStack(spacing: 4) {
                    Image(systemName: "target")
                    Text(settings.localizedString("calibrate"))
                }
                .font(.system(size: 14))
                .foregroundColor(colors.textPrimary)
                .frame(width: 100, height: 44)
                .background(colors.backgroundTertiary)
                .cornerRadius(22)
            }
            
            Button(action: { showQibla = true }) {
                HStack(spacing: 4) {
                    Image(systemName: "location")
                    Text(settings.localizedString("qibla"))
                }
                .font(.system(size: 14))
                .foregroundColor(colors.textPrimary)
                .frame(width: 120, height: 44)
                .background(colors.backgroundTertiary)
                .cornerRadius(22)
            }
            
            Button(action: { showSubscription = true }) {
                HStack(spacing: 4) {
                    Image(systemName: "crown.fill")
                    Text("Pro")
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(colors.backgroundPrimary)
                .frame(width: 110, height: 44)
                .background(colors.accentPrimary)
                .cornerRadius(22)
            }
        }
    }
    
    private var bottomDisclaimer: some View {
        Text(settings.localizedString("disclaimer"))
            .font(.system(size: 12))
            .foregroundColor(colors.textTertiary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
    }
}

#Preview {
    CompassHomeView()
        .environmentObject(AppSettings())
        .environmentObject(SubscriptionManager())
        .environmentObject(CompassManager())
        .environmentObject(QiblaManager())
}
