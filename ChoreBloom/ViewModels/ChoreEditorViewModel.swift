import Foundation
import SwiftData

@MainActor
final class ChoreEditorViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var pointReward: Int = 10
    @Published var dueDate: Date = .now
    @Published var repeatSchedule: RepeatSchedule = .none
    @Published var assignee: FamilyMember?

    func createChore(context: ModelContext, storeKit: StoreKitManager, currentCount: Int) -> Bool {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        guard currentCount < storeKit.featureLimit(for: .chores) else { return false }
        guard storeKit.isPremiumUnlocked || repeatSchedule == .none || repeatSchedule == .daily else { return false }

        let chore = ChoreItem(
            title: title,
            dueDate: dueDate,
            pointReward: pointReward,
            repeatSchedule: repeatSchedule,
            assignee: assignee
        )

        context.insert(chore)

        do {
            try context.save()
            title = ""
            pointReward = 10
            dueDate = .now
            repeatSchedule = .none
            assignee = nil
            return true
        } catch {
            return false
        }
    }
}
