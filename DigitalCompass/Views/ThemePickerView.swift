import SwiftUI

struct ThemePickerView: View {
    @EnvironmentObject var settings: AppSettings
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) var dismiss
    
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
                
                List {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        Button(action: {
                            selectTheme(theme)
                        }) {
                            HStack {
                                Text(settings.localizedString(theme.localizationKey))
                                    .font(.system(size: 16))
                                    .foregroundColor(colors.textPrimary)
                                
                                if theme.isPro {
                                    Text("Pro")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(colors.backgroundPrimary)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(colors.accentPrimary)
                                        .cornerRadius(4)
                                }
                                
                                Spacer()
                                
                                if settings.selectedTheme == theme {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(colors.accentPrimary)
                                }
                            }
                            .frame(height: 56)
                            .background(colors.backgroundSecondary)
                            .cornerRadius(12)
                        }
                        .disabled(theme.isPro && !subscriptionManager.isPro)
                        .opacity(theme.isPro && !subscriptionManager.isPro ? 0.5 : 1)
                    }
                }
                .listStyle(.plain)
                .background(colors.backgroundPrimary)
            }
        }
        .sheet(isPresented: $showSubscription) {
            SubscriptionView()
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
            
            Text(settings.localizedString("select_theme"))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(colors.textPrimary)
            
            Spacer()
            
            Color.clear
                .frame(width: 80, height: 40)
        }
    }
    
    private func selectTheme(_ theme: AppTheme) {
        if theme.isPro && !subscriptionManager.isPro {
            showSubscription = true
            return
        }
        
        settings.selectedTheme = theme
        dismiss()
    }
}

#Preview {
    ThemePickerView()
        .environmentObject(AppSettings())
        .environmentObject(SubscriptionManager())
}
