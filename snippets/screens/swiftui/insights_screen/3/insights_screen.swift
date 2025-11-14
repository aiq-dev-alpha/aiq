import SwiftUI
import Charts

struct InsightsScreen: View {
    @State private var selectedTimeframe = "This Month"
    @State private var selectedTab = 0

    private let timeframes = ["This Week", "This Month", "This Quarter", "This Year"]
    private let tabTitles = ["Overview", "Predictions", "Recommendations", "Anomalies"]

    var body: some View {
        VStack(spacing: 0) {
            tabSelector

            TabView(selection: $selectedTab) {
                overviewContent
                    .tag(0)

                predictionsContent
                    .tag(1)

                recommendationsContent
                    .tag(2)

                anomaliesContent
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .navigationTitle("AI Insights & Recommendations")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Picker("Timeframe", selection: $selectedTimeframe) {
                        ForEach(timeframes, id: \.self) { timeframe in
                            Text(timeframe)
                        }
                    }
                } label: {
                    Image(systemName: "calendar")
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
        ScrollView {
            LazyVStack(spacing: 20) {
                insightsScoreCard
                keyInsights
                trendingTopics
                performanceHighlights
            }
            .padding()
        }
    }

    private var predictionsContent: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                predictionsSummary
                forecastChart
                predictionCards
            }
            .padding()
        }
    }

    private var recommendationsContent: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                recommendationsSummary
                actionableRecommendations
                optimizationSuggestions
            }
            .padding()
        }
    }

    private var anomaliesContent: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                anomaliesSummary
                anomalyDetectionChart
                anomaliesList
            }
            .padding()
        }
    }

    private var insightsScoreCard: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "brain")
                    .font(.largeTitle)
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 4) {
                    Text("AI Insights Score")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Based on \(selectedTimeframe) data analysis")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                }

                Spacer()
            }

            HStack(spacing: 12) {
                ScoreCard(title: "Accuracy", score: "94%", icon: "target")
                ScoreCard(title: "Confidence", score: "87%", icon: "checkmark.shield")
                ScoreCard(title: "Relevance", score: "91%", icon: "arrow.up.right")
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.purple, Color.blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }

    private var keyInsights: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)

                Text("Key Insights")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            VStack(spacing: 12) {
                InsightItem(
                    title: "Revenue Growth Opportunity",
                    description: "Customer segment analysis shows 23% potential revenue increase in the 25-34 age group",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .green,
                    impact: "High Impact"
                )

                InsightItem(
                    title: "User Engagement Pattern",
                    description: "Mobile users are 40% more likely to complete purchases on weekends",
                    icon: "iphone",
                    color: .blue,
                    impact: "Medium Impact"
                )

                InsightItem(
                    title: "Seasonal Trend Detected",
                    description: "Holiday season preparation should begin 6 weeks earlier based on historical data",
                    icon: "calendar",
                    color: .orange,
                    impact: "High Impact"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var trendingTopics: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.blue)

                Text("Trending Topics")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                TopicChip(topic: "Mobile Commerce", growth: "+45%", color: .blue)
                TopicChip(topic: "Voice Search", growth: "+32%", color: .green)
                TopicChip(topic: "Social Shopping", growth: "+28%", color: .purple)
                TopicChip(topic: "Subscription Models", growth: "+25%", color: .orange)
                TopicChip(topic: "AR/VR Integration", growth: "+18%", color: .red)
                TopicChip(topic: "Personalization", growth: "+15%", color: .cyan)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var performanceHighlights: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)

                Text("Performance Highlights")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                HighlightCard(title: "Best Day", value: "Wednesday", icon: "calendar", color: .green)
                HighlightCard(title: "Peak Hour", value: "2-3 PM", icon: "clock", color: .blue)
                HighlightCard(title: "Top Channel", value: "Email Marketing", icon: "envelope", color: .purple)
                HighlightCard(title: "Best Segment", value: "Returning Users", icon: "arrow.clockwise", color: .orange)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var predictionsSummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "crystal.ball")
                    .foregroundColor(.purple)

                Text("AI Predictions Summary")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                PredictionSummaryCard(period: "Next Week", value: "+12.5%", metric: "Revenue Growth", color: .green)
                PredictionSummaryCard(period: "Next Month", value: "+8.3%", metric: "User Acquisition", color: .blue)
                PredictionSummaryCard(period: "Next Quarter", value: "+15.7%", metric: "Market Expansion", color: .purple)
                PredictionSummaryCard(period: "Confidence", value: "87%", metric: "Prediction Accuracy", color: .orange)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var forecastChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Revenue Forecast")
                    .font(.headline)
                    .fontWeight(.bold)

                Spacer()

                HStack(spacing: 16) {
                    LegendItem(color: .blue, label: "Historical")
                    LegendItem(color: .purple, label: "Predicted")
                }
            }

            Chart {
                // Historical data
                ForEach(Array(historicalData.enumerated()), id: \.offset) { index, value in
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

                // Predicted data
                ForEach(Array(predictedData.enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Month", monthLabels[index + 4]),
                        y: .value("Revenue", value)
                    )
                    .foregroundStyle(Color.purple)
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 3, dash: [8, 4]))

                    AreaMark(
                        x: .value("Month", monthLabels[index + 4]),
                        y: .value("Revenue", value)
                    )
                    .foregroundStyle(Color.purple.opacity(0.1))
                    .interpolationMethod(.catmullRom)
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
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var predictionCards: some View {
        VStack(spacing: 16) {
            PredictionCard(
                title: "Revenue Prediction",
                prediction: "Expected to reach $52K next month",
                confidence: "87% confidence",
                icon: "dollarsign.circle",
                color: .green,
                factors: [
                    "Peak sales expected on weekends",
                    "Mobile traffic driving 60% of revenue",
                    "Email campaigns showing 23% higher conversion"
                ]
            )

            PredictionCard(
                title: "User Growth Prediction",
                prediction: "2,340 new users expected next month",
                confidence: "82% confidence",
                icon: "person.2",
                color: .blue,
                factors: [
                    "Social media referrals increasing by 45%",
                    "Organic search traffic up 32%",
                    "Retention rate expected to improve to 68%"
                ]
            )
        }
    }

    private var recommendationsSummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "lightbulb.circle")
                    .foregroundColor(.green)

                Text("AI Recommendations Overview")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            HStack {
                RecommendationStat(label: "Active", value: "8", color: .blue)
                Spacer()
                RecommendationStat(label: "Implemented", value: "12", color: .green)
                Spacer()
                RecommendationStat(label: "Potential ROI", value: "+25%", color: .purple)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var actionableRecommendations: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Actionable Recommendations")
                .font(.headline)
                .fontWeight(.bold)

            VStack(spacing: 16) {
                RecommendationCard(
                    title: "Optimize Mobile Experience",
                    description: "Mobile users have 32% higher bounce rate. Implement faster loading and simplified checkout.",
                    priority: "High Priority",
                    priorityColor: .red,
                    impact: "Expected Impact: +18% mobile conversion",
                    actions: ["Implement lazy loading", "Simplify forms", "Add mobile payment options"]
                )

                RecommendationCard(
                    title: "Personalize Email Campaigns",
                    description: "Segmented campaigns show 67% better performance. Create behavior-based segments.",
                    priority: "Medium Priority",
                    priorityColor: .orange,
                    impact: "Expected Impact: +12% email revenue",
                    actions: ["Create user segments", "Dynamic content", "A/B test subject lines"]
                )

                RecommendationCard(
                    title: "Expand Social Media Presence",
                    description: "Instagram and TikTok show highest engagement rates for your target demographic.",
                    priority: "Low Priority",
                    priorityColor: .green,
                    impact: "Expected Impact: +8% brand awareness",
                    actions: ["Create Instagram shop", "TikTok marketing campaign", "Influencer partnerships"]
                )
            }
        }
    }

    private var optimizationSuggestions: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.purple)

                Text("Quick Optimization Wins")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            VStack(spacing: 12) {
                OptimizationItem(suggestion: "Reduce page load time by 1.2s", benefit: "15% bounce rate improvement", color: .red)
                OptimizationItem(suggestion: "Add exit-intent popups", benefit: "8% conversion increase", color: .orange)
                OptimizationItem(suggestion: "Enable push notifications", benefit: "12% user engagement boost", color: .blue)
                OptimizationItem(suggestion: "Implement retargeting campaigns", benefit: "20% return visitor increase", color: .green)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var anomaliesSummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.orange)

                Text("Anomaly Detection Summary")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            HStack {
                AnomalyStat(label: "Detected", value: "3", color: .red)
                Spacer()
                AnomalyStat(label: "Resolved", value: "7", color: .green)
                Spacer()
                AnomalyStat(label: "Monitoring", value: "2", color: .orange)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var anomalyDetectionChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Anomaly Detection Over Time")
                .font(.headline)
                .fontWeight(.bold)

            Chart {
                ForEach(Array(anomalyData.enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Day", dayLabels[index]),
                        y: .value("Anomalies", value)
                    )
                    .foregroundStyle(Color.red)
                    .interpolationMethod(.linear)

                    if value > 3 {
                        PointMark(
                            x: .value("Day", dayLabels[index]),
                            y: .value("Anomalies", value)
                        )
                        .foregroundStyle(Color.red)
                        .symbolSize(100)
                    }
                }
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let intValue = value.as(Double.self) {
                            Text("\(Int(intValue))")
                        }
                    }
                    AxisGridLine()
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var anomaliesList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Anomalies")
                .font(.headline)
                .fontWeight(.bold)

            VStack(spacing: 12) {
                AnomalyCard(
                    title: "Unusual Traffic Spike",
                    description: "Traffic increased by 300% between 2-4 PM yesterday",
                    severity: "High",
                    severityColor: .red,
                    status: "Under Investigation",
                    timestamp: Date().addingTimeInterval(-86400)
                )

                AnomalyCard(
                    title: "Conversion Rate Drop",
                    description: "Mobile conversion rate decreased by 45% in the last 6 hours",
                    severity: "Medium",
                    severityColor: .orange,
                    status: "Monitoring",
                    timestamp: Date().addingTimeInterval(-21600)
                )

                AnomalyCard(
                    title: "Payment Processing Delays",
                    description: "Average payment processing time increased by 200%",
                    severity: "Low",
                    severityColor: .yellow,
                    status: "Resolved",
                    timestamp: Date().addingTimeInterval(-43200)
                )
            }
        }
    }

    // Sample data
    private let historicalData: [Double] = [35, 42, 38, 48, 45]
    private let predictedData: [Double] = [52, 48, 55, 51]
    private let monthLabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug"]
    private let dayLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let anomalyData: [Double] = [2, 1, 4, 2, 1, 3, 1]
}

