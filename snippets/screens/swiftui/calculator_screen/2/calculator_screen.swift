import SwiftUI

struct CalculatorScreen: View {
    @State private var display = "0"
    @State private var previousValue = ""
    @State private var operation = ""
    @State private var userIsTyping = false

    var body: some View {
        VStack(spacing: 0) {
            // Display
            VStack {
                HStack {
                    if !operation.isEmpty {
                        Text("\(previousValue) \(operation)")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal)

                HStack {
                    Spacer()
                    Text(display)
                        .font(.system(size: 64, weight: .light))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .padding(.horizontal)
            }
            .frame(height: 200)
            .background(Color.black)
            .foregroundColor(.white)

            // Buttons
            VStack(spacing: 1) {
                HStack(spacing: 1) {
                    CalculatorButton(text: "C", backgroundColor: .orange, action: { clear() })
                    CalculatorButton(text: "±", backgroundColor: .gray, action: { toggleSign() })
                    CalculatorButton(text: "%", backgroundColor: .gray, action: { performOperation("%") })
                    CalculatorButton(text: "÷", backgroundColor: .blue, action: { performOperation("÷") })
                }

                HStack(spacing: 1) {
                    CalculatorButton(text: "7", action: { numberPressed("7") })
                    CalculatorButton(text: "8", action: { numberPressed("8") })
                    CalculatorButton(text: "9", action: { numberPressed("9") })
                    CalculatorButton(text: "×", backgroundColor: .blue, action: { performOperation("×") })
                }

                HStack(spacing: 1) {
                    CalculatorButton(text: "4", action: { numberPressed("4") })
                    CalculatorButton(text: "5", action: { numberPressed("5") })
                    CalculatorButton(text: "6", action: { numberPressed("6") })
                    CalculatorButton(text: "-", backgroundColor: .blue, action: { performOperation("-") })
                }

                HStack(spacing: 1) {
                    CalculatorButton(text: "1", action: { numberPressed("1") })
                    CalculatorButton(text: "2", action: { numberPressed("2") })
                    CalculatorButton(text: "3", action: { numberPressed("3") })
                    CalculatorButton(text: "+", backgroundColor: .blue, action: { performOperation("+") })
                }

                HStack(spacing: 1) {
                    CalculatorButton(text: "0", width: 2, action: { numberPressed("0") })
                    CalculatorButton(text: ".", action: { decimalPressed() })
                    CalculatorButton(text: "=", backgroundColor: .blue, action: { calculateResult() })
                }
            }
            .background(Color.gray.opacity(0.1))
        }
        .navigationTitle("Calculator")
    }

    private func numberPressed(_ number: String) {
        if userIsTyping {
            if display.count < 9 {
                display = display == "0" ? number : display + number
            }
        } else {
            display = number
            userIsTyping = true
        }
    }

    private func decimalPressed() {
        if !display.contains(".") && userIsTyping {
            display += "."
        } else if !userIsTyping {
            display = "0."
            userIsTyping = true
        }
    }

    private func performOperation(_ op: String) {
        if !previousValue.isEmpty && !operation.isEmpty && userIsTyping {
            calculateResult()
        }
        previousValue = display
        operation = op
        userIsTyping = false
    }

    private func calculateResult() {
        guard let prev = Double(previousValue),
              let current = Double(display),
              !operation.isEmpty else { return }

        var result: Double = 0

        switch operation {
        case "+":
            result = prev + current
        case "-":
            result = prev - current
        case "×":
            result = prev * current
        case "÷":
            result = current != 0 ? prev / current : 0
        case "%":
            result = prev.truncatingRemainder(dividingBy: current)
        default:
            return
        }

        display = formatResult(result)
        previousValue = ""
        operation = ""
        userIsTyping = false
    }

    private func clear() {
        display = "0"
        previousValue = ""
        operation = ""
        userIsTyping = false
    }

    private func toggleSign() {
        if display != "0" {
            if display.hasPrefix("-") {
                display = String(display.dropFirst())
            } else {
                display = "-" + display
            }
        }
    }

    private func formatResult(_ result: Double) -> String {
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(result))
        } else {
            return String(result)
        }
    }
}

struct CalculatorButton: View {
    let text: String
    let backgroundColor: Color
    let width: Int
    let action: () -> Void

    init(text: String, backgroundColor: Color = .gray, width: Int = 1, action: @escaping () -> Void) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.width = width
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(width: CGFloat(width * 90 + (width - 1)), height: 80)
                .background(backgroundColor)
        }
    }
}

struct CalculatorScreen_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorScreen()
    }
}