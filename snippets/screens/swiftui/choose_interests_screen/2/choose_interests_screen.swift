import SwiftUI

struct ChooseInterestsScreen: View {
    @State private var selectedInterests: Set<String> = []
    @State private var contentOpacity: Double = 0
    @State private var contentOffset: CGFloat = 50

    private let minSelections = 3
    private let categories: [InterestCategory] = [
        InterestCategory(
            name: "AI & Technology",
            interests: ["Machine Learning", "Deep Learning", "Computer Vision", "Natural Language Processing", "Robotics", "Data Science"],
            color: Color(red: 0.39, green: 0.40, blue: 0.95),
            icon: "cpu"
        ),
        InterestCategory(
            name: "Science & Research",
            interests: ["Physics", "Mathematics", "Chemistry", "Biology", "Neuroscience", "Psychology"],
            color: Color(red: 0.55, green: 0.36, blue: 0.96),
            icon: "atom"
        ),
        InterestCategory(
            name: "Programming",
            interests: ["Python", "JavaScript", "Flutter/Dart", "Swift", "Java", "React"],
            color: Color(red: 0.02, green: 0.71, blue: 0.83),
            icon: "chevron.left.forwardslash.chevron.right"
        ),
        InterestCategory(
            name: "Business & Innovation",
            interests: ["Entrepreneurship", "Product Management", "Digital Marketing", "Strategy", "Finance", "Leadership"],
            color: Color(red: 0.06, green: 0.73, blue: 0.51),
            icon: "building.2"
        )
    ]

    var body: some View {
        VStack {
            // Header
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.39, green: 0.40, blue: 0.95),
                                        Color(red: 0.55, green: 0.36, blue: 0.96)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 48, height: 48)

                        Image(systemName: "heart.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Choose Your Interests")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.22))

                        Text("Help us personalize your experience")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
                    }

                    Spacer()
                }

                // Info banner
                HStack(spacing: 8) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))

                    Text("Select at least \(minSelections) interests (\(selectedInterests.count) selected)")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
                }
                .padding(12)
                .background(Color(red: 0.95, green: 0.96, blue: 0.97))
                .cornerRadius(12)
            }
            .padding(.horizontal, 24)

            // Categories
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(categories, id: \.name) { category in
                        CategorySection(
                            category: category,
                            selectedInterests: $selectedInterests
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
            }

            // Continue button
            Button(action: continueToProfile) {
                HStack {
                    Text("Continue with \(selectedInterests.count) interests")
                        .font(.system(size: 16, weight: .semibold))

                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(selectedInterests.count >= minSelections ? .white : Color(red: 0.61, green: 0.64, blue: 0.69))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(selectedInterests.count >= minSelections ?
                           Color(red: 0.39, green: 0.40, blue: 0.95) :
                           Color(red: 0.90, green: 0.91, blue: 0.92)
                )
                .cornerRadius(16)
                .disabled(selectedInterests.count < minSelections)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .opacity(contentOpacity)
        .offset(y: contentOffset)
        .background(Color.white)
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        withAnimation(.easeOut(duration: 1.0)) {
            contentOpacity = 1
            contentOffset = 0
        }
    }

    private func continueToProfile() {
        if selectedInterests.count >= minSelections {
            // Navigate to profile setup
            // NavigationManager.shared.navigate(to: .profileSetup)
        }
    }
}

struct CategorySection: View {
    let category: InterestCategory
    @Binding var selectedInterests: Set<String>

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category header
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(category.color.opacity(0.1))
                        .frame(width: 32, height: 32)

                    Image(systemName: category.icon)
                        .font(.system(size: 18))
                        .foregroundColor(category.color)
                }

                Text(category.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.22))

                Spacer()
            }

            // Interest chips
            FlexibleView(
                data: category.interests,
                spacing: 8,
                alignment: .leading
            ) { interest in
                InterestChip(
                    text: interest,
                    isSelected: selectedInterests.contains(interest),
                    color: category.color,
                    onTap: {
                        toggleInterest(interest)
                    }
                )
            }
        }
    }

    private func toggleInterest(_ interest: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if selectedInterests.contains(interest) {
                selectedInterests.remove(interest)
            } else {
                selectedInterests.insert(interest)
            }
        }
    }
}

struct InterestChip: View {
    let text: String
    let isSelected: Bool
    let color: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .transition(.scale.combined(with: .opacity))
                }

                Text(text)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .white : Color(red: 0.42, green: 0.45, blue: 0.50))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? color : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? color : Color(red: 0.90, green: 0.91, blue: 0.92), lineWidth: 1.5)
            )
            .cornerRadius(20)
            .shadow(color: isSelected ? color.opacity(0.3) : .clear, radius: 8, x: 0, y: 2)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: isSelected)
        }
    }
}

struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content

    @State private var availableWidth: CGFloat = 0

    var body: some View {
        ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
            Color.clear
                .frame(height: 1)
                .readSize { size in
                    availableWidth = size.width
                }

            FlexibleViewLayout(
                data: data,
                spacing: spacing,
                availableWidth: availableWidth,
                content: content
            )
        }
    }
}

struct FlexibleViewLayout<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let availableWidth: CGFloat
    let content: (Data.Element) -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(computeRows(), id: \.self) { rowData in
                HStack(spacing: spacing) {
                    ForEach(rowData, id: \.self) { item in
                        content(item)
                    }
                    Spacer(minLength: 0)
                }
            }
        }
    }

    private func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = []
        var currentRow: [Data.Element] = []
        var currentWidth: CGFloat = 0

        for item in data {
            let itemWidth = estimatedWidth(for: item)

            if currentWidth + itemWidth + spacing > availableWidth && !currentRow.isEmpty {
                rows.append(currentRow)
                currentRow = [item]
                currentWidth = itemWidth
            } else {
                currentRow.append(item)
                currentWidth += itemWidth + (currentRow.count > 1 ? spacing : 0)
            }
        }

        if !currentRow.isEmpty {
            rows.append(currentRow)
        }

        return rows
    }

    private func estimatedWidth(for item: Data.Element) -> CGFloat {
        // Estimate width based on text length
        let text = String(describing: item)
        return CGFloat(text.count * 8 + 40) // Rough estimation
    }
}

struct InterestCategory {
    let name: String
    let interests: [String]
    let color: Color
    let icon: String
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

#Preview {
    ChooseInterestsScreen()
}