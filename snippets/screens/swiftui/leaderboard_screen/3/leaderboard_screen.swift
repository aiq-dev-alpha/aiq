import SwiftUI

struct LeaderboardScreen: View {
    @State private var selectedPeriod = "This Month"
    @State private var selectedTab = 0
    @State private var showingFilters = false

    private let periods = ["Today", "This Week", "This Month", "This Quarter", "This Year"]
    private let tabTitles = ["Users", "Teams", "Departments"]

    var body: some View {
        VStack(spacing: 0) {
            filtersSection
                .padding()

            topPerformersSection
                .padding(.horizontal)

            tabSelector

            TabView(selection: $selectedTab) {
                usersContent
                    .tag(0)

                teamsContent
                    .tag(1)

                departmentsContent
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .navigationTitle("Leaderboard")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingFilters = true }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .sheet(isPresented: $showingFilters) {
            FiltersSheet(selectedPeriod: $selectedPeriod)
        }
    }

    private var filtersSection: some View {
        HStack {
            Menu {
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(periods, id: \.self) { period in
                        Text(period)
                    }
                }
            } label: {
                HStack {
                    Text(selectedPeriod)
                        .foregroundColor(.primary)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }

            Spacer()

            Button(action: { showingFilters = true }) {
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text("More Filters")
                }
                .foregroundColor(.blue)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }

    private var topPerformersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top Performers - \(selectedPeriod)")
                .font(.headline)
                .fontWeight(.bold)

            HStack(spacing: 8) {
                // Second place
                PodiumCard(
                    rank: 2,
                    name: "Sarah Wilson",
                    score: "8,456",
                    change: "+12.3%",
                    color: .gray,
                    isWinner: false
                )
                .frame(maxWidth: .infinity)

                // First place (winner)
                PodiumCard(
                    rank: 1,
                    name: "John Smith",
                    score: "9,876",
                    change: "+18.5%",
                    color: .yellow,
                    isWinner: true
                )
                .frame(maxWidth: .infinity)

                // Third place
                PodiumCard(
                    rank: 3,
                    name: "Mike Johnson",
                    score: "7,234",
                    change: "+8.7%",
                    color: .brown,
                    isWinner: false
                )
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabTitles.enumerated()), id: \.offset) { index, title in
                Button(action: { selectedTab = index }) {
                    Text(title)
                        .font(.body)
                        .fontWeight(selectedTab == index ? .semibold : .regular)
                        .foregroundColor(selectedTab == index ? .blue : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            selectedTab == index ? Color.blue.opacity(0.1) : Color.clear
                        )
                }
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.bottom)
    }

    private var usersContent: some View {
        LeaderboardList(entries: usersData)
    }

    private var teamsContent: some View {
        LeaderboardList(entries: teamsData)
    }

    private var departmentsContent: some View {
        LeaderboardList(entries: departmentsData)
    }

    // Sample data
    private var usersData: [LeaderboardEntry] {
        [
            LeaderboardEntry(
                id: "1",
                name: "Emma Davis",
                score: "6,789",
                change: "+15.2%",
                progress: 0.85,
                color: .purple,
                subtitle: "Senior Sales Manager",
                type: .user
            ),
            LeaderboardEntry(
                id: "2",
                name: "Alex Rodriguez",
                score: "6,234",
                change: "+12.8%",
                progress: 0.78,
                color: .orange,
                subtitle: "Account Executive",
                type: .user
            ),
            LeaderboardEntry(
                id: "3",
                name: "Lisa Chen",
                score: "5,876",
                change: "+9.4%",
                progress: 0.72,
                color: .green,
                subtitle: "Marketing Specialist",
                type: .user
            ),
            LeaderboardEntry(
                id: "4",
                name: "David Wilson",
                score: "5,432",
                change: "+7.1%",
                progress: 0.68,
                color: .blue,
                subtitle: "Customer Success Manager",
                type: .user
            ),
            LeaderboardEntry(
                id: "5",
                name: "Sophie Brown",
                score: "5,123",
                change: "+5.3%",
                progress: 0.64,
                color: .red,
                subtitle: "Business Development",
                type: .user
            )
        ]
    }

    private var teamsData: [LeaderboardEntry] {
        [
            LeaderboardEntry(
                id: "1",
                name: "Alpha Team",
                score: "45,678",
                change: "+22.3%",
                progress: 0.92,
                color: .blue,
                subtitle: "12 members",
                type: .team
            ),
            LeaderboardEntry(
                id: "2",
                name: "Beta Squad",
                score: "42,134",
                change: "+18.7%",
                progress: 0.87,
                color: .green,
                subtitle: "10 members",
                type: .team
            ),
            LeaderboardEntry(
                id: "3",
                name: "Gamma Force",
                score: "39,876",
                change: "+15.2%",
                progress: 0.82,
                color: .orange,
                subtitle: "8 members",
                type: .team
            ),
            LeaderboardEntry(
                id: "4",
                name: "Delta Unit",
                score: "37,543",
                change: "+12.1%",
                progress: 0.78,
                color: .purple,
                subtitle: "15 members",
                type: .team
            )
        ]
    }

