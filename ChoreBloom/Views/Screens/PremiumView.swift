import StoreKit
import SwiftUI

struct PremiumView: View {
    @EnvironmentObject private var storeKit: StoreKitManager

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                GradientCard(colors: [.purple, .blue]) {
                    Text("ChoreBloom Premium")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Text("Unlimited chores, recurring schedules, rewards depth, and themes.")
                        .foregroundStyle(.white.opacity(0.9))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Label("Free: up to 4 members and 15 chores", systemImage: "leaf")
                    Label("Premium: unlimited members and chores", systemImage: "sparkles")
                    Label("Premium: all repeat schedule options", systemImage: "calendar.badge.clock")
                }
                .font(.subheadline)

                if storeKit.isPremiumUnlocked {
                    Label("Premium active", systemImage: "checkmark.seal.fill")
                        .foregroundStyle(.green)
                } else {
                    Button("Unlock Premium") {
                        Task { await storeKit.purchasePremium() }
                    }
                    .buttonStyle(.borderedProminent)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Premium")
        }
    }
}
