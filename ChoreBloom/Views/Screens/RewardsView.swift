import SwiftData
import SwiftUI

struct RewardsView: View {
    @Query(sort: \FamilyMember.createdAt) private var members: [FamilyMember]
    @Query(sort: \RewardBadge.requiredPoints) private var badges: [RewardBadge]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    GradientCard(colors: [.orange, .pink]) {
                        Text("Rewards")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                        Text("Points unlock playful achievement badges.")
                            .foregroundStyle(.white)
                    }

                    ForEach(members) { member in
                        VStack(alignment: .leading, spacing: 10) {
                            AvatarBadgeView(member: member)
                            badgeRow(points: member.points)
                        }
                        .padding()
                        .background(.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }
                .padding()
            }
            .navigationTitle("Rewards")
        }
    }

    private func badgeRow(points: Int) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(badges) { badge in
                    VStack(spacing: 8) {
                        Image(systemName: badge.iconName)
                            .font(.title2)
                        Text(badge.title)
                            .font(.caption.weight(.semibold))
                        Text("\(badge.requiredPoints) pts")
                            .font(.caption2)
                    }
                    .foregroundStyle(points >= badge.requiredPoints ? .white : .secondary)
                    .frame(width: 92, height: 92)
                    .background(points >= badge.requiredPoints ? Color.purple : Color.gray.opacity(0.18))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
        }
    }
}
