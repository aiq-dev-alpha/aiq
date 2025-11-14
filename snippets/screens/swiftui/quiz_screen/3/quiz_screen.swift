import SwiftUI

struct QuizScreen: View {
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var selectedAnswers: [Int: Int] = [:]
    @State private var isQuizActive = false
    @State private var isQuizCompleted = false
    @State private var timeRemaining = 30
    @State private var timer: Timer?

    private let questions = QuizQuestion.sampleQuestions

    var body: some View {
        NavigationView {
            if !isQuizActive && !isQuizCompleted {
                startScreen
            } else if isQuizCompleted {
                resultsScreen
            } else {
                questionScreen
            }
        }
    }

    private var startScreen: some View {
        VStack(spacing: 30) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 80))
                .foregroundColor(.blue)

            VStack(spacing: 16) {
                Text("General Knowledge Quiz")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "questionmark.circle")
                        Text("\(questions.count) Questions")
                    }
                    HStack {
                        Image(systemName: "clock")
                        Text("30 seconds per question")
                    }
                    HStack {
                        Image(systemName: "star")
                        Text("Total Points: \(questions.reduce(0) { $0 + $1.points })")
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }

            Button("Start Quiz") {
                startQuiz()
            }
            .buttonStyle(PrimaryButtonStyle())

            Text("Test your knowledge across multiple categories!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .navigationTitle("Quiz")
    }

    private var questionScreen: some View {
        VStack {
            // Header
            VStack(spacing: 16) {
                HStack {
                    Text("Question \(currentQuestionIndex + 1)/\(questions.count)")
                        .font(.headline)
                    Spacer()
                    Text(questions[currentQuestionIndex].category)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(12)
                        .foregroundColor(.blue)
                }

                ProgressView(value: Double(currentQuestionIndex + 1), total: Double(questions.count))
                    .progressViewStyle(LinearProgressViewStyle())

                HStack {
                    Image(systemName: "timer")
                    Text("\(timeRemaining)s")
                        .fontWeight(.bold)
                        .foregroundColor(timeRemaining <= 10 ? .red : .primary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(timeRemaining <= 10 ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
                .cornerRadius(20)
            }
            .padding()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Text("\(questions[currentQuestionIndex].points)")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                )
                            Text("Points")
                                .fontWeight(.bold)
                        }

                        Text(questions[currentQuestionIndex].question)
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)

                    ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                        let option = questions[currentQuestionIndex].options[index]
                        let isSelected = selectedAnswers[currentQuestionIndex] == index

                        Button(action: {
                            selectAnswer(index)
                        }) {
                            HStack {
                                Circle()
                                    .fill(isSelected ? Color.blue : Color.gray.opacity(0.3))
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Text("\(Character(UnicodeScalar(65 + index)!))")
                                            .foregroundColor(isSelected ? .white : .gray)
                                            .fontWeight(.bold)
                                    )

                                Text(option)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)

                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(selectedAnswers[currentQuestionIndex] != nil)
                    }
                }
                .padding()
            }

            HStack {
                Text("Score: \(score)")
                    .font(.headline)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(20)
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Quiz")
        .navigationBarItems(trailing: Button("Quit") {
            endQuiz()
        })
    }

    private var resultsScreen: some View {
        VStack(spacing: 30) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 80))
                .foregroundColor(.yellow)

            VStack(spacing: 16) {
                Text("Quiz Complete!")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                let totalPoints = questions.reduce(0) { $0 + $1.points }
                let percentage = Int(Double(score) / Double(totalPoints) * 100)

                VStack(spacing: 12) {
                    Text("\(percentage)%")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(percentage >= 80 ? .green : percentage >= 60 ? .orange : .red)

                    HStack(spacing: 30) {
                        VStack {
                            Text("\(score)")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Score")
                                .font(.caption)
                        }
                        VStack {
                            Text("\(totalPoints)")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Total")
                                .font(.caption)
                        }
                        VStack {
                            Text("\(questions.count)")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Questions")
                                .font(.caption)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }

            HStack {
                Button("Try Again") {
                    restartQuiz()
                }
                .buttonStyle(SecondaryButtonStyle())

                Button("Finish") {
                    // Handle finish
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .padding()
        .navigationTitle("Results")
    }

    private func startQuiz() {
        isQuizActive = true
        currentQuestionIndex = 0
        score = 0
        selectedAnswers.removeAll()
        startTimer()
    }

    private func startTimer() {
        timeRemaining = 30
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                nextQuestion()
            }
        }
    }

    private func selectAnswer(_ index: Int) {
        selectedAnswers[currentQuestionIndex] = index
        timer?.invalidate()

        if index == questions[currentQuestionIndex].correctAnswer {
            score += questions[currentQuestionIndex].points
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            nextQuestion()
        }
    }

    private func nextQuestion() {
        timer?.invalidate()

        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            startTimer()
        } else {
            endQuiz()
        }
    }

    private func endQuiz() {
        timer?.invalidate()
        isQuizActive = false
        isQuizCompleted = true
    }

    private func restartQuiz() {
        isQuizCompleted = false
        currentQuestionIndex = 0
        score = 0
        selectedAnswers.removeAll()
    }
}

struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: Int
    let points: Int
    let category: String

    static let sampleQuestions = [
        QuizQuestion(question: "What is the capital of France?", options: ["London", "Berlin", "Paris", "Madrid"], correctAnswer: 2, points: 10, category: "Geography"),
        QuizQuestion(question: "Which planet is known as the Red Planet?", options: ["Venus", "Mars", "Jupiter", "Saturn"], correctAnswer: 1, points: 10, category: "Science"),
        QuizQuestion(question: "Who wrote 'Romeo and Juliet'?", options: ["Charles Dickens", "William Shakespeare", "Mark Twain", "Jane Austen"], correctAnswer: 1, points: 15, category: "Literature"),
        QuizQuestion(question: "What is 15 + 27?", options: ["40", "41", "42", "43"], correctAnswer: 2, points: 5, category: "Mathematics")
    ]
}

struct QuizScreen_Previews: PreviewProvider {
    static var previews: some View {
        QuizScreen()
    }
}