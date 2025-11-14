import SwiftUI
import Charts

struct StatsScreen: View {
    @State private var selectedTimeframe = "This Month"
    @State private var selectedTab = 0

    private let timeframes = ["Today", "This Week", "This Month", "This Quarter", "This Year"]
    private let tabTitles = ["Overview", "Performance", "Engagement", "Conversion"]

    var body: some View {
        VStack(spacing: 0) {
            tabSelector

            ScrollView {
                LazyVStack(spacing: 20) {
                    switch selectedTab {
                    case 0:
                        overviewContent
                    case 1:
                        performanceContent
                    case 2:
                        engagementContent
                    case 3:
                        conversionContent
                    default:
                        overviewContent
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Detailed Statistics")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Picker("Timeframe", selection: $selectedTimeframe) {
                        ForEach(timeframes, id: \.self) { timeframe in
                            Text(timeframe)
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
    }

    private var tabSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(Array(tabTitles.enumerated()), id: \.offset) { index, title in
                    Button(action: { selectedTab = index }) {
                        Text(title)
                            .font(.body)
                            .fontWeight(selectedTab == index ? .semibold : .regular)
                            .foregroundColor(selectedTab == index ? .blue : .secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                selectedTab == index ? Color.blue.opacity(0.1) : Color.clear
                            )
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
    }

    private var overviewContent: some View {
        VStack(spacing: 20) {
            kpiGrid
            trendChart
            comparisonChart
            topMetricsTable
        }
    }

    private var performanceContent: some View {
        VStack(spacing: 20) {
            performanceMetrics
            loadTimeChart
            errorRateChart
            performanceBreakdown
        }
    }

    private var engagementContent: some View {
        VStack(spacing: 20) {
            engagementMetrics
            sessionDurationChart
            pageViewsChart
            userBehaviorHeatmap
        }
    }

    private var conversionContent: some View {
        VStack(spacing: 20) {
            conversionMetrics
            conversionFunnelChart
            goalCompletionChart
            conversionBreakdown
        }
    }

    private var kpiGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
            KPICard(title: "Total Revenue", value: "$245,890", change: "+18.5%", icon: "dollarsign.circle.fill", color: .green)
            KPICard(title: "Active Users", value: "12,456", change: "+12.3%", icon: "person.2.fill", color: .blue)
            KPICard(title: "Conversion Rate", value: "3.24%", change: "+0.8%", icon: "chart.line.uptrend.xyaxis", color: .orange)
            KPICard(title: "Avg Session", value: "4m 32s", change: "+15s", icon: "clock.fill", color: .purple)
        }
    }

    private var trendChart: some View {
        ChartContainer(title: "Revenue Trend - \(selectedTimeframe)") {
            VStack(alignment: .trailing, spacing: 8) {
                HStack(spacing: 16) {
                    LegendItem(color: .blue, label: "Current Period")
                    LegendItem(color: .orange, label: "Previous Period")
                }

                Chart {
                    // Current period
                    ForEach(Array(currentPeriodData.enumerated()), id: \.offset) { index, value in
                        LineMark(
                            x: .value("Month", monthLabels[index]),
                            y: .value("Revenue", value)
                        )
                        .foregroundStyle(Color.blue)
                        .interpolationMethod(.catmullRom)

                        AreaMark(
                            x: .value("Month", monthLabels[index]),
                            y: .value("Revenue", value)
                        )
                        .foregroundStyle(Color.blue.opacity(0.1))
                        .interpolationMethod(.catmullRom)
                    }

                    // Previous period
                    ForEach(Array(previousPeriodData.enumerated()), id: \.offset) { index, value in
                        LineMark(
                            x: .value("Month", monthLabels[index]),
                            y: .value("Revenue", value)
                        )
                        .foregroundStyle(Color.orange)
                        .interpolationMethod(.catmullRom)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                    }
                }
                .frame(height: 250)
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
    }

    private var comparisonChart: some View {
        ChartContainer(title: "Performance Comparison") {
            Chart {
                ForEach(comparisonMetrics, id: \.name) { metric in
                    BarMark(
                        x: .value("Metric", metric.name),
                        y: .value("Current", metric.current)
                    )
                    .foregroundStyle(Color.blue)
                    .cornerRadius(4)

                    BarMark(
                        x: .value("Metric", metric.name),
                        y: .value("Previous", metric.previous)
                    )
                    .foregroundStyle(Color.orange)
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
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let intValue = value.as(Double.self) {
                            Text("\(Int(intValue))%")
                        }
                    }
                    AxisGridLine()
                }
            }
        }
    }

    private var topMetricsTable: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top Performing Metrics")
                .font(.headline)
                .fontWeight(.bold)

            VStack(spacing: 0) {
                HStack {
                    Text("Metric")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Value")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .frame(width: 80, alignment: .trailing)

                    Text("Change")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .frame(width: 80, alignment: .trailing)

                    Text("Trend")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .frame(width: 60, alignment: .trailing)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))

                ForEach(topMetrics, id: \.name) { metric in
                    HStack {
                        Text(metric.name)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(metric.value)
                            .font(.body)
                            .frame(width: 80, alignment: .trailing)

                        Text(metric.change)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(metric.change.hasPrefix("+") ? .green : .red)
                            .frame(width: 80, alignment: .trailing)

                        Image(systemName: metric.change.hasPrefix("+") ? "arrow.up.right" : "arrow.down.right")
                            .font(.caption)
                            .foregroundColor(metric.change.hasPrefix("+") ? .green : .red)
                            .frame(width: 60, alignment: .trailing)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)

                    if metric.name != topMetrics.last?.name {
                        Divider()
                    }
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    // Performance content
    private var performanceMetrics: some View {
        HStack(spacing: 12) {
            KPICard(title: "Avg Load Time", value: "2.4s", change: "-0.3s", icon: "speedometer", color: .green)
                .frame(maxWidth: .infinity)

            KPICard(title: "Error Rate", value: "0.12%", change: "-0.05%", icon: "exclamationmark.triangle.fill", color: .red)
                .frame(maxWidth: .infinity)
        }
    }

    private var loadTimeChart: some View {
        createGenericChart(title: "Load Time Trend", data: loadTimeData, color: .green, yAxisSuffix: "s")
    }

    private var errorRateChart: some View {
        createGenericChart(title: "Error Rate", data: errorRateData, color: .red, yAxisSuffix: "%")
    }

    private var performanceBreakdown: some View {
        topMetricsTable // Reuse the table with performance-specific data
    }

    // Engagement content
    private var engagementMetrics: some View {
        HStack(spacing: 12) {
            KPICard(title: "Avg Session", value: "4m 32s", change: "+15s", icon: "clock.fill", color: .blue)
                .frame(maxWidth: .infinity)

            KPICard(title: "Pages/Session", value: "3.8", change: "+0.2", icon: "doc.text.fill", color: .green)
                .frame(maxWidth: .infinity)
        }
    }

    private var sessionDurationChart: some View {
        createGenericChart(title: "Session Duration", data: sessionDurationData, color: .blue, yAxisSuffix: "min")
    }

    private var pageViewsChart: some View {
        createGenericChart(title: "Page Views", data: pageViewsData, color: .purple, yAxisSuffix: "K")
    }

    private var userBehaviorHeatmap: some View {
        topMetricsTable // Placeholder for heatmap
    }

    // Conversion content
    private var conversionMetrics: some View {
        HStack(spacing: 12) {
            KPICard(title: "Conv. Rate", value: "3.24%", change: "+0.8%", icon: "chart.line.uptrend.xyaxis", color: .green)
                .frame(maxWidth: .infinity)

            KPICard(title: "Goal Complete", value: "1,234", change: "+156", icon: "flag.fill", color: .blue)
                .frame(maxWidth: .infinity)
        }
    }

    private var conversionFunnelChart: some View {
        ChartContainer(title: "Conversion Funnel") {
            Chart {
                ForEach(funnelData, id: \.stage) { data in
                    BarMark(
                        x: .value("Stage", data.stage),
                        y: .value("Users", data.users)
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

    private var goalCompletionChart: some View {
        createGenericChart(title: "Goal Completion", data: goalCompletionData, color: .green, yAxisSuffix: "")
    }

    private var conversionBreakdown: some View {
        topMetricsTable // Reuse for conversion metrics
    }

    private func createGenericChart(title: String, data: [Double], color: Color, yAxisSuffix: String) -> some View {
        ChartContainer(title: title) {
            Chart {
                ForEach(Array(data.enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Day", dayLabels[index]),
                        y: .value("Value", value)
                    )
                    .foregroundStyle(color)
                    .interpolationMethod(.catmullRom)

                    AreaMark(
                        x: .value("Day", dayLabels[index]),
                        y: .value("Value", value)
                    )
                    .foregroundStyle(color.opacity(0.1))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let intValue = value.as(Double.self) {
                            Text("\(Int(intValue))\(yAxisSuffix)")
                        }
                    }
                    AxisGridLine()
                }
            }
        }
    }

    // Sample data
    private let currentPeriodData: [Double] = [35, 42, 38, 48, 45, 52, 48]
    private let previousPeriodData: [Double] = [28, 35, 31, 40, 38, 44, 41]
    private let monthLabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"]
    private let dayLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    private let comparisonMetrics = [
        ComparisonMetric(name: "Revenue", current: 85, previous: 78),
        ComparisonMetric(name: "Users", current: 92, previous: 88),
        ComparisonMetric(name: "Orders", current: 76, previous: 65),
        ComparisonMetric(name: "Sessions", current: 88, previous: 82)
    ]

    private let topMetrics = [
        TopMetric(name: "Page Views", value: "45.2K", change: "+12.5%"),
        TopMetric(name: "Unique Visitors", value: "28.1K", change: "+8.3%"),
        TopMetric(name: "Bounce Rate", value: "32.1%", change: "-2.1%"),
        TopMetric(name: "Session Duration", value: "4:32", change: "+15.2%"),
        TopMetric(name: "Conversion Rate", value: "3.24%", change: "+8.7%")
    ]

    private let loadTimeData: [Double] = [2.8, 2.6, 2.4, 2.7, 2.5, 2.3, 2.4]
    private let errorRateData: [Double] = [0.15, 0.13, 0.12, 0.14, 0.11, 0.10, 0.12]
    private let sessionDurationData: [Double] = [4.2, 4.5, 4.3, 4.8, 4.6, 4.9, 4.7]
    private let pageViewsData: [Double] = [42, 45, 43, 48, 46, 51, 49]
    private let goalCompletionData: [Double] = [1150, 1200, 1180, 1250, 1230, 1280, 1240]

    private let funnelData = [
        FunnelData(stage: "Visit", users: 10000),
        FunnelData(stage: "Interest", users: 6500),
        FunnelData(stage: "Intent", users: 3200),
        FunnelData(stage: "Purchase", users: 1200)
    ]
}

struct KPICard: View {
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
                    .foregroundColor(change.hasPrefix("+") || change.hasPrefix("-") && !change.contains("%") ? .green : .red)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background((change.hasPrefix("+") || change.hasPrefix("-") && !change.contains("%") ? Color.green : Color.red).opacity(0.1))
                    .cornerRadius(4)
            }

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .padding()
        .frame(height: 120)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

struct LegendItem: View {
    let color: Color
    let label: String

    var body: some View {
        HStack(spacing: 6) {
            Rectangle()
                .fill(color)
                .frame(width: 12, height: 12)
                .cornerRadius(2)

            Text(label)
                .font(.caption)
        }
    }
}

// Data models
struct ComparisonMetric {
    let name: String
    let current: Double
    let previous: Double
}

struct TopMetric {
    let name: String
    let value: String
    let change: String
}

struct FunnelData {
    let stage: String
    let users: Int
}

#Preview {
    NavigationView {
        StatsScreen()
    }
}