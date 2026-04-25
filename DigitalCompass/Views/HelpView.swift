import SwiftUI

struct HelpView: View {
    @EnvironmentObject var settings: AppSettings
    @Environment(\.dismiss) var dismiss
    
    var colors: AppColors { settings.themeColors }
    
    var body: some View {
        NavigationStack {
            ZStack {
                colors.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    Text(settings.localizedString("help_page_content"))
                        .font(.system(size: 15))
                        .foregroundColor(colors.textPrimary)
                        .lineSpacing(6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                }
            }
            .navigationTitle(settings.localizedString("help_center"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(settings.localizedString("done")) { dismiss() }
                        .foregroundColor(colors.accentPrimary)
                }
            }
        }
    }
}

#Preview {
    HelpView()
        .environmentObject(AppSettings())
}
