import SwiftUI

struct EventsListScreen: View {
    var backgroundColor: Color = .white
    var textColor: Color = .black
    var cornerRadius: CGFloat = 13
    var padding: CGFloat = 19
    
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
        .shadow(color: Color.black.opacity(0.8), radius: 8, x: 0, y: 5)
        .scaleEffect(scale)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.45)) {
                isVisible = true
                scale = 1.0
            }
        }
    }
}

struct EventsListScreen_Previews: PreviewProvider {
    static var previews: some View {
        EventsListScreen()
    }
}
