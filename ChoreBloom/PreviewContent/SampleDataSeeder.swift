import Foundation
import SwiftData

enum SampleDataSeeder {
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<FamilyMember>()
        guard (try? context.fetchCount(descriptor)) == 0 else { return }

        let alex = FamilyMember(name: "Alex", avatarColorHex: "#5CB3FF", points: 42)
        let rio = FamilyMember(name: "Rio", avatarColorHex: "#FF8D5C", points: 55)
        let sam = FamilyMember(name: "Sam", avatarColorHex: "#A772FF", points: 26)

        context.insert(alex)
        context.insert(rio)
        context.insert(sam)

        context.insert(ChoreItem(title: "Make bed", dueDate: .now, pointReward: 10, repeatSchedule: .daily, assignee: sam))
        context.insert(ChoreItem(title: "Set table", dueDate: .now.addingTimeInterval(7200), pointReward: 8, repeatSchedule: .weekdays, assignee: alex))
        context.insert(ChoreItem(title: "Water plants", dueDate: .now.addingTimeInterval(86_400), pointReward: 12, repeatSchedule: .weekly, assignee: rio))

        context.insert(RewardBadge(title: "Sprout", subtitle: "First 20 points", iconName: "leaf.fill", requiredPoints: 20))
        context.insert(RewardBadge(title: "Blossom", subtitle: "Reach 50 points", iconName: "sun.max.fill", requiredPoints: 50))
        context.insert(RewardBadge(title: "Garden Star", subtitle: "Reach 100 points", iconName: "star.fill", requiredPoints: 100))

        try? context.save()
    }
}
