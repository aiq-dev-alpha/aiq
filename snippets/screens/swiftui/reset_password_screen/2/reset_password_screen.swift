import SwiftUI

struct ResetPasswordScreen: View {
    var backgroundColor: Color = .white
    var textColor: Color = .black
    var cornerRadius: CGFloat = 12
    var padding: CGFloat = 18
    
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
        .shadow(color: Color.black.opacity(0.7), radius: 7, x: 0, y: 4)
        .scaleEffect(scale)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                isVisible = true
                scale = 1.0
            }
        }
    }
}

struct ResetPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordScreen()
    }
}
