import SwiftUI
import CoreLocation

struct QiblaView: View {
    @EnvironmentObject var settings: AppSettings
    @EnvironmentObject var qiblaManager: QiblaManager
    @EnvironmentObject var compassManager: CompassManager
    @Environment(\.dismiss) var dismiss
    
    @State private var isRequestingLocation = false
    
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
                        directionInfo
                        qiblaCompass
                        rotationGuide
                        locationStatus
                        actionButtons
                        instructionText
                    }
                    .padding(.vertical, 20)
                }
            }
        }
        .onAppear {
            qiblaManager.setSettings(settings)
            qiblaManager.setCompassManager(compassManager)
            requestLocationIfNeeded()
        }
    }
    
    private var headerBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                HStack(spacing: 4) {
                    Image(systemName: settings.isRTL ? "arrow.right" : "arrow.left")
                    Text(settings.localizedString("back"))
                }
                .font(.system(size: 14))
                .foregroundColor(colors.textPrimary)
                .frame(height: 40)
                .padding(.horizontal, 12)
                .background(colors.backgroundTertiary)
                .cornerRadius(20)
            }
            
            Spacer()
            
            Text(settings.localizedString("qibla_title"))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(colors.textPrimary)
            
            Spacer()
            
            Color.clear
                .frame(width: 80, height: 40)
        }
    }
    
    private var directionInfo: some View {
        VStack(spacing: 8) {
            Text(settings.localizedString("current_heading") + ": " + compassManager.directionDisplayName() + " " + String(format: "%.0f°", compassManager.heading))
                .font(.system(size: 16))
                .foregroundColor(colors.textSecondary)
            
            Text(settings.localizedString("qibla_direction") + ": " + qiblaManager.qiblaDirectionText + " " + qiblaManager.formattedQiblaDirection)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(colors.accentPrimary)
        }
    }
    
    private var qiblaCompass: some View {
        ZStack {
            Circle()
                .fill(colors.backgroundSecondary)
                .frame(width: 280, height: 280)
                .overlay(
                    Circle()
                        .stroke(colors.strokePrimary, lineWidth: 4)
                )
            
            Circle()
                .fill(Color(hex: "#16162A"))
                .frame(width: 240, height: 240)
            
            qiblaDirections
            
            qiblaMarker
        }
        .frame(width: 280, height: 280)
    }
    
    private var qiblaDirections: some View {
        ZStack {
            Text("N")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(hex: "#FF5252"))
                .offset(y: -110)
            
            Text("S")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(colors.textSecondary)
                .offset(y: 110)
            
            Text("E")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(colors.textSecondary)
                .offset(x: settings.isRTL ? -110 : 110)
            
            Text("W")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(colors.textSecondary)
                .offset(x: settings.isRTL ? 110 : -110)
        }
    }
    
    private var qiblaMarker: some View {
        ZStack {
            Circle()
                .fill(colors.accentPrimary)
                .frame(width: 40, height: 40)
            
            Text("🕋")
                .font(.system(size: 20))
            
            Path { path in
                path.move(to: CGPoint(x: 20, y: -20))
                path.addLine(to: CGPoint(x: 30, y: 0))
                path.addLine(to: CGPoint(x: 20, y: -5))
                path.addLine(to: CGPoint(x: 10, y: 0))
                path.closeSubpath()
            }
            .fill(colors.accentOrange)
            .frame(width: 20, height: 20)
            .offset(y: -25)
        }
        .offset(
            x: CGFloat(sin(qiblaManager.qiblaDirection * .pi / 180) * 80),
            y: CGFloat(-cos(qiblaManager.qiblaDirection * .pi / 180) * 80)
        )
    }
    
    private var rotationGuide: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: abs(qiblaManager.rotationNeeded) < 5 ? "checkmark.circle.fill" : "arrow.up.arrow.down")
                    .foregroundColor(abs(qiblaManager.rotationNeeded) < 5 ? colors.accentPrimary : colors.accentOrange)
                
                Text(qiblaManager.rotationDirectionText)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(abs(qiblaManager.rotationNeeded) < 5 ? colors.accentPrimary : colors.accentOrange)
            }
            
            if abs(qiblaManager.rotationNeeded) >= 5 {
                Text(String(format: settings.localizedString("rotate_degrees_format"), abs(qiblaManager.rotationNeeded)))
                    .font(.system(size: 16))
                    .foregroundColor(colors.textSecondary)
            }
        }
    }
    
    private var locationStatus: some View {
        HStack(spacing: 4) {
            Image(systemName: locationStatusIcon)
                .foregroundColor(locationStatusColor)
            
            Text(settings.localizedString(qiblaManager.locationStatus.localizedKey))
                .font(.system(size: 12))
                .foregroundColor(locationStatusColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(locationStatusColor.opacity(0.15))
        .cornerRadius(16)
    }
    
    private var locationStatusIcon: String {
        switch qiblaManager.locationStatus {
        case .unknown, .loading:
            return "location.circle"
        case .authorized:
            return "checkmark.circle.fill"
        case .denied, .error:
            return "exclamationmark.circle.fill"
        }
    }
    
    private var locationStatusColor: Color {
        switch qiblaManager.locationStatus {
        case .unknown, .loading:
            return colors.textSecondary
        case .authorized:
            return colors.accentPrimary
        case .denied, .error:
            return colors.accentWarning
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button(action: { requestLocationIfNeeded() }) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.clockwise")
                    Text(settings.localizedString("reposition"))
                }
                .font(.system(size: 14))
                .foregroundColor(colors.textPrimary)
                .frame(width: 140, height: 48)
                .background(colors.backgroundTertiary)
                .cornerRadius(24)
            }
            
            Button(action: { dismiss() }) {
                HStack(spacing: 4) {
                    Image(systemName: "house.fill")
                    Text(settings.localizedString("back_to_home"))
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(colors.backgroundPrimary)
                .frame(width: 140, height: 48)
                .background(colors.accentPrimary)
                .cornerRadius(24)
            }
        }
    }
    
    private var instructionText: some View {
        Text(settings.localizedString("qibla_instruction"))
            .font(.system(size: 12))
            .foregroundColor(colors.textTertiary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
    }
    
    private func requestLocationIfNeeded() {
        guard !isRequestingLocation else { return }
        isRequestingLocation = true
        qiblaManager.requestLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isRequestingLocation = false
        }
    }
}

#Preview {
    QiblaView()
        .environmentObject(AppSettings())
        .environmentObject(QiblaManager())
        .environmentObject(CompassManager())
}
