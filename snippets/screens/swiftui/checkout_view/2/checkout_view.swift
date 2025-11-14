import SwiftUI

struct CheckoutView: View {
    @State private var currentStep = 0
    @State private var email = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var address = ""
    @State private var city = ""
    @State private var state = "CA"
    @State private var zipCode = ""
    @State private var phone = ""

    let steps = ["Shipping", "Payment", "Review"]

    var body: some View {
        NavigationView {
            VStack {
                // Progress Indicator
                HStack {
                    ForEach(0..<steps.count, id: \.self) { index in
                        StepIndicator(
                            step: index,
                            title: steps[index],
                            isActive: currentStep >= index,
                            isCurrent: currentStep == index
                        )
                        if index < steps.count - 1 {
                            Rectangle()
                                .fill(currentStep > index ? Color.blue : Color.gray.opacity(0.3))
                                .frame(height: 2)
                        }
                    }
                }
                .padding()

                ScrollView {
                    switch currentStep {
                    case 0:
                        ShippingForm(
                            email: $email,
                            firstName: $firstName,
                            lastName: $lastName,
                            address: $address,
                            city: $city,
                            state: $state,
                            zipCode: $zipCode,
                            phone: $phone
                        )
                    case 1:
                        PaymentForm()
                    case 2:
                        OrderReview()
                    default:
                        EmptyView()
                    }
                }

                // Order Summary
                OrderSummaryView()

                // Continue Button
                HStack {
                    if currentStep > 0 {
                        Button("Back") {
                            currentStep -= 1
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }

                    Button(currentStep == 2 ? "Place Order" : "Continue") {
                        if currentStep < 2 {
                            currentStep += 1
                        } else {
                            // Place order
                        }
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding()
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StepIndicator: View {
    let step: Int
    let title: String
    let isActive: Bool
    let isCurrent: Bool

    var body: some View {
        VStack {
            Circle()
                .fill(isActive ? Color.blue : Color.gray.opacity(0.3))
                .frame(width: 30, height: 30)
                .overlay(
                    Text("\(step + 1)")
                        .foregroundColor(isActive ? .white : .gray)
                        .fontWeight(.bold)
                )
                .overlay(
                    Circle()
                        .stroke(isCurrent ? Color.blue : Color.clear, lineWidth: 2)
                        .frame(width: 36, height: 36)
                )

            Text(title)
                .font(.caption)
                .foregroundColor(isActive ? .blue : .gray)
                .fontWeight(isCurrent ? .bold : .regular)
        }
    }
}

struct ShippingForm: View {
    @Binding var email: String
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var address: String
    @Binding var city: String
    @Binding var state: String
    @Binding var zipCode: String
    @Binding var phone: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Contact Information")
                .font(.headline)
                .padding(.horizontal)

            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Phone Number", text: $phone)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)

            Text("Shipping Address")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)

            VStack {
                HStack {
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                TextField("Address", text: $address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                HStack {
                    TextField("City", text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Picker("State", selection: $state) {
                        ForEach(["CA", "NY", "TX", "FL", "WA"], id: \.self) { state in
                            Text(state).tag(state)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 80)

                    TextField("ZIP", text: $zipCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct PaymentForm: View {
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var cardHolderName = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Payment Information")
                .font(.headline)
                .padding(.horizontal)

            VStack {
                TextField("Card Number", text: $cardNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)

                TextField("Cardholder Name", text: $cardHolderName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                HStack {
                    TextField("MM/YY", text: $expiryDate)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("CVV", text: $cvv)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct OrderReview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order Review")
                .font(.headline)
                .padding(.horizontal)

            VStack {
                // Order items would go here
                Text("Review your order details...")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
}

struct OrderSummaryView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Subtotal")
                Spacer()
                Text("$149.97")
            }
            HStack {
                Text("Shipping")
                Spacer()
                Text("$9.99")
            }
            HStack {
                Text("Tax")
                Spacer()
                Text("$12.00")
            }
            Divider()
            HStack {
                Text("Total")
                    .fontWeight(.bold)
                Spacer()
                Text("$171.96")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
    }
}