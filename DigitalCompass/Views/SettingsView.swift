import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) var dismiss
    
    @State private var showLanguagePicker = false
    @State private var showThemePicker = false
    @State private var showPrivacy = false
    @State private var showTerms = false
    @State private var showSubscriptionTerms = false
    @State private var showSubscription = false
    @State private var showHelp = false
    @State private var showRestoreAlert = false
    @State private var restoreSuccess = false
    
    var colors: AppColors { settings.themeColors }
    
    var body: some View {
        ZStack {
            colors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerBar
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                List {
                    appearanceSection
                    preferencesSection
                    Divider()
                        .listRowBackground(Color.clear)
                    legalSection
                    Divider()
                        .listRowBackground(Color.clear)
                    subscriptionSection
                }
                .listStyle(.plain)
                .background(colors.backgroundPrimary)
            }
        }
        .navigationDestination(isPresented: $showLanguagePicker) {
            LanguagePickerView()
        }
        .navigationDestination(isPresented: $showThemePicker) {
            ThemePickerView()
        }
        .sheet(isPresented: $showSubscription) {
            SubscriptionView()
        }
        .sheet(isPresented: $showHelp) {
            HelpView()
        }
        .sheet(isPresented: $showPrivacy) {
            LegalDocumentView(type: .privacy)
        }
        .sheet(isPresented: $showTerms) {
            LegalDocumentView(type: .terms)
        }
        .sheet(isPresented: $showSubscriptionTerms) {
            LegalDocumentView(type: .subscription)
        }
        .alert(settings.localizedString(restoreSuccess ? "restore_success" : "restore_failed"), isPresented: $showRestoreAlert) {
            Button(settings.localizedString("ok"), role: .cancel) {}
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
            
            Text(settings.localizedString("settings_title"))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(colors.textPrimary)
            
            Spacer()
            
            Color.clear
                .frame(width: 80, height: 40)
        }
    }
    
    private var appearanceSection: some View {
        Section {
            Button(action: { showThemePicker = true }) {
                SettingsRow(
                    icon: "paintpalette",
                    title: settings.localizedString("theme"),
                    value: settings.localizedString(settings.selectedTheme.localizationKey),
                    showArrow: true,
                    colors: colors,
                    isRTL: settings.isRTL
                )
            }
            
            Button(action: { showLanguagePicker = true }) {
                SettingsRow(
                    icon: "globe",
                    title: settings.localizedString("language"),
                    value: settings.selectedLanguage.displayName,
                    showArrow: true,
                    colors: colors,
                    isRTL: settings.isRTL
                )
            }
        }
    }
    
    private var preferencesSection: some View {
        Section {
            ToggleRow(
                icon: "target",
                title: settings.localizedString("accuracy_tips"),
                isOn: $settings.isAccuracyTipsEnabled,
                colors: colors,
                isRTL: settings.isRTL
            )
            
            ToggleRow(
                icon: "bell",
                title: settings.localizedString("sound_feedback"),
                isOn: $settings.isSoundFeedbackEnabled,
                colors: colors,
                isRTL: settings.isRTL
            )
        }
    }
    
    private var legalSection: some View {
        Section {
            Button(action: { showHelp = true }) {
                SettingsRow(
                    icon: "questionmark.circle",
                    title: settings.localizedString("help_center"),
                    value: "",
                    showArrow: true,
                    colors: colors,
                    isRTL: settings.isRTL
                )
            }
            
            Button(action: { showPrivacy = true }) {
                SettingsRow(
                    icon: "lock.shield",
                    title: settings.localizedString("privacy_policy"),
                    value: "",
                    showArrow: true,
                    colors: colors,
                    isRTL: settings.isRTL
                )
            }
            
            Button(action: { showTerms = true }) {
                SettingsRow(
                    icon: "doc.text",
                    title: settings.localizedString("user_terms"),
                    value: "",
                    showArrow: true,
                    colors: colors,
                    isRTL: settings.isRTL
                )
            }
            
            Button(action: { showSubscriptionTerms = true }) {
                SettingsRow(
                    icon: "doc.plaintext",
                    title: settings.localizedString("subscription_terms"),
                    value: "",
                    showArrow: true,
                    colors: colors,
                    isRTL: settings.isRTL
                )
            }
        }
    }
    
    private var subscriptionSection: some View {
        Section {
            Button(action: { restorePurchases() }) {
                SettingsRow(
                    icon: "arrow.counterclockwise",
                    title: settings.localizedString("restore_purchase"),
                    value: "",
                    showArrow: true,
                    colors: colors,
                    isRTL: settings.isRTL
                )
            }
            
            if !subscriptionManager.isPro {
                Button(action: { showSubscription = true }) {
                    HStack {
                        SettingsRow(
                            icon: "crown.fill",
                            title: settings.localizedString("upgrade_pro"),
                            value: "",
                            showArrow: true,
                            colors: colors,
                            isRTL: settings.isRTL,
                            isProRow: true
                        )
                    }
                }
            }
            
            HStack {
                Spacer()
                Text("Digital Compass v1.0")
                    .font(.system(size: 14))
                    .foregroundColor(colors.textTertiary)
                Spacer()
            }
            .padding(.vertical, 8)
            .listRowBackground(Color.clear)
        }
    }
    
    private func restorePurchases() {
        Task {
            let success = await subscriptionManager.restorePurchases()
            restoreSuccess = success
            showRestoreAlert = true
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let value: String
    let showArrow: Bool
    let colors: AppColors
    let isRTL: Bool
    var isProRow: Bool = false
    
    var body: some View {
        HStack {
            if isRTL {
                contentRTL
            } else {
                contentLTR
            }
        }
        .frame(height: 56)
        .background(colors.backgroundSecondary)
        .cornerRadius(12)
    }
    
    private var contentLTR: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isProRow ? colors.accentPrimary : colors.textPrimary)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(isProRow ? colors.accentPrimary : colors.textPrimary)
            
            Spacer()
            
            if !value.isEmpty {
                Text(value)
                    .font(.system(size: 14))
                    .foregroundColor(colors.textSecondary)
            }
            
            if showArrow {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16))
                    .foregroundColor(colors.textSecondary)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var contentRTL: some View {
        HStack(spacing: 12) {
            if showArrow {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16))
                    .foregroundColor(colors.textSecondary)
            }
            
            if !value.isEmpty {
                Text(value)
                    .font(.system(size: 14))
                    .foregroundColor(colors.textSecondary)
            }
            
            Spacer()
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(isProRow ? colors.accentPrimary : colors.textPrimary)
            
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isProRow ? colors.accentPrimary : colors.textPrimary)
                .frame(width: 24)
        }
        .padding(.horizontal, 16)
    }
}

struct ToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    let colors: AppColors
    let isRTL: Bool
    
    var body: some View {
        HStack {
            if isRTL {
                Toggle("", isOn: $isOn)
                    .toggleStyle(SwitchToggleStyle(tint: colors.accentPrimary))
                    .labelsHidden()
                
                Spacer()
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(colors.textPrimary)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(colors.textPrimary)
                    .frame(width: 24)
            } else {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(colors.textPrimary)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(colors.textPrimary)
                
                Spacer()
                
                Toggle("", isOn: $isOn)
                    .toggleStyle(SwitchToggleStyle(tint: colors.accentPrimary))
                    .labelsHidden()
            }
        }
        .frame(height: 56)
        .background(colors.backgroundSecondary)
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppSettings())
        .environmentObject(SubscriptionManager())
}
