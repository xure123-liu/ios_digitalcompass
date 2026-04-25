import SwiftUI

enum LegalDocumentType {
    case privacy
    case terms
    case subscription
}

struct LegalDocumentView: View {
    let type: LegalDocumentType
    
    @EnvironmentObject var settings: AppSettings
    @Environment(\.dismiss) var dismiss
    
    var colors: AppColors { settings.themeColors }
    
    var title: String {
        switch type {
        case .privacy:
            return settings.localizedString("privacy_policy_title")
        case .terms:
            return settings.localizedString("user_terms_title")
        case .subscription:
            return settings.localizedString("subscription_terms_title")
        }
    }
    
    var content: String {
        switch type {
        case .privacy:
            return privacyPolicyContent
        case .terms:
            return userTermsContent
        case .subscription:
            return subscriptionTermsContent
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                colors.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    Text(content)
                        .font(.system(size: 14))
                        .foregroundColor(colors.textPrimary)
                        .lineSpacing(8)
                        .padding(16)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(settings.localizedString("done")) {
                        dismiss()
                    }
                    .foregroundColor(colors.accentPrimary)
                }
            }
        }
    }
    
    private var privacyPolicyContent: String {
        settings.localizedString("privacy_policy_content")
    }
    
    private var userTermsContent: String {
        settings.localizedString("user_terms_content")
    }
    
    private var subscriptionTermsContent: String {
        settings.localizedString("subscription_terms_content")
    }
}

#Preview {
    LegalDocumentView(type: .privacy)
        .environmentObject(AppSettings())
}
