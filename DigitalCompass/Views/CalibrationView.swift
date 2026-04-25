import SwiftUI

struct CalibrationView: View {
    @EnvironmentObject var settings: AppSettings
    @EnvironmentObject var compassManager: CompassManager
    @Environment(\.dismiss) var dismiss
    
    @State private var isAnimating = false
    @State private var progressTimer: Timer?
    
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
                        instructionText
                        figure8Animation
                        stepsList
                        calibrationProgress
                        actionButtons
                    }
                    .padding(.vertical, 20)
                }
            }
        }
        .onAppear {
            compassManager.startCalibration()
            startAnimation()
        }
        .onDisappear {
            progressTimer?.invalidate()
            progressTimer = nil
            compassManager.finishCalibration()
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
            
            Text(settings.localizedString("calibration_title"))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(colors.textPrimary)
            
            Spacer()
            
            Color.clear
                .frame(width: 80, height: 40)
        }
    }
    
    private var instructionText: some View {
        Text(settings.localizedString("calibration_instruction"))
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(colors.textPrimary)
            .multilineTextAlignment(.center)
    }
    
    private var figure8Animation: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(colors.backgroundSecondary)
                .frame(width: 280, height: 200)
            
            HStack(spacing: 8) {
                figure8Ring(isLeft: true)
                figure8Ring(isLeft: false)
            }
            
            phoneIcon
        }
        .frame(width: 280, height: 200)
    }
    
    private func figure8Ring(isLeft: Bool) -> some View {
        Ellipse()
            .stroke(colors.strokePrimary, lineWidth: 3)
            .frame(width: 100, height: 140)
    }
    
    private var phoneIcon: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(colors.accentPrimary)
            .frame(width: 50, height: 80)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .fill(colors.backgroundPrimary)
                    .frame(width: 40, height: 60)
            )
            .rotationEffect(.degrees(isAnimating ? 15 : -15))
            .offset(x: isAnimating ? (settings.isRTL ? -30 : 30) : (settings.isRTL ? 30 : -30))
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            .onAppear {
                withAnimation {
                    isAnimating = true
                }
            }
    }
    
    private var stepsList: some View {
        VStack(alignment: settings.isRTL ? .trailing : .leading, spacing: 12) {
            stepRow(number: 1, text: settings.localizedString("calibration_step1"))
            stepRow(number: 2, text: settings.localizedString("calibration_step2"))
            stepRow(number: 3, text: settings.localizedString("calibration_step3"))
        }
        .frame(maxWidth: .infinity, alignment: settings.isRTL ? .trailing : .leading)
        .padding(.horizontal, 32)
    }
    
    private func stepRow(number: Int, text: String) -> some View {
        HStack(spacing: 8) {
            if settings.isRTL {
                Text(text)
                    .font(.system(size: 14))
                    .foregroundColor(colors.textPrimary)
                Text("\(number).")
                    .font(.system(size: 14))
                    .foregroundColor(colors.textPrimary)
            } else {
                Text("\(number).")
                    .font(.system(size: 14))
                    .foregroundColor(colors.textPrimary)
                Text(text)
                    .font(.system(size: 14))
                    .foregroundColor(colors.textPrimary)
            }
        }
    }
    
    private var calibrationProgress: some View {
        VStack(spacing: 8) {
            Text(settings.localizedString("calibration_progress"))
                .font(.system(size: 14))
                .foregroundColor(colors.textSecondary)
            
            ZStack(alignment: settings.isRTL ? .trailing : .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(colors.backgroundTertiary)
                    .frame(width: 300, height: 8)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(colors.accentPrimary)
                    .frame(width: 300 * compassManager.calibrationProgress, height: 8)
            }
            .frame(width: 300)
            
            Text(settings.localizedString("calibration_status") + ": " + settings.localizedString(compassManager.isCalibrating ? "calibrating" : "calibration_done"))
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(compassManager.isCalibrating ? colors.accentPrimary : colors.accentPrimary)
            
            Text(settings.localizedString("accuracy_status") + ": " + settings.localizedString(compassManager.accuracyStatus.localizedKey))
                .font(.system(size: 14))
                .foregroundColor(compassManager.accuracyStatus.color)
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button(action: {
                compassManager.updateCalibrationProgress(compassManager.calibrationProgress + 0.2)
            }) {
                Text(settings.localizedString("continue_calibration"))
                    .font(.system(size: 14))
                    .foregroundColor(colors.textPrimary)
                    .frame(width: 140, height: 48)
                    .background(colors.backgroundTertiary)
                    .cornerRadius(24)
            }
            
            Button(action: {
                compassManager.finishCalibration()
                dismiss()
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark")
                    Text(settings.localizedString("done_and_return"))
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(colors.backgroundPrimary)
                .frame(width: 140, height: 48)
                .background(colors.accentPrimary)
                .cornerRadius(24)
            }
        }
    }
    
    private func startAnimation() {
        progressTimer?.invalidate()
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if !compassManager.isCalibrating {
                timer.invalidate()
                return
            }
            if compassManager.calibrationProgress < 1.0 {
                let newProgress = min(compassManager.calibrationProgress + 0.05, 1.0)
                compassManager.updateCalibrationProgress(newProgress)
            } else {
                timer.invalidate()
            }
        }
        if let t = progressTimer {
            RunLoop.main.add(t, forMode: .common)
        }
    }
}

#Preview {
    CalibrationView()
        .environmentObject(AppSettings())
        .environmentObject(CompassManager())
}