// MARK: - Supporting Views

struct ScoreCard: View {
    let title: String
    let score: String
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)

            Text(score)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity)
    }
}

struct InsightItem: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let impact: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16))
                .frame(width: 32, height: 32)
                .background(color.opacity(0.1))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(.body)
                        .fontWeight(.semibold)

                    Spacer()

                    Text(impact)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(getImpactColor(impact))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(getImpactColor(impact).opacity(0.1))
                        .cornerRadius(4)
                }

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private func getImpactColor(_ impact: String) -> Color {
        switch impact {
        case "High Impact": return .red
        case "Medium Impact": return .orange
        case "Low Impact": return .green
        default: return .gray
        }
    }
}

struct TopicChip: View {
    let topic: String
    let growth: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(topic)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(color)

            Text(growth)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

struct HighlightCard: View {
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
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(color)
                .multilineTextAlignment(.center)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.05))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

struct PredictionSummaryCard: View {
    let period: String
    let value: String
    let metric: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(period)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(color)

            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(metric)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

struct PredictionCard: View {
    let title: String
    let prediction: String
    let confidence: String
    let icon: String
    let color: Color
    let factors: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                    .frame(width: 32, height: 32)
                    .background(color.opacity(0.1))
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)

                    Text(confidence)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }

            Text(prediction)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(color)

            VStack(alignment: .leading, spacing: 8) {
                Text("Key Factors:")
                    .font(.body)
                    .fontWeight(.medium)

                ForEach(factors, id: \.self) { factor in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "arrow.right")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(factor)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

struct RecommendationStat: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct RecommendationCard: View {
    let title: String
    let description: String
    let priority: String
    let priorityColor: Color
    let impact: String
    let actions: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)

                Spacer()

                Text(priority)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(priorityColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(priorityColor.opacity(0.1))
                    .cornerRadius(8)
            }

            Text(description)
                .font(.body)
                .foregroundColor(.secondary)

            Text(impact)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)

            VStack(alignment: .leading, spacing: 8) {
                Text("Suggested Actions:")
                    .font(.body)
                    .fontWeight(.medium)

                ForEach(actions, id: \.self) { action in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle")
                            .font(.caption)
                            .foregroundColor(.green)

                        Text(action)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            HStack {
                Button("Implement") {
                    // Implementation action
                }
                .buttonStyle(.borderedProminent)

                Button("Learn More") {
                    // Learn more action
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

struct OptimizationItem: View {
    let suggestion: String
    let benefit: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
                .padding(.top, 6)

            VStack(alignment: .leading, spacing: 4) {
                Text(suggestion)
                    .font(.body)
                    .fontWeight(.medium)

                Text(benefit)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(color)
            }
        }
    }
}

struct AnomalyStat: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct AnomalyCard: View {
    let title: String
    let description: String
    let severity: String
    let severityColor: Color
    let status: String
    let timestamp: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.body)
                    .fontWeight(.bold)

                Spacer()

                Text(severity)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(severityColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(severityColor.opacity(0.1))
                    .cornerRadius(8)
            }

            Text(description)
                .font(.body)
                .foregroundColor(.secondary)

            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(formatTimestamp(timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text(status)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(status == "Resolved" ? .green : .orange)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(severityColor.opacity(0.3), lineWidth: 1)
                .padding(.leading, -4)
        )
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private func formatTimestamp(_ timestamp: Date) -> String {
        let now = Date()
        let interval = now.timeIntervalSince(timestamp)

        if interval < 3600 {
            return "\(Int(interval / 60))h ago"
        } else {
            return "\(Int(interval / 86400))d ago"
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
        InsightsScreen()
    }
}