import SwiftUI
import Charts

struct DashboardScreen: View {
    @State private var selectedTimeframe = "This Week"
    @State private var isRefreshing = false

    private let timeframes = ["Today", "This Week", "This Month", "This Quarter"]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    welcomeSection
                    statsCardsGrid
                    quickChart
                    recentActivitySection
                    quickActionsSection
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Timeframe", selection: $selectedTimeframe) {
                            ForEach(timeframes, id: \.self) { timeframe in
                                Text(timeframe)
                            }
                        }
                    } label: {
                        Image(systemName: "calendar")
                    }

                    Button(action: refreshData) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .refreshable {
                await performRefresh()
            }
        }
    }

    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome back!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Here's what's happening with your data today.")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                }

                Spacer()

                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.blue, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }

    private var statsCardsGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
            StatCard(title: "Total Users", value: "12,456", change: "+12%", icon: "person.2.fill", color: .blue)
            StatCard(title: "Revenue", value: "$45,678", change: "+8%", icon: "dollarsign.circle.fill", color: .green)
            StatCard(title: "Orders", value: "1,234", change: "+15%", icon: "cart.fill", color: .orange)
            StatCard(title: "Conversion", value: "3.2%", change: "+2%", icon: "chart.line.uptrend.xyaxis", color: .purple)
        }
    }

    private var quickChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Revenue Trend")
                    .font(.headline)
                    .fontWeight(.bold)

                Spacer()

                Text(selectedTimeframe)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Chart {
                ForEach(Array(sampleChartData.enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Day", index),
                        y: .value("Revenue", value)
                    )
                    .foregroundStyle(Color.blue)
                    .interpolationMethod(.catmullRom)

                    AreaMark(
                        x: .value("Day", index),
                        y: .value("Revenue", value)
                    )
                    .foregroundStyle(Color.blue.opacity(0.1))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 200)
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisValueLabel()
                    AxisGridLine()
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.headline)
                .fontWeight(.bold)

            LazyVStack(spacing: 12) {
                ActivityRow(
                    icon: "bag.fill",
                    iconColor: .blue,
                    title: "New order received",
                    time: "2 minutes ago"
                )

                ActivityRow(
                    icon: "person.badge.plus",
                    iconColor: .green,
                    title: "User registration spike",
                    time: "15 minutes ago"
                )

                ActivityRow(
                    icon: "creditcard.fill",
                    iconColor: .purple,
                    title: "Payment processed",
                    time: "1 hour ago"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.bold)

            HStack(spacing: 12) {
                NavigationLink(destination: AnalyticsScreen()) {
                    ActionButton(
                        title: "View Analytics",
                        icon: "chart.bar.fill",
                        color: .blue
                    )
                }

                NavigationLink(destination: ReportsScreen()) {
                    ActionButton(
                        title: "Generate Report",
                        icon: "doc.text.fill",
                        color: .green
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private let sampleChartData: [Double] = [3500, 4200, 3800, 5100, 4700, 6200, 5800]

    private func refreshData() {
        isRefreshing = true
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isRefreshing = false
        }
    }

    private func performRefresh() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let change: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 32, height: 32)
                    .background(color.opacity(0.1))
                    .cornerRadius(8)

                Spacer()

                Text(change)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(4)
            }

            Spacer()

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
        .frame(height: 120)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

struct ActivityRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let time: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(iconColor)
                .frame(width: 32, height: 32)
                .background(iconColor.opacity(0.1))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)

                Text(time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))

            Text(title)
                .font(.body)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundColor(.white)
        .background(color)
        .cornerRadius(8)
    }
}

#Preview {
    DashboardScreen()
}