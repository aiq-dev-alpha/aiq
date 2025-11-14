import SwiftUI

struct OrderConfirmationView: View {
    let orderNumber = "ORD-2024-001234"
    let estimatedDelivery = "March 15, 2024"

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 40)

                // Success Icon
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .overlay(
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                    )

                VStack(spacing: 12) {
                    Text("Order Confirmed!")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Thank you for your purchase")
                        .foregroundColor(.gray)
                }

                // Order Details Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Order Details")
                        .font(.headline)
                        .fontWeight(.bold)

                    VStack {
                        DetailRow(label: "Order Number", value: orderNumber)
                        DetailRow(label: "Order Date", value: "March 10, 2024")
                        DetailRow(label: "Total Amount", value: "$171.96")
                        DetailRow(label: "Payment Method", value: "Visa •••• 3456")
                        DetailRow(label: "Estimated Delivery", value: estimatedDelivery)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 2)

                // Action Buttons
                VStack(spacing: 12) {
                    Button {
                        // Track order
                    } label: {
                        Text("TRACK ORDER")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }

                    HStack {
                        Button("Continue Shopping") {
                            // Continue shopping
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)

                        Button("Share") {
                            // Share order
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

struct OrderConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        OrderConfirmationView()
    }
}