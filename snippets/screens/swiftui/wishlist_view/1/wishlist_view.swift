import SwiftUI

struct WishlistView: View {
    var backgroundColor: Color = .white
    var textColor: Color = .black
    var cornerRadius: CGFloat = 11
    var padding: CGFloat = 17
    
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
        .shadow(color: Color.black.opacity(0.6), radius: 6, x: 0, y: 3)
        .scaleEffect(scale)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.35)) {
                isVisible = true
                scale = 1.0
            }
        }
    }
}

struct WishlistView_Previews: PreviewProvider {
    static var previews: some View {
        WishlistView()
    }
}
