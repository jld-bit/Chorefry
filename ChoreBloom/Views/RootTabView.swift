import SwiftData
import SwiftUI

struct RootTabView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Today", systemImage: "sun.max.fill")
                }

            MembersView()
                .tabItem {
                    Label("Family", systemImage: "person.3.fill")
                }

            RewardsView()
                .tabItem {
                    Label("Rewards", systemImage: "rosette")
                }

            PremiumView()
                .tabItem {
                    Label("Premium", systemImage: "sparkles")
                }
        }
        .tint(.purple)
        .task {
            SampleDataSeeder.seedIfNeeded(context: modelContext)
        }
    }
}
