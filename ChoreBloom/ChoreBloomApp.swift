import SwiftData
import SwiftUI

@main
struct ChoreBloomApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FamilyMember.self,
            ChoreItem.self,
            RewardBadge.self
        ])

        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @StateObject private var storeKitManager = StoreKitManager()
    @StateObject private var notificationManager = ReminderNotificationManager()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(storeKitManager)
                .environmentObject(notificationManager)
                .task {
                    await storeKitManager.loadProducts()
                    await notificationManager.requestAuthorization()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
