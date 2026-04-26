import Foundation
import StoreKit

@MainActor
final class StoreKitManager: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var isPremiumUnlocked = false

    private let premiumProductID = "com.chorebloom.premium.yearly"

    func loadProducts() async {
        do {
            products = try await Product.products(for: [premiumProductID])
            await updatePremiumStatus()
        } catch {
            print("Failed to load StoreKit products: \(error)")
        }
    }

    func purchasePremium() async {
        guard let product = products.first(where: { $0.id == premiumProductID }) else { return }

        do {
            let result = try await product.purchase()
            if case let .success(verificationResult) = result,
               case .verified(_) = verificationResult {
                await updatePremiumStatus()
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }

    func updatePremiumStatus() async {
        for await result in Transaction.currentEntitlements {
            if case let .verified(transaction) = result,
               transaction.productID == premiumProductID {
                isPremiumUnlocked = true
                return
            }
        }
        isPremiumUnlocked = false
    }

    func featureLimit(for type: FeatureType) -> Int {
        guard !isPremiumUnlocked else { return .max }
        switch type {
        case .members: return 4
        case .chores: return 15
        }
    }
}

enum FeatureType {
    case members
    case chores
}
