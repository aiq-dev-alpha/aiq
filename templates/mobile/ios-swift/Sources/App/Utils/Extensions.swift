import Foundation
import SwiftUI

// MARK: - Date Extensions

extension Date {
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    var displayString: String {
        Self.displayFormatter.string(from: self)
    }

    var shortDisplayString: String {
        Self.shortFormatter.string(from: self)
    }
}

// MARK: - String Extensions

extension String {
    var isValidEmail: Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }

    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func truncated(to length: Int, suffix: String = "...") -> String {
        if count <= length {
            return self
        }
        return String(prefix(length)) + suffix
    }
}

// MARK: - Color Extensions

extension Color {
    // Custom colors for the app
    static let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let secondaryGray = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let successGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    static let warningOrange = Color(red: 0.9, green: 0.6, blue: 0.1)
    static let errorRed = Color(red: 0.8, green: 0.2, blue: 0.2)

    // Initialize from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Extensions

extension View {
    // Apply conditional modifiers
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    // Apply conditional modifiers with else clause
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }

    // Add corner radius to specific corners
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    // Add a border with specific color and width
    func border<S>(_ content: S, width: CGFloat = 1) -> some View where S : ShapeStyle {
        overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(content, lineWidth: width)
        )
    }

    // Add shadow with default values
    func defaultShadow(radius: CGFloat = 4, y: CGFloat = 2) -> some View {
        shadow(color: .black.opacity(0.1), radius: radius, x: 0, y: y)
    }

    // Hide/show view based on condition
    @ViewBuilder
    func isHidden(_ hidden: Bool) -> some View {
        if hidden {
            self.hidden()
        } else {
            self
        }
    }
}

// MARK: - Supporting Shapes

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Array Extensions

extension Array {
    // Safe subscript access
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    // Remove element at index safely
    mutating func remove(at index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return remove(at: index)
    }
}

// MARK: - URL Extensions

extension URL {
    // Check if URL is reachable
    var isReachable: Bool {
        guard let reachability = try? Reachability(hostname: host ?? "") else {
            return false
        }
        return reachability.connection != .unavailable
    }
}

// MARK: - UserDefaults Extensions

extension UserDefaults {
    // Type-safe UserDefaults access
    enum Key: String, CaseIterable {
        case selectedTheme = "selectedTheme"
        case pushNotificationsEnabled = "pushNotificationsEnabled"
        case emailNotificationsEnabled = "emailNotificationsEnabled"
        case biometricEnabled = "biometricEnabled"
        case onboardingCompleted = "onboardingCompleted"
    }

    func set<T>(_ value: T, for key: Key) {
        set(value, forKey: key.rawValue)
    }

    func value<T>(for key: Key, defaultValue: T) -> T {
        object(forKey: key.rawValue) as? T ?? defaultValue
    }

    func bool(for key: Key, defaultValue: Bool = false) -> Bool {
        object(forKey: key.rawValue) as? Bool ?? defaultValue
    }

    func string(for key: Key, defaultValue: String = "") -> String {
        object(forKey: key.rawValue) as? String ?? defaultValue
    }
}

// MARK: - Bundle Extensions

extension Bundle {
    var appName: String {
        infoDictionary?["CFBundleDisplayName"] as? String ??
        infoDictionary?["CFBundleName"] as? String ?? "Unknown"
    }

    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    var buildNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var bundleIdentifier: String {
        bundleIdentifier ?? "com.unknown.app"
    }
}

// MARK: - Reachability Helper

import Network

final class Reachability: ObservableObject {
    @Published var connection: Connection = .unavailable

    enum Connection {
        case unavailable
        case wifi
        case cellular
    }

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    init(hostname: String = "8.8.8.8") {
        startMonitoring()
    }

    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    if path.usesInterfaceType(.wifi) {
                        self?.connection = .wifi
                    } else if path.usesInterfaceType(.cellular) {
                        self?.connection = .cellular
                    } else {
                        self?.connection = .unavailable
                    }
                } else {
                    self?.connection = .unavailable
                }
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}