import SwiftUI

struct LanguagePickerView: View {
    @EnvironmentObject var settings: AppSettings
    @Environment(\.dismiss) var dismiss
    
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
                    ForEach(AppLanguage.allCases, id: \.self) { language in
                        Button(action: {
                            settings.selectedLanguage = language
                            dismiss()
                        }) {
                            HStack {
                                Text(language.displayName)
                                    .font(.system(size: 16))
                                    .foregroundColor(colors.textPrimary)
                                
                                Spacer()
                                
                                if settings.selectedLanguage == language {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(colors.accentPrimary)
                                }
                            }
                            .frame(height: 56)
                            .background(colors.backgroundSecondary)
                            .cornerRadius(12)
                        }
                    }
                }
                .listStyle(.plain)
                .background(colors.backgroundPrimary)
            }
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
            
            Text(settings.localizedString("select_language"))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(colors.textPrimary)
            
            Spacer()
            
            Color.clear
                .frame(width: 80, height: 40)
        }
    }
}

#Preview {
    LanguagePickerView()
        .environmentObject(AppSettings())
}
