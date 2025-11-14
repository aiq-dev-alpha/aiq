import SwiftUI

struct ReportsScreen: View {
    @State private var selectedCategory = "All"
    @State private var selectedStatus = "All"
    @State private var showingCreateReport = false
    @State private var showingFilters = false
    @State private var reports = sampleReports

    private let categories = ["All", "Financial", "Analytics", "Performance", "Marketing", "Security"]
    private let statuses = ["All", "Completed", "Generating", "Scheduled", "Failed"]

    var body: some View {
        VStack(spacing: 0) {
            summaryCards
                .padding()

            filtersSection
                .padding(.horizontal)

            reportsList
        }
        .navigationTitle("Reports")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { showingFilters = true }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }

                Button(action: { showingCreateReport = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingCreateReport) {
            CreateReportView()
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(
                selectedCategory: $selectedCategory,
                selectedStatus: $selectedStatus,
                categories: categories,
                statuses: statuses
            )
        }
    }

    private var summaryCards: some View {
        HStack(spacing: 12) {
            SummaryCard(
                title: "Total Reports",
                value: "\(reports.count)",
                icon: "doc.text.fill",
                color: .blue
            )

            SummaryCard(
                title: "Completed",
                value: "\(reports.filter { $0.status == .completed }.count)",
                icon: "checkmark.circle.fill",
                color: .green
            )

            SummaryCard(
                title: "Pending",
                value: "\(reports.filter { $0.status != .completed }.count)",
                icon: "clock.fill",
                color: .orange
            )
        }
    }

    private var filtersSection: some View {
        HStack(spacing: 12) {
            Menu {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
            } label: {
                HStack {
                    Text(selectedCategory)
                        .foregroundColor(.primary)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }

            Menu {
                Picker("Status", selection: $selectedStatus) {
                    ForEach(statuses, id: \.self) { status in
                        Text(status)
                    }
                }
            } label: {
                HStack {
                    Text(selectedStatus)
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
        }
        .padding(.bottom)
    }

    private var reportsList: some View {
        List(filteredReports, id: \.id) { report in
            ReportCard(report: report) {
                handleReportAction(report: report)
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(PlainListStyle())
    }

    private var filteredReports: [Report] {
        reports.filter { report in
            let categoryMatch = selectedCategory == "All" || report.category == selectedCategory
            let statusMatch = selectedStatus == "All" || report.status.rawValue == selectedStatus
            return categoryMatch && statusMatch
        }
    }

    private func handleReportAction(report: Report) {
        // Handle report actions (view, download, etc.)
    }

    private static let sampleReports: [Report] = [
        Report(
            id: "1",
            title: "Monthly Revenue Report",
            description: "Comprehensive revenue analysis for the current month",
            category: "Financial",
            status: .completed,
            createdDate: Date().addingTimeInterval(-86400 * 2),
            completedDate: Date().addingTimeInterval(-86400),
            size: "2.5 MB",
            type: "PDF"
        ),
        Report(
            id: "2",
            title: "User Engagement Analytics",
            description: "Detailed user behavior and engagement metrics",
            category: "Analytics",
            status: .generating,
            createdDate: Date().addingTimeInterval(-14400),
            completedDate: nil,
            size: "1.8 MB",
            type: "Excel"
        ),
        Report(
            id: "3",
            title: "Performance Metrics Q1",
            description: "First quarter performance overview and KPIs",
            category: "Performance",
            status: .completed,
            createdDate: Date().addingTimeInterval(-86400 * 7),
            completedDate: Date().addingTimeInterval(-86400 * 6),
            size: "3.2 MB",
            type: "PDF"
        ),
        Report(
            id: "4",
            title: "Customer Segmentation Analysis",
            description: "Customer demographic and behavioral segmentation",
            category: "Marketing",
            status: .scheduled,
            createdDate: Date().addingTimeInterval(-86400),
            completedDate: nil,
            size: "TBD",
            type: "Excel"
        ),
        Report(
            id: "5",
            title: "Security Audit Report",
            description: "Monthly security assessment and recommendations",
            category: "Security",
            status: .failed,
            createdDate: Date().addingTimeInterval(-86400 * 3),
            completedDate: nil,
            size: "N/A",
            type: "PDF"
        )
    ]
}

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(12)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

struct ReportCard: View {
    let report: Report
    let onAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(report.title)
                        .font(.headline)
                        .fontWeight(.bold)

                    Text(report.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }

                Spacer()

                StatusBadge(status: report.status)
            }

            HStack(spacing: 8) {
                InfoChip(text: report.category, icon: "folder.fill", color: .blue)
                InfoChip(text: report.type, icon: "doc.fill", color: .green)
                InfoChip(text: report.size, icon: "internaldrive.fill", color: .purple)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.secondary)
                        .font(.caption)

                    Text("Created: \(report.createdDate, formatter: dateFormatter)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                if let completedDate = report.completedDate {
                    HStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(.secondary)
                            .font(.caption)

                        Text("Completed: \(completedDate, formatter: dateFormatter)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            HStack {
                if report.status == .completed {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Download")
                        }
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .cornerRadius(6)
                    }
                }

                if report.status == .failed {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Retry")
                        }
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.orange)
                        .cornerRadius(6)
                    }
                }

                Button(action: {}) {
                    HStack {
                        Image(systemName: "eye")
                        Text("View Details")
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                }

                Spacer()

                Menu {
                    Button("Duplicate", action: {})
                    Button("Share", action: {})
                    Button("Delete", role: .destructive, action: {})
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

struct StatusBadge: View {
    let status: ReportStatus

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: statusIcon)
                .font(.caption)

            Text(status.rawValue)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(statusColor)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(statusColor.opacity(0.1))
        .cornerRadius(8)
    }

    private var statusIcon: String {
        switch status {
        case .completed:
            return "checkmark.circle.fill"
        case .generating:
            return "hourglass"
        case .scheduled:
            return "calendar"
        case .failed:
            return "exclamationmark.triangle.fill"
        }
    }

    private var statusColor: Color {
        switch status {
        case .completed:
            return .green
        case .generating:
            return .blue
        case .scheduled:
            return .orange
        case .failed:
            return .red
        }
    }
}

struct InfoChip: View {
    let text: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))

            Text(text)
                .font(.system(size: 11))
                .fontWeight(.medium)
        }
        .foregroundColor(color)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(color.opacity(0.1))
        .cornerRadius(6)
    }
}

struct CreateReportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory = "Financial"

    private let categories = ["Financial", "Analytics", "Performance", "Marketing", "Security"]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Report Title")
                        .font(.headline)

                    TextField("Enter report title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)

                    TextField("Enter description", text: $description, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Category")
                        .font(.headline)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Create New Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Generate") {
                        dismiss()
                        // Handle report generation
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

struct FiltersView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCategory: String
    @Binding var selectedStatus: String
    let categories: [String]
    let statuses: [String]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Category")
                        .font(.headline)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Status")
                        .font(.headline)

                    Picker("Status", selection: $selectedStatus) {
                        ForEach(statuses, id: \.self) { status in
                            Text(status)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Filter Reports")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        selectedCategory = "All"
                        selectedStatus = "All"
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
struct Report {
    let id: String
    let title: String
    let description: String
    let category: String
    let status: ReportStatus
    let createdDate: Date
    let completedDate: Date?
    let size: String
    let type: String
}

enum ReportStatus: String, CaseIterable {
    case completed = "Completed"
    case generating = "Generating"
    case scheduled = "Scheduled"
    case failed = "Failed"
}

#Preview {
    NavigationView {
        ReportsScreen()
    }
}