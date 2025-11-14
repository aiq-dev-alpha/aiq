import SwiftUI
import Charts

struct AnalyticsScreen: View {
    @State private var selectedPeriod = "7d"
    @State private var selectedTab = 0

    private let periods = ["24h", "7d", "30d", "90d"]
    private let tabTitles = ["Overview", "Revenue", "Users"]

    var body: some View {
        VStack(spacing: 0) {
            tabSelector

            ScrollView {
                LazyVStack(spacing: 20) {
                    switch selectedTab {
                    case 0:
                        overviewContent
                    case 1:
                        revenueContent
                    case 2:
                        usersContent
                    default:
                        overviewContent
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Analytics")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Picker("Period", selection: $selectedPeriod) {
                        Text("Last 24 hours").tag("24h")
                        Text("Last 7 days").tag("7d")
                        Text("Last 30 days").tag("30d")
                        Text("Last 90 days").tag("90d")
                    }
                } label: {
                    Image(systemName: "calendar")
                }
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

    private var overviewContent: some View {
        VStack(spacing: 20) {
            metricsRow(
                metrics: [
                    ("Page Views", "45.2K", "+12.5%", Color.blue),
                    ("Sessions", "12.8K", "+8.2%", Color.green),
                    ("Bounce Rate", "32.1%", "-2.1%", Color.orange)
                ]
            )

            performanceChart

            trafficSourcesChart

            topPagesChart
        }
    }

    private var revenueContent: some View {
        VStack(spacing: 20) {
            metricsRow(
                metrics: [
                    ("Total Revenue", "$125.4K", "+15.2%", Color.green),
                    ("Avg. Order", "$87.50", "+3.1%", Color.blue)
                ]
            )

            revenueChart

            revenueBreakdownChart
        }
    }

    private var usersContent: some View {
        VStack(spacing: 20) {
            metricsRow(
                metrics: [
                    ("Total Users", "25.8K", "+22.1%", Color.blue),
                    ("New Users", "3.2K", "+18.5%", Color.green)
                ]
            )

            userGrowthChart

            userDemographicsChart
        }
    }

    private func metricsRow(metrics: [(title: String, value: String, change: String, color: Color)]) -> some View {
        HStack(spacing: 12) {
            ForEach(Array(metrics.enumerated()), id: \.offset) { _, metric in
                MetricCard(
                    title: metric.title,
                    value: metric.value,
                    change: metric.change,
                    color: metric.color
                )
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var performanceChart: some View {
        ChartContainer(title: "Performance Overview") {
            Chart {
                ForEach(Array(performanceData.enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Day", dayLabels[index]),
                        y: .value("Value", value)
                    )
                    .foregroundStyle(Color.blue)
                    .interpolationMethod(.catmullRom)

                    AreaMark(
                        x: .value("Day", dayLabels[index]),
                        y: .value("Value", value)
                    )
                    .foregroundStyle(Color.blue.opacity(0.1))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let intValue = value.as(Double.self) {
                            Text("\(Int(intValue))K")
                        }
                    }
                    AxisGridLine()
                }
            }
        }
    }

    private var trafficSourcesChart: some View {
        ChartContainer(title: "Traffic Sources") {
            HStack {
                Chart {
                    ForEach(trafficSources, id: \.name) { source in
                        SectorMark(
                            angle: .value("Percentage", source.value),
                            innerRadius: .ratio(0.4),
                            outerRadius: .ratio(1.0)
                        )
                        .foregroundStyle(source.color)
                    }
                }
                .frame(height: 200)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(trafficSources, id: \.name) { source in
                        HStack {
                            Circle()
                                .fill(source.color)
                                .frame(width: 12, height: 12)

                            Text(source.name)
                                .font(.caption)

                            Spacer()

                            Text("\(Int(source.value))%")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                    }
                }
                .padding(.leading)
            }
        }
    }

    private var topPagesChart: some View {
        ChartContainer(title: "Top Performing Pages") {
            Chart {
                ForEach(topPages, id: \.name) { page in
                    BarMark(
                        x: .value("Page", page.name),
                        y: .value("Views", page.views)
                    )
                    .foregroundStyle(Color.blue)
                    .cornerRadius(4)
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisValueLabel()
                    AxisGridLine()
                }
            }
        }
    }

    private var revenueChart: some View {
        ChartContainer(title: "Revenue Trend") {
            Chart {
                ForEach(Array(revenueData.enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Month", monthLabels[index]),
                        y: .value("Revenue", value)
                    )
                    .foregroundStyle(Color.green)
                    .interpolationMethod(.catmullRom)

                    AreaMark(
                        x: .value("Month", monthLabels[index]),
                        y: .value("Revenue", value)
                    )
                    .foregroundStyle(Color.green.opacity(0.1))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let intValue = value.as(Double.self) {
                            Text("$\(Int(intValue))K")
                        }
                    }
                    AxisGridLine()
                }
            }
        }
    }

    private var revenueBreakdownChart: some View {
        ChartContainer(title: "Revenue by Category") {
            HStack {
                Chart {
                    ForEach(revenueCategories, id: \.name) { category in
                        SectorMark(
                            angle: .value("Amount", category.amount),
                            innerRadius: .ratio(0.4),
                            outerRadius: .ratio(1.0)
                        )
                        .foregroundStyle(category.color)
                    }
                }
                .frame(height: 200)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(revenueCategories, id: \.name) { category in
                        HStack {
                            Circle()
                                .fill(category.color)
                                .frame(width: 12, height: 12)

                            Text(category.name)
                                .font(.caption)

                            Spacer()

                            Text("$\(Int(category.amount))K")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                    }
                }
                .padding(.leading)
            }
        }
    }

    private var userGrowthChart: some View {
        ChartContainer(title: "User Growth") {
            Chart {
                ForEach(Array(userGrowthData.enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Month", monthLabels[index]),
                        y: .value("Users", value)
                    )
                    .foregroundStyle(Color.blue)
                    .interpolationMethod(.catmullRom)

                    AreaMark(
                        x: .value("Month", monthLabels[index]),
                        y: .value("Users", value)
                    )
                    .foregroundStyle(Color.blue.opacity(0.1))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let intValue = value.as(Double.self) {
                            Text("\(Int(intValue))K")
                        }
                    }
                    AxisGridLine()
                }
            }
        }
    }

    private var userDemographicsChart: some View {
        ChartContainer(title: "User Demographics") {
            Chart {
                ForEach(userDemographics, id: \.ageGroup) { demographic in
                    BarMark(
                        x: .value("Age Group", demographic.ageGroup),
                        y: .value("Users", demographic.users)
                    )
                    .foregroundStyle(Color.purple)
                    .cornerRadius(4)
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisValueLabel()
                    AxisGridLine()
                }
            }
        }
    }

    // Sample data
    private let performanceData: [Double] = [35, 42, 38, 51, 47, 62, 58]
    private let dayLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    private let trafficSources = [
        TrafficSource(name: "Direct", value: 40, color: .blue),
        TrafficSource(name: "Social", value: 30, color: .green),
        TrafficSource(name: "Search", value: 20, color: .orange),
        TrafficSource(name: "Referral", value: 10, color: .purple)
    ]

    private let topPages = [
        PageData(name: "Home", views: 85),
        PageData(name: "About", views: 62),
        PageData(name: "Products", views: 71),
        PageData(name: "Contact", views: 48),
        PageData(name: "Blog", views: 55)
    ]

    private let revenueData: [Double] = [28, 35, 31, 40, 38, 44, 52]
    private let monthLabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"]

    private let revenueCategories = [
        RevenueCategory(name: "Products", amount: 45, color: .blue),
        RevenueCategory(name: "Services", amount: 30, color: .green),
        RevenueCategory(name: "Subscriptions", amount: 25, color: .orange)
    ]

    private let userGrowthData: [Double] = [18, 22, 19, 28, 26, 32, 38]

    private let userDemographics = [
        UserDemographic(ageGroup: "18-24", users: 25),
        UserDemographic(ageGroup: "25-34", users: 42),
        UserDemographic(ageGroup: "35-44", users: 38),
        UserDemographic(ageGroup: "45-54", users: 28),
        UserDemographic(ageGroup: "55+", users: 15)
    ]
}

struct MetricCard: View {
    let title: String
    let value: String
    let change: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(change)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(change.hasPrefix("+") ? .green : .red)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

struct ChartContainer<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)

            content
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

// Data models
struct TrafficSource {
    let name: String
    let value: Double
    let color: Color
}

struct PageData {
    let name: String
    let views: Int
}

struct RevenueCategory {
    let name: String
    let amount: Double
    let color: Color
}

struct UserDemographic {
    let ageGroup: String
    let users: Int
}

#Preview {
    NavigationView {
        AnalyticsScreen()
    }
}