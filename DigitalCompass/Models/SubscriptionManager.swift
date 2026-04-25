import Foundation
import StoreKit
import Combine

class SubscriptionManager: NSObject, ObservableObject {
    @Published var isPro: Bool = false
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    static let shared = SubscriptionManager()
    
    let monthlyProductID = "com.digitalcompass.pro.monthly"
    let yearlyProductID = "com.digitalcompass.pro.yearly"
    
    private var updateListenerTask: Task<Void, Never>? = nil
    
    enum SubscriptionError: Error, LocalizedError {
        case productNotFound
        case purchaseFailed
        case restoreFailed
        case userCancelled
        case pending
        
        var errorDescription: String? {
            switch self {
            case .productNotFound:
                return NSLocalizedString("error_product_not_found", comment: "")
            case .purchaseFailed:
                return NSLocalizedString("error_purchase_failed", comment: "")
            case .restoreFailed:
                return NSLocalizedString("error_restore_failed", comment: "")
            case .userCancelled:
                return NSLocalizedString("error_user_cancelled", comment: "")
            case .pending:
                return NSLocalizedString("error_purchase_pending", comment: "")
            }
        }
    }
    
    override init() {
        super.init()
        
        updateListenerTask = listenForTransactions()
        
        Task {
            await loadProducts()
            await updateSubscriptionStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let productIds = [monthlyProductID, yearlyProductID]
            var loaded = try await Product.products(for: productIds)
            loaded.sort { p1, p2 in
                if p1.id == yearlyProductID { return true }
                if p2.id == yearlyProductID { return false }
                return p1.id < p2.id
            }
            products = loaded
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func purchase(_ product: Product) async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                await updateSubscriptionStatus()
                return true
                
            case .userCancelled:
                errorMessage = SubscriptionError.userCancelled.localizedDescription
                return false
                
            case .pending:
                errorMessage = SubscriptionError.pending.localizedDescription
                return false
                
            @unknown default:
                errorMessage = SubscriptionError.purchaseFailed.localizedDescription
                return false
            }
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func restorePurchases() async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await AppStore.sync()
            await updateSubscriptionStatus()
            return isPro
        } catch {
            errorMessage = SubscriptionError.restoreFailed.localizedDescription
            return false
        }
    }
    
    func updateSubscriptionStatus() async {
        var hasValidSubscription = false
        
        for await entitlement in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(entitlement) {
                if transaction.productType == .autoRenewable && transaction.productID.contains("pro") {
                    if transaction.expirationDate ?? Date() > Date() {
                        hasValidSubscription = true
                        break
                    }
                }
            }
        }
        
        await MainActor.run {
            self.isPro = hasValidSubscription
        }
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        Task { [weak self] in
            guard let self = self else { return }
            for await update in Transaction.updates {
                if let transaction = try? self.checkVerified(update) {
                    await transaction.finish()
                    await self.updateSubscriptionStatus()
                }
            }
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw SubscriptionError.purchaseFailed
        case .verified(let safe):
            return safe
        }
    }
    
    /// Cold-start subscription is driven by `AppDelegate.shouldPresentSubscriptionOnColdStart` in ContentView.
    
    func formatPrice(_ product: Product) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceFormatStyle.locale
        return formatter.string(from: product.price as NSDecimalNumber) ?? "\(product.price)"
    }
    
    func monthlyProduct() -> Product? {
        return products.first { $0.id == monthlyProductID }
    }
    
    func yearlyProduct() -> Product? {
        return products.first { $0.id == yearlyProductID }
    }
}
