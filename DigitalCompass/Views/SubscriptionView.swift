import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @EnvironmentObject var settings: AppSettings
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) var dismiss
    
    var isOnboarding: Bool = false
    var onComplete: (() -> Void)? = nil
    
    @State private var selectedProduct: Product?
    @State private var showError = false
    @State private var showSuccess = false
    @State private var showSubscriptionTerms = false
    
    var colors: AppColors { settings.themeColors }
    
    var body: some View {
        ZStack {
            colors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if !isOnboarding {
                    headerBar
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        proHeader
                        benefitsList
                        pricingCards
                        subscribeButton
                        footerLinks
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 24)
                }
            }
        }
        .alert(settings.localizedString("purchase_success"), isPresented: $showSuccess) {
            Button(settings.localizedString("ok")) {
                if isOnboarding {
                    onComplete?()
                } else {
                    dismiss()
                }
            }
        }
        .alert(settings.localizedString("purchase_failed"), isPresented: $showError) {
            Button(settings.localizedString("ok"), role: .cancel) {}
        } message: {
            if let errorMessage = subscriptionManager.errorMessage {
                Text(errorMessage)
            }
        }
        .onAppear {
            loadProducts()
        }
        .sheet(isPresented: $showSubscriptionTerms) {
            LegalDocumentView(type: .subscription)
                .environmentObject(settings)
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
            
            Text(settings.localizedString("upgrade_pro_title"))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(colors.textPrimary)
            
            Spacer()
            
            Color.clear
                .frame(width: 80, height: 40)
        }
    }
    
    private var proHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [Color(hex: "#FFD700"), Color(hex: "#FFA000")]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 40
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "crown.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
            }
            
            Text("Digital Compass Pro")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color(hex: "#FFD700"))
        }
    }
    
    private var benefitsList: some View {
        VStack(spacing: 8) {
            BenefitRow(
                text: settings.localizedString("benefit_adfree"),
                colors: colors,
                isRTL: settings.isRTL
            )
            BenefitRow(
                text: settings.localizedString("benefit_themes"),
                colors: colors,
                isRTL: settings.isRTL
            )
            BenefitRow(
                text: settings.localizedString("benefit_styles"),
                colors: colors,
                isRTL: settings.isRTL
            )
            BenefitRow(
                text: settings.localizedString("benefit_updates"),
                colors: colors,
                isRTL: settings.isRTL
            )
        }
        .frame(maxWidth: 345)
    }
    
    private var pricingCards: some View {
        HStack(alignment: .top, spacing: 16) {
            if let monthly = subscriptionManager.monthlyProduct() {
                PricingCard(
                    product: monthly,
                    isYearly: false,
                    isSelected: selectedProduct?.id == monthly.id,
                    colors: colors,
                    isRTL: settings.isRTL,
                    formatPrice: subscriptionManager.formatPrice,
                    periodText: settings.localizedString("monthly"),
                    unitText: settings.localizedString("month"),
                    shortTermText: settings.localizedString("short_term"),
                    recommendedText: settings.localizedString("recommended"),
                    saveText: settings.localizedString("save_44"),
                    allBenefitsText: settings.localizedString("all_pro_benefits")
                ) {
                    selectedProduct = monthly
                }
            }
            
            if let yearly = subscriptionManager.yearlyProduct() {
                PricingCard(
                    product: yearly,
                    isYearly: true,
                    isSelected: selectedProduct?.id == yearly.id,
                    colors: colors,
                    isRTL: settings.isRTL,
                    formatPrice: subscriptionManager.formatPrice,
                    periodText: settings.localizedString("yearly"),
                    unitText: settings.localizedString("year"),
                    shortTermText: settings.localizedString("short_term"),
                    recommendedText: settings.localizedString("recommended"),
                    saveText: settings.localizedString("save_44"),
                    allBenefitsText: settings.localizedString("all_pro_benefits")
                ) {
                    selectedProduct = yearly
                }
            }
        }
    }
    
    private var subscribeButton: some View {
        Button(action: { purchase() }) {
            if subscriptionManager.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: colors.backgroundPrimary))
                    .frame(width: 345, height: 56)
                    .background(colors.accentPrimary)
                    .cornerRadius(28)
            } else {
                Text(settings.localizedString("subscribe_now"))
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(colors.backgroundPrimary)
                    .frame(width: 345, height: 56)
                    .background(colors.accentPrimary)
                    .cornerRadius(28)
            }
        }
        .disabled(selectedProduct == nil || subscriptionManager.isLoading)
        .opacity(selectedProduct == nil ? 0.6 : 1)
    }
    
    private var footerLinks: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                Button(action: { restorePurchases() }) {
                    Text(settings.localizedString("restore_purchase"))
                        .font(.system(size: 14))
                        .foregroundColor(colors.textSecondary)
                }
                
                Text("|")
                    .foregroundColor(colors.strokePrimary)
                
                Button(action: { showSubscriptionTerms = true }) {
                    Text(settings.localizedString("view_terms"))
                        .font(.system(size: 14))
                        .foregroundColor(colors.textSecondary)
                }
            }
            
            Text(settings.localizedString("subscription_note"))
                .font(.system(size: 12))
                .foregroundColor(colors.textTertiary)
                .multilineTextAlignment(.center)
        }
    }
    
    private func loadProducts() {
        Task {
            await subscriptionManager.loadProducts()
            
            if let yearly = subscriptionManager.yearlyProduct() {
                selectedProduct = yearly
            } else if let monthly = subscriptionManager.monthlyProduct() {
                selectedProduct = monthly
            }
        }
    }
    
    private func purchase() {
        guard let product = selectedProduct else { return }
        
        Task {
            let success = await subscriptionManager.purchase(product)
            if success {
                showSuccess = true
            } else {
                showError = true
            }
        }
    }
    
    private func restorePurchases() {
        Task {
            let success = await subscriptionManager.restorePurchases()
            if success {
                showSuccess = true
            } else {
                showError = true
            }
        }
    }
}

