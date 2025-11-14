import SwiftUI
import Charts

struct ChartDetailScreen: View {
    @State private var selectedTimeframe = "7D"
    @State private var selectedMetric = "Revenue"
    @State private var showComparison = false
    @State private var selectedTab = 0

    private let timeframes = ["1D", "7D", "1M", "3M", "6M", "1Y"]
    private let metrics = ["Revenue", "Users", "Orders", "Sessions", "Conversion"]
    private let tabTitles = ["Chart", "Data", "Insights"]

    var body: some View {
        VStack(spacing: 0) {
            controlsSection
                .padding()

            tabSelector

            TabView(selection: $selectedTab) {
                chartContent
                    .tag(0)

                dataContent
                    .tag(1)

                insightsContent
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .navigationTitle("\(selectedMetric) Analysis")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: shareChart) {
                    Image(systemName: "square.and.arrow.up")
                }

                Button(action: exportChart) {
                    Image(systemName: "square.and.arrow.down")
                }

                Menu {
                    Button("Fullscreen", action: {})
                    Button("Refresh Data", action: {})
                    Button("Chart Settings", action: {})
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }

    private var controlsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Menu {
                    Picker("Metric", selection: $selectedMetric) {
                        ForEach(metrics, id: \.self) { metric in
                            HStack {
                                Image(systemName: getMetricIcon(metric))
                                Text(metric)
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: getMetricIcon(selectedMetric))
                        Text(selectedMetric)
                        Image(systemName: "chevron.down")
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }

                Spacer()

                HStack {
                    Text("Compare")
                    Toggle("", isOn: $showComparison)
                        .labelsHidden()
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(timeframes, id: \.self) { timeframe in
                        Button(action: { selectedTimeframe = timeframe }) {
                            Text(timeframe)
                                .font(.body)
                                .fontWeight(selectedTimeframe == timeframe ? .semibold : .regular)
                                .foregroundColor(selectedTimeframe == timeframe ? .white : .primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedTimeframe == timeframe ? Color.blue : Color(.systemGray6))
                                .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal)
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
    }

    private var chartContent: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                mainChart
                quickStats
                if showComparison {
                    comparisonChart
                }
                trendAnalysis
            }
            .padding()
        }
    }

    private var dataContent: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                dataSummary
                dataTable
                dataExportOptions
            }
            .padding()
        }
    }

    private var insightsContent: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                keyInsights
                trendPredictions
                recommendations
            }
            .padding()
        }
    }

    private var mainChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("\(selectedMetric) Over Time")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                chartTypeButtons
            }

            Chart {
                ForEach(Array(getChartData().enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Time", getTimeLabels()[index]),
                        y: .value("Value", value)
                    )
                    .foregroundStyle(getMetricColor(selectedMetric))
                    .interpolationMethod(.catmullRom)

                    AreaMark(
                        x: .value("Time", getTimeLabels()[index]),
                        y: .value("Value", value)
                    )
                    .foregroundStyle(getMetricColor(selectedMetric).opacity(0.1))
                    .interpolationMethod(.catmullRom)
                }

                if showComparison {
                    ForEach(Array(getComparisonData().enumerated()), id: \.offset) { index, value in
                        LineMark(
                            x: .value("Time", getTimeLabels()[index]),
                            y: .value("Value", value)
                        )
                        .foregroundStyle(Color.orange)
                        .interpolationMethod(.catmullRom)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                    }
                }
            }
            .frame(height: 300)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let doubleValue = value.as(Double.self) {
                            Text(formatYAxisValue(doubleValue))
                        }
                    }
                    AxisGridLine()
                }
            }

            if showComparison {
                HStack(spacing: 20) {
                    LegendItem(color: getMetricColor(selectedMetric), label: "Current Period")
                    LegendItem(color: .orange, label: "Previous Period")
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var chartTypeButtons: some View {
        HStack(spacing: 8) {
            Button(action: {}) {
                Image(systemName: "chart.xyaxis.line")
                    .foregroundColor(.blue)
            }

            Button(action: {}) {
                Image(systemName: "chart.bar")
                    .foregroundColor(.gray)
            }

            Button(action: {}) {
                Image(systemName: "chart.pie")
                    .foregroundColor(.gray)
            }
        }
    }

    private var quickStats: some View {
        HStack(spacing: 12) {
            StatCard(title: "Current Value", value: getCurrentValue(), icon: getMetricIcon(selectedMetric), color: getMetricColor(selectedMetric))
            StatCard(title: "Change", value: getChangeValue(), icon: "arrow.up.right", color: .green)
            StatCard(title: "Average", value: getAverageValue(), icon: "chart.line.uptrend.xyaxis", color: .blue)
        }
    }

    private var comparisonChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Period Comparison")
                .font(.headline)
                .fontWeight(.bold)

            Chart {
                ForEach(Array(getComparisonChartData().enumerated()), id: \.offset) { index, data in
                    BarMark(
                        x: .value("Period", "Week \(index + 1)"),
                        y: .value("Value", data)
                    )
                    .foregroundStyle(getMetricColor(selectedMetric))
                    .cornerRadius(4)
                }
            }
            .frame(height: 150)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var trendAnalysis: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Trend Analysis")
                .font(.headline)
                .fontWeight(.bold)

            VStack(spacing: 12) {
                TrendItem(title: "Overall Trend", value: "Upward", icon: "arrow.up.right", color: .green)
                TrendItem(title: "Volatility", value: "Moderate", icon: "chart.line.uptrend.xyaxis", color: .orange)
                TrendItem(title: "Seasonality", value: "Weekly Pattern", icon: "calendar", color: .blue)
                TrendItem(title: "Forecast", value: "Positive Growth", icon: "crystal.ball", color: .purple)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var dataSummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Data Summary")
                .font(.headline)
                .fontWeight(.bold)

            HStack {
                DataSummaryItem(title: "Total Points", value: "30")
                DataSummaryItem(title: "Min Value", value: "1.2K")
                DataSummaryItem(title: "Max Value", value: "8.7K")
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var dataTable: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Raw Data")
                .font(.headline)
                .fontWeight(.bold)

            VStack(spacing: 0) {
                HStack {
                    Text("Date")
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Value")
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Text("Change")
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding()
                .background(Color(.systemGray6))

                ForEach(0..<5) { index in
                    HStack {
                        Text("Mar \(15 + index)")
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("\(3000 + (index * 200))")
                            .frame(maxWidth: .infinity, alignment: .center)

                        Text("+\(5 + index).2%")
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding()

                    if index < 4 {
                        Divider()
                    }
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var dataExportOptions: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Export Options")
                .font(.headline)
                .fontWeight(.bold)

            HStack(spacing: 8) {
                ExportButton(title: "CSV", icon: "doc.text", action: exportCSV)
                ExportButton(title: "Excel", icon: "tablecells", action: exportExcel)
                ExportButton(title: "PDF", icon: "doc.richtext", action: exportPDF)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var keyInsights: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Key Insights")
                .font(.headline)
                .fontWeight(.bold)

            VStack(spacing: 12) {
                InsightItem(
                    title: "Peak Performance",
                    description: "Highest \(selectedMetric) was recorded on March 15th",
                    icon: "star.fill",
                    color: .orange
                )

                InsightItem(
                    title: "Growth Pattern",
                    description: "18.5% increase compared to previous period",
                    icon: "arrow.up.right",
                    color: .green
                )

                InsightItem(
                    title: "Weekly Trend",
                    description: "Consistent growth every Wednesday",
                    icon: "calendar",
                    color: .blue
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var trendPredictions: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("AI Predictions")
                .font(.headline)
                .fontWeight(.bold)

            VStack(spacing: 12) {
                PredictionItem(period: "Next Week", value: "+12.3%", color: .green)
                PredictionItem(period: "Next Month", value: "+8.7%", color: .blue)
                PredictionItem(period: "Next Quarter", value: "+15.2%", color: .purple)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var recommendations: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommendations")
                .font(.headline)
                .fontWeight(.bold)

            VStack(spacing: 12) {
                RecommendationItem(
                    title: "Focus on Wednesdays",
                    description: "Amplify marketing efforts on Wednesdays for maximum impact",
                    icon: "lightbulb.fill"
                )

                RecommendationItem(
                    title: "Monitor Volatility",
                    description: "Set up alerts for significant deviations from trend",
                    icon: "bell.fill"
                )

                RecommendationItem(
                    title: "Optimize Peak Hours",
                    description: "Increase resource allocation during peak performance times",
                    icon: "clock.fill"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    // Helper functions
    private func getMetricIcon(_ metric: String) -> String {
        switch metric {
        case "Revenue": return "dollarsign.circle.fill"
        case "Users": return "person.2.fill"
        case "Orders": return "cart.fill"
        case "Sessions": return "clock.fill"
        case "Conversion": return "chart.line.uptrend.xyaxis"
        default: return "chart.bar.fill"
        }
    }

    private func getMetricColor(_ metric: String) -> Color {
        switch metric {
        case "Revenue": return .green
        case "Users": return .blue
        case "Orders": return .orange
        case "Sessions": return .purple
        case "Conversion": return .red
        default: return .blue
        }
    }

    private func getChartData() -> [Double] {
        [3500, 4200, 3800, 5100, 4700, 6200, 5800]
    }

    private func getComparisonData() -> [Double] {
        [2800, 3500, 3100, 4000, 3800, 4400, 4100]
    }

    private func getComparisonChartData() -> [Double] {
        [85, 78, 92, 88]
    }

    private func getTimeLabels() -> [String] {
        ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    }

    private func formatYAxisValue(_ value: Double) -> String {
        if value >= 1000 {
            return "\(Int(value / 1000))K"
        }
        return "\(Int(value))"
    }

    private func getCurrentValue() -> String {
        switch selectedMetric {
        case "Revenue": return "$5.8K"
        case "Users": return "2.4K"
        case "Orders": return "156"
        case "Sessions": return "3.2K"
        case "Conversion": return "3.24%"
        default: return "N/A"
        }
    }

    private func getChangeValue() -> String {
        "+18.5%"
    }

    private func getAverageValue() -> String {
        switch selectedMetric {
        case "Revenue": return "$4.7K"
        case "Users": return "2.1K"
        case "Orders": return "142"
        case "Sessions": return "2.8K"
        case "Conversion": return "3.12%"
        default: return "N/A"
        }
    }

    private func shareChart() {
        // Implement chart sharing
    }

    private func exportChart() {
        // Implement chart export
    }

    private func exportCSV() {
        // Implement CSV export
    }

    private func exportExcel() {
        // Implement Excel export
    }

    private func exportPDF() {
        // Implement PDF export
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 1)
    }
}

struct TrendItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16))

            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(value)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }
}

struct DataSummaryItem: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ExportButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.body)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
        }
    }
}

struct InsightItem: View {
    let title: String
    let description: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16))
                .frame(width: 24, height: 24)
                .background(color.opacity(0.1))
                .cornerRadius(6)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct PredictionItem: View {
    let period: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Text(period)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(value)
                .fontWeight(.bold)
                .foregroundColor(color)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(color.opacity(0.1))
                .cornerRadius(6)
        }
    }
}

struct RecommendationItem: View {
    let title: String
    let description: String
    let icon: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.system(size: 16))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
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

#Preview {
    NavigationView {
        ChartDetailScreen()
    }
}