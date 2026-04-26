import SwiftData
import SwiftUI

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var notificationManager: ReminderNotificationManager
    @Query(sort: \ChoreItem.dueDate, order: .forward) private var chores: [ChoreItem]
    @Query(sort: \FamilyMember.createdAt, order: .forward) private var members: [FamilyMember]
    @Query(sort: \ChoreItem.dueDate, order: .forward) private var allChores: [ChoreItem]

    @StateObject private var dashboardVM = ChoreDashboardViewModel()
    @StateObject private var editorVM = ChoreEditorViewModel()
    @State private var selection: Int = 0

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                LinearGradient(colors: [.cyan.opacity(0.15), .purple.opacity(0.15), .pink.opacity(0.15)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        Picker("Range", selection: $selection) {
                            Text("Daily").tag(0)
                            Text("Weekly").tag(1)
                        }
                        .pickerStyle(.segmented)

                        GradientCard(colors: [.blue, .purple]) {
                            Text("ChoreBloom")
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                            Text("Grow routines, earn points, celebrate wins.")
                                .foregroundStyle(.white.opacity(0.92))
                                .font(.subheadline)
                        }

                        choreList

                        ChoreComposerView(viewModel: editorVM, members: members, choreCount: allChores.count)
                    }
                    .padding()
                }

                CelebrationBurstView(isShowing: $dashboardVM.showCelebration)
                    .padding(.top, 120)
            }
            .navigationTitle("Family Tasks")
            .alert("Update", isPresented: .constant(dashboardVM.feedbackMessage != nil), actions: {
                Button("OK") { dashboardVM.feedbackMessage = nil }
            }, message: {
                Text(dashboardVM.feedbackMessage ?? "")
            })
        }
    }

    @ViewBuilder
    private var choreList: some View {
        let filtered = selection == 0 ? dashboardVM.choresForDay(chores, date: .now) : dashboardVM.choresForWeek(chores, anchor: .now)

        VStack(alignment: .leading, spacing: 12) {
            Text(selection == 0 ? "Today" : "This Week")
                .font(.headline)

            ForEach(filtered) { chore in
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(chore.title)
                            .font(.headline)
                        Text("Due \(chore.dueDate.formatted(date: .abbreviated, time: .shortened)) • \(chore.pointReward) pts")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button(chore.isCompleted ? "Done" : "Complete") {
                        dashboardVM.complete(chore, context: modelContext)
                        Task { await notificationManager.scheduleOverdueReminder(for: chore) }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(chore.isCompleted ? .green : .orange)
                    .disabled(chore.isCompleted)
                }
                .padding()
                .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }

            if filtered.isEmpty {
                ContentUnavailableView("No chores here", systemImage: "checklist", description: Text("Add a chore to get your routine growing."))
            }
        }
    }
}

private struct ChoreComposerView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var storeKit: StoreKitManager
    @ObservedObject var viewModel: ChoreEditorViewModel
    let members: [FamilyMember]
    let choreCount: Int

    var body: some View {
        GradientCard(colors: [.pink, .orange]) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Add Chore")
                    .font(.headline)
                    .foregroundStyle(.white)

                TextField("Task title", text: $viewModel.title)
                    .textFieldStyle(.roundedBorder)

                DatePicker("Due", selection: $viewModel.dueDate)
                    .foregroundStyle(.white)

                Picker("Repeats", selection: $viewModel.repeatSchedule) {
                    ForEach(RepeatSchedule.allCases) { schedule in
                        Text(schedule.rawValue).tag(schedule)
                    }
                }
                .pickerStyle(.menu)
                .tint(.white)

                Stepper("\(viewModel.pointReward) points", value: $viewModel.pointReward, in: 5...100, step: 5)
                    .foregroundStyle(.white)

                Picker("Assignee", selection: $viewModel.assignee) {
                    Text("Unassigned").tag(FamilyMember?.none)
                    ForEach(members) { member in
                        Text(member.name).tag(FamilyMember?.some(member))
                    }
                }
                .pickerStyle(.menu)
                .tint(.white)

                Button("Save Chore") {
                    _ = viewModel.createChore(context: modelContext, storeKit: storeKit, currentCount: choreCount)
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundStyle(.purple)
            }
        }
    }
}
