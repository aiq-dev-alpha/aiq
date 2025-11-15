import SwiftUI

struct ScreenView: View {
    var backgroundColor: Color = .white
    var textColor: Color = .black
    var cornerRadius: CGFloat = 18
    var padding: CGFloat = 24
    
    @State private var isVisible = false
    @State private var scale: CGFloat = 0.95
    
    var body: some View {
        VStack {
            Text("Component")
                .foregroundColor(textColor)
        }
        .padding(padding)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .shadow(color: Color.black.opacity(0.13), radius: 13, x: 0, y: 2)
        .scaleEffect(scale)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) {
                isVisible = true
                scale = 1.0
            }
        }
    }
}

struct ScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenView()
    }
}
