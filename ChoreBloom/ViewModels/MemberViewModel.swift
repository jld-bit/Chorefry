import Foundation
import SwiftData

@MainActor
final class MemberViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var selectedColorHex: String = "#FF8D5C"

    let availableColors = ["#FF8D5C", "#FFCD56", "#54E1A6", "#5CB3FF", "#A772FF", "#FF6FB7"]

    func addMember(context: ModelContext, storeKit: StoreKitManager, currentCount: Int) -> Bool {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        guard currentCount < storeKit.featureLimit(for: .members) else { return false }

        let member = FamilyMember(name: name, avatarColorHex: selectedColorHex)
        context.insert(member)

        do {
            try context.save()
            name = ""
            return true
        } catch {
            return false
        }
    }
}
