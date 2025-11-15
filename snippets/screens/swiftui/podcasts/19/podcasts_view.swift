import SwiftUI

struct ScreenView: View {
    var primaryColor: Color = .blue
    var secondaryColor: Color = .purple
    var backgroundColor: Color = .gray.opacity(0.05)
    var surfaceColor: Color = .white
    var textColor: Color = .black
    
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Screen Title")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                    .padding(.top)
                
                Text("Description goes here")
                    .font(.body)
                    .foregroundColor(textColor.opacity(0.7))
                
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(0..<5) { index in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Item \(index + 1)")
                                .font(.headline)
                                .foregroundColor(textColor)
                            
                            Text("Details about this item")
                                .font(.subheadline)
                                .foregroundColor(textColor.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(surfaceColor)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    isLoading.toggle()
                }) {
                    Text("Action Button")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(primaryColor)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
    }
}

struct ScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenView()
    }
}
