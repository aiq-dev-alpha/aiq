import SwiftUI

struct ThemeSettingsScreen: View {
    @State private var selectedTheme = "System"
    @State private var selectedAccentColor = Color.blue
    @State private var dynamicColors = false
    @State private var highContrast = false
    @State private var textScale: Double = 1.0

    private let themeOptions = ["Light", "Dark", "System"]
    private let accentColors: [Color] = [.blue, .red, .green, .orange, .purple, .teal, .pink, .indigo]

    var body: some View {
        List {
            Section("Theme Mode") {
                ForEach(themeOptions, id: \.self) { theme in
                    HStack {
                        Text(theme)
                        Spacer()
                        if selectedTheme == theme {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedTheme = theme
                    }
                }
            }

            Section("Accent Color") {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                    ForEach(accentColors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle()
                                    .stroke(Color.primary, lineWidth: selectedAccentColor == color ? 3 : 0)
                            )
                            .onTapGesture {
                                selectedAccentColor = color
                            }
                    }
                }
                .padding(.vertical, 8)

                Toggle("Dynamic Colors", isOn: $dynamicColors)
            }

            Section("Accessibility") {
                Toggle("High Contrast", isOn: $highContrast)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Text Size")
                        Spacer()
                        Text("\(Int(textScale * 100))%")
                            .foregroundColor(.secondary)
                    }

                    Slider(value: $textScale, in: 0.8...1.5, step: 0.1)

                    Text("Sample text at current size")
                        .font(.system(size: 16 * textScale))
                        .padding(.top, 4)
                }
            }

            Section("Preview") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Theme Preview")
                        .font(.headline)
                        .fontWeight(.bold)

                    HStack {
                        Circle()
                            .fill(selectedAccentColor)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "person")
                                    .foregroundColor(.white)
                            )

                        VStack(alignment: .leading) {
                            Text("Sample User")
                                .font(.body)
                                .fontWeight(.medium)
                            Text("This is how your theme will look")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Image(systemName: "heart.fill")
                            .foregroundColor(selectedAccentColor)
                    }

                    HStack {
                        Button("Primary Button") {}
                            .buttonStyle(.borderedProminent)
                            .tint(selectedAccentColor)

                        Button("Secondary Button") {}
                            .buttonStyle(.bordered)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }

            Section {
                Button("Reset to Defaults") {
                    selectedTheme = "System"
                    selectedAccentColor = .blue
                    dynamicColors = false
                    highContrast = false
                    textScale = 1.0
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Theme Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ThemeSettingsScreen()
    }
}