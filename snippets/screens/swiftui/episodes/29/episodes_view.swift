import SwiftUI

struct ScreenView: View {
    var backgroundColor: Color = .white
    var textColor: Color = .black
    var cornerRadius: CGFloat = 24
    var padding: CGFloat = 21
    
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
        .shadow(color: Color.black.opacity(0.14), radius: 14, x: 0, y: 3)
        .scaleEffect(scale)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.35000000000000026)) {
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
