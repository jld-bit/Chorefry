import Foundation
import SwiftData

@MainActor
final class ChoreDashboardViewModel: ObservableObject {
    @Published var selectedDate: Date = .now
    @Published var showCelebration = false
    @Published var feedbackMessage: String?

    func choresForDay(_ chores: [ChoreItem], date: Date) -> [ChoreItem] {
        chores.filter { Calendar.current.isDate($0.dueDate, inSameDayAs: date) }
            .sorted { $0.dueDate < $1.dueDate }
    }

    func choresForWeek(_ chores: [ChoreItem], anchor: Date) -> [ChoreItem] {
        guard let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: anchor) else { return [] }
        return chores.filter { weekInterval.contains($0.dueDate) }
            .sorted { $0.dueDate < $1.dueDate }
    }

    func complete(_ chore: ChoreItem, context: ModelContext) {
        guard !chore.isCompleted else { return }
        chore.isCompleted = true
        chore.completedAt = .now
        chore.assignee?.points += chore.pointReward

        showCelebration = true
        feedbackMessage = "+\(chore.pointReward) points!"

        do {
            try context.save()
        } catch {
            feedbackMessage = "Could not save completion."
        }
    }
}
