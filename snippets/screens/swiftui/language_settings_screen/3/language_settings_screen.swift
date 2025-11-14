import SwiftUI

struct LanguageSettingsScreen: View {
    @State private var selectedLanguage = "English"
    @State private var selectedRegion = "United States"
    @State private var autoDetectLanguage = false

    private let languages = [
        "English": "🇺🇸",
        "Spanish": "🇪🇸",
        "French": "🇫🇷",
        "German": "🇩🇪",
        "Italian": "🇮🇹",
        "Portuguese": "🇵🇹",
        "Chinese": "🇨🇳",
        "Japanese": "🇯🇵",
        "Korean": "🇰🇷"
    ]

    var body: some View {
        List {
            Section("Language") {
                Toggle("Auto-detect Language", isOn: $autoDetectLanguage)

                if !autoDetectLanguage {
                    NavigationLink(destination: LanguagePickerView(selectedLanguage: $selectedLanguage)) {
                        HStack {
                            Text(languages[selectedLanguage] ?? "🌐")
                            Text("App Language")
                            Spacer()
                            Text(selectedLanguage)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }

            Section("Region & Format") {
                HStack {
                    Text("Region")
                    Spacer()
                    Text(selectedRegion)
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Date Format")
                    Spacer()
                    Text("MM/DD/YYYY")
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Time Format")
                    Spacer()
                    Text("12-hour")
                        .foregroundColor(.secondary)
                }
            }

            Section("Additional Settings") {
                NavigationLink("Download Language Pack", destination: LanguagePackView())
                NavigationLink("Translation Settings", destination: TranslationSettingsView())
            }
        }
        .navigationTitle("Language & Region")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LanguagePickerView: View {
    @Binding var selectedLanguage: String
    @Environment(\.dismiss) private var dismiss

    private let languages = [
        "English": "🇺🇸",
        "Spanish": "🇪🇸",
        "French": "🇫🇷",
        "German": "🇩🇪",
        "Italian": "🇮🇹",
        "Portuguese": "🇵🇹",
        "Chinese": "🇨🇳",
        "Japanese": "🇯🇵",
        "Korean": "🇰🇷"
    ]

    var body: some View {
        List {
            ForEach(languages.keys.sorted(), id: \.self) { language in
                HStack {
                    Text(languages[language]!)
                    Text(language)
                    Spacer()
                    if selectedLanguage == language {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedLanguage = language
                    dismiss()
                }
            }
        }
        .navigationTitle("Select Language")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LanguagePackView: View {
    var body: some View {
        List {
            LanguagePackRow(language: "English", size: "45 MB", isDownloaded: true)
            LanguagePackRow(language: "Spanish", size: "38 MB", isDownloaded: false)
            LanguagePackRow(language: "French", size: "42 MB", isDownloaded: false)
        }
        .navigationTitle("Language Packs")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LanguagePackRow: View {
    let language: String
    let size: String
    let isDownloaded: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(language)
                    .font(.body)
                Text(size)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if isDownloaded {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Button("Download") {
                    // Download language pack
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

struct TranslationSettingsView: View {
    @State private var autoTranslate = true
    @State private var showOriginal = false

    var body: some View {
        List {
            Toggle("Auto-translate", isOn: $autoTranslate)
            Toggle("Show original text", isOn: $showOriginal)
        }
        .navigationTitle("Translation")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        LanguageSettingsScreen()
    }
}