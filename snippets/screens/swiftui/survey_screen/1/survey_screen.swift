import SwiftUI

struct SurveyScreen: View {
    @State private var currentQuestionIndex = 0
    @State private var responses: [String: Any] = [:]
    @State private var isCompleted = false
    @State private var showResults = false

    private let questions = SurveyQuestion.sampleQuestions

    var body: some View {
        NavigationView {
            if isCompleted {
                surveyCompletionView
            } else {
                surveyQuestionView
            }
        }
    }

    private var surveyQuestionView: some View {
        VStack {
            // Progress indicator
            ProgressView(value: Double(currentQuestionIndex + 1), total: Double(questions.count))
                .progressViewStyle(LinearProgressViewStyle())
                .padding()

            HStack {
                Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Question category badge
                    HStack {
                        Text(questions[currentQuestionIndex].category)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(12)
                            .foregroundColor(.blue)
                        Spacer()
                    }

                    // Question title
                    Text(questions[currentQuestionIndex].title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)

                    // Question text
                    Text(questions[currentQuestionIndex].question)
                        .font(.body)
                        .foregroundColor(.secondary)

                    if questions[currentQuestionIndex].isRequired {
                        Text("* Required")
                            .font(.caption)
                            .foregroundColor(.red)
                    }

                    // Question content based on type
                    questionContentView(for: questions[currentQuestionIndex])
                }
                .padding()
            }

            // Navigation buttons
            HStack {
                if currentQuestionIndex > 0 {
                    Button("Previous") {
                        withAnimation {
                            currentQuestionIndex -= 1
                        }
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }

                Spacer()

                Button(currentQuestionIndex == questions.count - 1 ? "Finish Survey" : "Next") {
                    if currentQuestionIndex == questions.count - 1 {
                        completesurvey()
                    } else {
                        withAnimation {
                            currentQuestionIndex += 1
                        }
                    }
                }
                .disabled(!isCurrentQuestionAnswered())
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding()
        }
        .navigationTitle("Survey")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var surveyCompletionView: some View {
        VStack(spacing: 30) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)

            VStack(spacing: 16) {
                Text("Thank You!")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Your responses have been submitted successfully. We appreciate your time and valuable feedback.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 16) {
                Text("Survey Summary")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Questions answered:")
                        Spacer()
                        Text("\(responses.count) of \(questions.count)")
                            .fontWeight(.semibold)
                    }

                    HStack {
                        Text("Completion rate:")
                        Spacer()
                        Text("\(Int(Double(responses.count) / Double(questions.count) * 100))%")
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }

            Button("Close") {
                // Handle close action
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
        .navigationTitle("Survey Complete")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func questionContentView(for question: SurveyQuestion) -> some View {
        switch question.type {
        case .singleChoice, .multipleChoice:
            choiceQuestionView(for: question)
        case .checkbox:
            checkboxQuestionView(for: question)
        case .scale:
            scaleQuestionView(for: question)
        case .text:
            textQuestionView(for: question)
        case .yesNo:
            yesNoQuestionView(for: question)
        }
    }

    @ViewBuilder
    private func choiceQuestionView(for question: SurveyQuestion) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(question.options ?? [], id: \.self) { option in
                Button(action: {
                    responses[question.id] = option
                }) {
                    HStack {
                        Image(systemName: responses[question.id] as? String == option ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(.blue)
                        Text(option)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(responses[question.id] as? String == option ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    @ViewBuilder
    private func checkboxQuestionView(for question: SurveyQuestion) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(question.options ?? [], id: \.self) { option in
                Button(action: {
                    var selectedOptions = responses[question.id] as? [String] ?? []
                    if selectedOptions.contains(option) {
                        selectedOptions.removeAll { $0 == option }
                    } else {
                        selectedOptions.append(option)
                    }
                    responses[question.id] = selectedOptions
                }) {
                    HStack {
                        let selectedOptions = responses[question.id] as? [String] ?? []
                        Image(systemName: selectedOptions.contains(option) ? "checkmark.square.fill" : "square")
                            .foregroundColor(.blue)
                        Text(option)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke((responses[question.id] as? [String])?.contains(option) == true ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    @ViewBuilder
    private func scaleQuestionView(for question: SurveyQuestion) -> some View {
        VStack(spacing: 16) {
            let currentValue = responses[question.id] as? Double ?? Double(question.scaleMin ?? 1)

            Text("Rating: \(Int(currentValue))/\(question.scaleMax ?? 10)")
                .font(.headline)

            Slider(
                value: Binding(
                    get: { responses[question.id] as? Double ?? Double(question.scaleMin ?? 1) },
                    set: { responses[question.id] = $0 }
                ),
                in: Double(question.scaleMin ?? 1)...Double(question.scaleMax ?? 10),
                step: 1
            )
            .accentColor(.blue)

            HStack {
                Text("\(question.scaleMin ?? 1)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Text("\(question.scaleMax ?? 10)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
    }

    @ViewBuilder
    private func textQuestionView(for question: SurveyQuestion) -> some View {
        TextEditor(text: Binding(
            get: { responses[question.id] as? String ?? "" },
            set: { responses[question.id] = $0 }
        ))
        .frame(minHeight: 100)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func yesNoQuestionView(for question: SurveyQuestion) -> some View {
        HStack(spacing: 20) {
            Button(action: {
                responses[question.id] = true
            }) {
                HStack {
                    Image(systemName: responses[question.id] as? Bool == true ? "largecircle.fill.circle" : "circle")
                        .foregroundColor(.blue)
                    Text("Yes")
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(responses[question.id] as? Bool == true ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                )
            }
            .buttonStyle(PlainButtonStyle())

            Button(action: {
                responses[question.id] = false
            }) {
                HStack {
                    Image(systemName: responses[question.id] as? Bool == false ? "largecircle.fill.circle" : "circle")
                        .foregroundColor(.blue)
                    Text("No")
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(responses[question.id] as? Bool == false ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    private func isCurrentQuestionAnswered() -> Bool {
        let question = questions[currentQuestionIndex]
        let response = responses[question.id]

        if !question.isRequired { return true }

        switch question.type {
        case .singleChoice, .multipleChoice, .yesNo:
            return response != nil
        case .checkbox:
            return (response as? [String])?.isEmpty == false
        case .scale:
            return response != nil
        case .text:
            return !(response as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }

    private func completeSurvey() {
        withAnimation {
            isCompleted = true
        }
    }
}

struct SurveyQuestion {
    let id: String
    let title: String
    let type: QuestionType
    let question: String
    let isRequired: Bool
    let options: [String]?
    let scaleMin: Int?
    let scaleMax: Int?
    let placeholder: String?
    let category: String

    enum QuestionType {
        case singleChoice
        case multipleChoice
        case checkbox
        case scale
        case text
        case yesNo
    }

    static let sampleQuestions = [
        SurveyQuestion(
            id: "demographics",
            title: "Tell us about yourself",
            type: .singleChoice,
            question: "What is your age group?",
            isRequired: true,
            options: ["18-24", "25-34", "35-44", "45-54", "55-64", "65+"],
            scaleMin: nil,
            scaleMax: nil,
            placeholder: nil,
            category: "Demographics"
        ),
        SurveyQuestion(
            id: "usage_frequency",
            title: "Usage Patterns",
            type: .singleChoice,
            question: "How often do you use our app?",
            isRequired: true,
            options: ["Daily", "Weekly", "Monthly", "Rarely", "First time"],
            scaleMin: nil,
            scaleMax: nil,
            placeholder: nil,
            category: "Usage"
        ),
        SurveyQuestion(
            id: "satisfaction_rating",
            title: "Satisfaction Rating",
            type: .scale,
            question: "How satisfied are you with our service?",
            isRequired: true,
            options: nil,
            scaleMin: 1,
            scaleMax: 10,
            placeholder: nil,
            category: "Feedback"
        ),
        SurveyQuestion(
            id: "features_used",
            title: "Feature Usage",
            type: .checkbox,
            question: "Which features do you use most? (Select all that apply)",
            isRequired: false,
            options: ["Dashboard", "Reports", "Settings", "Search", "Notifications", "Export Data"],
            scaleMin: nil,
            scaleMax: nil,
            placeholder: nil,
            category: "Features"
        ),
        SurveyQuestion(
            id: "improvement_suggestions",
            title: "Your Feedback",
            type: .text,
            question: "What improvements would you like to see?",
            isRequired: false,
            options: nil,
            scaleMin: nil,
            scaleMax: nil,
            placeholder: "Share your thoughts and suggestions...",
            category: "Feedback"
        ),
        SurveyQuestion(
            id: "recommendation",
            title: "Final Question",
            type: .yesNo,
            question: "Would you recommend our app to others?",
            isRequired: true,
            options: nil,
            scaleMin: nil,
            scaleMax: nil,
            placeholder: nil,
            category: "Recommendation"
        )
    ]
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.gray.opacity(0.2))
            .foregroundColor(.primary)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SurveyScreen_Previews: PreviewProvider {
    static var previews: some View {
        SurveyScreen()
    }
}