struct BenefitRow: View {
    let text: String
    let colors: AppColors
    let isRTL: Bool
    
    var body: some View {
        HStack {
            if isRTL {
                Text(text)
                    .font(.system(size: 16))
                    .foregroundColor(colors.textPrimary)
                
                Spacer()
                
                Text("✓")
                    .font(.system(size: 18))
                    .foregroundColor(colors.accentPrimary)
            } else {
                Text("✓")
                    .font(.system(size: 18))
                    .foregroundColor(colors.accentPrimary)
                
                Text(text)
                    .font(.system(size: 16))
                    .foregroundColor(colors.textPrimary)
                
                Spacer()
            }
        }
        .frame(height: 48)
        .padding(.horizontal, 16)
        .background(colors.backgroundSecondary)
        .cornerRadius(12)
    }
}

struct PricingCard: View {
    let product: Product
    let isYearly: Bool
    let isSelected: Bool
    let colors: AppColors
    let isRTL: Bool
    let formatPrice: (Product) -> String
    let periodText: String
    let unitText: String
    let shortTermText: String
    let recommendedText: String
    let saveText: String
    let allBenefitsText: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                if isYearly {
                    Text(recommendedText)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(colors.backgroundPrimary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                        .background(colors.accentPrimary)
                        .cornerRadius(12)
                        .offset(y: -12)
                }
                
                Text(periodText)
                    .font(.system(size: 14))
                    .foregroundColor(colors.textSecondary)
                
                Text(formatPrice(product))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(isYearly ? colors.accentPrimary : colors.textPrimary)
                
                Text("/" + unitText)
                    .font(.system(size: 14))
                    .foregroundColor(colors.textSecondary)
                
                if isYearly {
                    Text(saveText)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(colors.accentPrimary)
                }
                
                Text(isYearly ? allBenefitsText : shortTermText)
                    .font(.system(size: 12))
                    .foregroundColor(colors.textTertiary)
            }
            .frame(width: 160, height: isYearly ? 180 : 160)
            .background(isSelected ? colors.accentPrimary.opacity(0.15) : colors.backgroundSecondary)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? colors.accentPrimary : colors.strokePrimary, lineWidth: 2)
            )
            .cornerRadius(16)
        }
    }
}

#Preview {
    SubscriptionView()
        .environmentObject(AppSettings())
        .environmentObject(SubscriptionManager())
}
