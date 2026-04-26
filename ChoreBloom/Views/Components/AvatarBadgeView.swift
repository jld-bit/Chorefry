import SwiftUI

struct AvatarBadgeView: View {
    let member: FamilyMember

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(member.avatarColor)
                .frame(width: 34, height: 34)
                .overlay {
                    Text(String(member.name.prefix(1)).uppercased())
                        .font(.headline)
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(member.name)
                    .font(.subheadline.weight(.semibold))
                Text("\(member.points) pts")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
