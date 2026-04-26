import SwiftData
import SwiftUI

struct MembersView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var storeKit: StoreKitManager
    @Query(sort: \FamilyMember.createdAt, order: .forward) private var members: [FamilyMember]
    @StateObject private var viewModel = MemberViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    GradientCard(colors: [.mint, .blue]) {
                        Text("Family Garden")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                        Text("Add each family member and watch point totals bloom.")
                            .foregroundStyle(.white.opacity(0.95))
                    }

                    ForEach(members) { member in
                        HStack {
                            AvatarBadgeView(member: member)
                            Spacer()
                            Text("\(member.points)")
                                .font(.title3.bold())
                        }
                        .padding()
                        .background(.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }

                    GradientCard(colors: [.purple, .pink]) {
                        TextField("Name", text: $viewModel.name)
                            .textFieldStyle(.roundedBorder)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.availableColors, id: \.self) { hex in
                                    Circle()
                                        .fill(Color(hex: hex))
                                        .frame(width: 30, height: 30)
                                        .overlay {
                                            if viewModel.selectedColorHex == hex {
                                                Image(systemName: "checkmark")
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                        .onTapGesture { viewModel.selectedColorHex = hex }
                                }
                            }
                            .padding(.vertical, 4)
                        }

                        Button("Add Member") {
                            _ = viewModel.addMember(context: modelContext, storeKit: storeKit, currentCount: members.count)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
            }
            .navigationTitle("Family")
        }
    }
}
