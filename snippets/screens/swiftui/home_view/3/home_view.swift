import SwiftUI

struct ScreenView: View {
    var primaryColor: Color = .blue
    var backgroundColor: Color = .gray.opacity(0.1)
    var textColor: Color = .black
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Screen")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Content")
                        .foregroundColor(textColor)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                Spacer()
            }
            .padding()
        }
    }
}