    private var departmentsData: [LeaderboardEntry] {
        [
            LeaderboardEntry(
                id: "1",
                name: "Sales Department",
                score: "156,789",
                change: "+25.4%",
                progress: 0.95,
                color: .green,
                subtitle: "45 employees",
                type: .department
            ),
            LeaderboardEntry(
                id: "2",
                name: "Marketing Department",
                score: "134,567",
                change: "+19.8%",
                progress: 0.89,
                color: .blue,
                subtitle: "32 employees",
                type: .department
            ),
            LeaderboardEntry(
                id: "3",
                name: "Product Development",
                score: "128,432",
                change: "+17.2%",
                progress: 0.86,
                color: .purple,
                subtitle: "28 employees",
                type: .department
            ),
            LeaderboardEntry(
                id: "4",
                name: "Customer Success",
                score: "115,876",
                change: "+14.6%",
                progress: 0.81,
                color: .orange,
                subtitle: "23 employees",
                type: .department
            )
        ]
    }
}

struct PodiumCard: View {
    let rank: Int
    let name: String
    let score: String
    let change: String
    let color: Color
    let isWinner: Bool

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: isWinner ? 80 : 70, height: isWinner ? 80 : 70)

                Text(getInitials(name))
                    .font(.system(size: isWinner ? 20 : 16, weight: .bold))
                    .foregroundColor(.blue)

                // Rank badge
                VStack {
                    HStack {
                        Spacer()
                        Circle()
                            .fill(color)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Text("\(rank)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                    }
                    Spacer()
                }

                // Winner crown
                if isWinner {
                    VStack {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                            .font(.title3)
                        Spacer()
                    }
                    .offset(y: -10)
                }
            }

            VStack(spacing: 4) {
                Text(name)
                    .font(isWinner ? .body : .caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)

                Text(score)
                    .font(isWinner ? .title2 : .body)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)

                Text(change)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: isWinner ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.1),
                radius: isWinner ? 12 : 8,
                x: 0,
                y: isWinner ? 4 : 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isWinner ? Color.yellow : Color.clear, lineWidth: isWinner ? 2 : 0)
        )
    }

    private func getInitials(_ name: String) -> String {
        let components = name.components(separatedBy: " ")
        return components.compactMap { $0.first }.map(String.init).joined()
    }
}

struct LeaderboardList: View {
    let entries: [LeaderboardEntry]

    var body: some View {
        List(Array(entries.enumerated()), id: \.element.id) { index, entry in
            LeaderboardRow(entry: entry, rank: index + 4) // Starting from 4th place
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(PlainListStyle())
    }
}

struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    let rank: Int

    var body: some View {
        HStack(spacing: 16) {
            // Rank badge
            Text("\(rank)")
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(getRankColor())
                .cornerRadius(8)

            // Avatar or icon
            Group {
                if entry.type == .user {
                    Circle()
                        .fill(entry.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(getInitials(entry.name))
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(entry.color)
                        )
                } else {
                    Circle()
                        .fill(entry.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: entry.type == .team ? "person.3.fill" : "building.2.fill")
                                .foregroundColor(entry.color)
                        )
                }
            }

            // Content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.name)
                            .font(.body)
                            .fontWeight(.bold)

                        if let subtitle = entry.subtitle {
                            Text(subtitle)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text(entry.score)
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(entry.color)

                        Text(entry.change)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(entry.change.hasPrefix("+") ? .green : .red)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background((entry.change.hasPrefix("+") ? Color.green : Color.red).opacity(0.1))
                            .cornerRadius(4)
                    }
                }

                // Progress bar
                ProgressView(value: entry.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .scaleEffect(x: 1, y: 0.5)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private func getRankColor() -> Color {
        if rank <= 5 {
            return .blue
        } else if rank <= 10 {
            return .green
        } else {
            return .gray
        }
    }

    private func getInitials(_ name: String) -> String {
        let components = name.components(separatedBy: " ")
        return components.compactMap { $0.first }.map(String.init).joined()
    }
}

struct FiltersSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedPeriod: String
    @State private var selectedRegion = "All Regions"
    @State private var selectedDepartment = "All Departments"
    @State private var showTopPerformersOnly = false

    private let regions = ["All Regions", "North America", "Europe", "Asia Pacific"]
    private let departments = ["All Departments", "Sales", "Marketing", "Product", "Support"]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Region")
                        .font(.headline)

                    Picker("Region", selection: $selectedRegion) {
                        ForEach(regions, id: \.self) { region in
                            Text(region)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Department")
                        .font(.headline)

                    Picker("Department", selection: $selectedDepartment) {
                        ForEach(departments, id: \.self) { department in
                            Text(department)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                HStack {
                    Text("Show only top performers")
                        .font(.body)

                    Spacer()

                    Toggle("", isOn: $showTopPerformersOnly)
                        .labelsHidden()
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Advanced Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Data models
struct LeaderboardEntry {
    let id: String
    let name: String
    let score: String
    let change: String
    let progress: Double
    let color: Color
    let subtitle: String?
    let type: EntryType
}

enum EntryType {
    case user
    case team
    case department
}

#Preview {
    NavigationView {
        LeaderboardScreen()
    }
}