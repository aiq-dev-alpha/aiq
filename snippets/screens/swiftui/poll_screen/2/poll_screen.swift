import SwiftUI

struct PollScreen: View {
    @State private var selectedTab = 0
    @State private var userVotes: [String: [String]] = [:]

    private let polls = Poll.samplePolls

    var body: some View {
        NavigationView {
            VStack {
                Picker("Polls", selection: $selectedTab) {
                    Text("Active").tag(0)
                    Text("Results").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedTab == 0 {
                    activePollsView
                } else {
                    completedPollsView
                }
            }
            .navigationTitle("Polls & Voting")
        }
    }

    private var activePollsView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(polls.filter { $0.isActive }, id: \.id) { poll in
                    PollCardView(poll: poll, userVotes: $userVotes)
                }
            }
            .padding()
        }
    }

    private var completedPollsView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(polls.filter { !$0.isActive }, id: \.id) { poll in
                    PollResultsView(poll: poll)
                }
            }
            .padding()
        }
    }
}

struct PollCardView: View {
    let poll: Poll
    @Binding var userVotes: [String: [String]]
    @State private var selectedOptions: Set<String> = []

    var hasVoted: Bool {
        userVotes[poll.id] != nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(poll.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Text(poll.category)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.blue)
                }

                Text(poll.description)
                    .font(.body)
                    .foregroundColor(.secondary)

                HStack {
                    Label("\(poll.totalVotes) votes", systemImage: "person.2")
                    Label("\(poll.daysRemaining) days left", systemImage: "clock")
                    if poll.allowMultiple {
                        Label("Multiple choice", systemImage: "checkmark.square")
                    }
                }
                .font(.caption)
                .foregroundColor(.gray)
            }

            if hasVoted {
                PollResultsView(poll: poll, showVotedStatus: true)
            } else {
                votingInterface
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }

    private var votingInterface: some View {
        VStack(spacing: 12) {
            ForEach(poll.options, id: \.id) { option in
                Button(action: {
                    toggleOption(option.id)
                }) {
                    HStack {
                        Image(systemName: poll.allowMultiple ?
                              (selectedOptions.contains(option.id) ? "checkmark.square.fill" : "square") :
                              (selectedOptions.contains(option.id) ? "largecircle.fill.circle" : "circle"))
                            .foregroundColor(.blue)

                        Text(option.text)
                            .foregroundColor(.primary)

                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedOptions.contains(option.id) ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }

            if poll.allowMultiple && poll.maxSelections > 0 {
                Text("Select up to \(poll.maxSelections) options (\(selectedOptions.count) selected)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Button("Submit Vote") {
                submitVote()
            }
            .disabled(selectedOptions.isEmpty || (poll.maxSelections > 0 && selectedOptions.count > poll.maxSelections))
            .buttonStyle(PrimaryButtonStyle())
        }
    }

    private func toggleOption(_ optionId: String) {
        if poll.allowMultiple {
            if selectedOptions.contains(optionId) {
                selectedOptions.remove(optionId)
            } else if poll.maxSelections == 0 || selectedOptions.count < poll.maxSelections {
                selectedOptions.insert(optionId)
            }
        } else {
            selectedOptions.removeAll()
            selectedOptions.insert(optionId)
        }
    }

    private func submitVote() {
        userVotes[poll.id] = Array(selectedOptions)
        selectedOptions.removeAll()
    }
}

struct PollResultsView: View {
    let poll: Poll
    var showVotedStatus = false

    var body: some View {
        VStack(spacing: 12) {
            ForEach(poll.options, id: \.id) { option in
                let percentage = poll.totalVotes > 0 ? Double(option.votes) / Double(poll.totalVotes) * 100 : 0

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(option.text)
                            .font(.body)
                        Spacer()
                        Text("\(option.votes)")
                            .fontWeight(.bold)
                        Text("(\(Int(percentage))%)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    ProgressView(value: percentage / 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                }
            }

            if showVotedStatus {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("You have voted in this poll")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .padding(.top, 8)
            }
        }
    }
}

struct Poll {
    let id: String
    let title: String
    let description: String
    let options: [PollOption]
    let category: String
    let allowMultiple: Bool
    let maxSelections: Int
    let isActive: Bool
    let daysRemaining: Int

    var totalVotes: Int {
        options.reduce(0) { $0 + $1.votes }
    }

    struct PollOption {
        let id: String
        let text: String
        let votes: Int
    }

    static let samplePolls = [
        Poll(
            id: "poll1",
            title: "Favorite Programming Language",
            description: "Which programming language do you prefer for mobile development?",
            options: [
                PollOption(id: "dart", text: "Dart/Flutter", votes: 245),
                PollOption(id: "kotlin", text: "Kotlin", votes: 189),
                PollOption(id: "swift", text: "Swift", votes: 156),
                PollOption(id: "js", text: "JavaScript/React Native", votes: 203)
            ],
            category: "Technology",
            allowMultiple: false,
            maxSelections: 1,
            isActive: true,
            daysRemaining: 7
        ),
        Poll(
            id: "poll2",
            title: "Work From Home Preferences",
            description: "What is your preferred work arrangement?",
            options: [
                PollOption(id: "remote", text: "Fully remote", votes: 312),
                PollOption(id: "hybrid", text: "Hybrid (2-3 days office)", votes: 456),
                PollOption(id: "office", text: "Fully in office", votes: 123)
            ],
            category: "Workplace",
            allowMultiple: false,
            maxSelections: 1,
            isActive: false,
            daysRemaining: 0
        )
    ]
}

struct PollScreen_Previews: PreviewProvider {
    static var previews: some View {
        PollScreen()
    }
}