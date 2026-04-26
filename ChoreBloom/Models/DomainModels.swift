import Foundation
import SwiftData
import SwiftUI

@Model
final class FamilyMember {
    var name: String
    var avatarColorHex: String
    var points: Int
    var createdAt: Date

    init(name: String, avatarColorHex: String, points: Int = 0, createdAt: Date = .now) {
        self.name = name
        self.avatarColorHex = avatarColorHex
        self.points = points
        self.createdAt = createdAt
    }

    var avatarColor: Color {
        Color(hex: avatarColorHex)
    }
}

enum RepeatSchedule: String, CaseIterable, Codable, Identifiable {
    case none = "One-Time"
    case daily = "Daily"
    case weekdays = "Weekdays"
    case weekly = "Weekly"

    var id: String { rawValue }
}

@Model
final class ChoreItem {
    var title: String
    var dueDate: Date
    var pointReward: Int
    var repeatScheduleRawValue: String
    var isCompleted: Bool
    var completedAt: Date?
    var assignee: FamilyMember?

    init(
        title: String,
        dueDate: Date,
        pointReward: Int,
        repeatSchedule: RepeatSchedule,
        isCompleted: Bool = false,
        completedAt: Date? = nil,
        assignee: FamilyMember? = nil
    ) {
        self.title = title
        self.dueDate = dueDate
        self.pointReward = pointReward
        repeatScheduleRawValue = repeatSchedule.rawValue
        self.isCompleted = isCompleted
        self.completedAt = completedAt
        self.assignee = assignee
    }

    var repeatSchedule: RepeatSchedule {
        get { RepeatSchedule(rawValue: repeatScheduleRawValue) ?? .none }
        set { repeatScheduleRawValue = newValue.rawValue }
    }
}

@Model
final class RewardBadge {
    var title: String
    var subtitle: String
    var iconName: String
    var requiredPoints: Int

    init(title: String, subtitle: String, iconName: String, requiredPoints: Int) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.requiredPoints = requiredPoints
    }
}

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: cleaned).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch cleaned.count {
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xff, (int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
        default:
            (a, r, g, b) = (255, (int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    var hexString: String {
        UIColor(self).toHexString()
    }
}

private extension UIColor {
    func toHexString() -> String {
        guard let components = cgColor.components else { return "#6C9EFF" }
        let r = Float(components[0])
        let g = Float(components.count > 2 ? components[1] : components[0])
        let b = Float(components.count > 2 ? components[2] : components[0])
        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}
