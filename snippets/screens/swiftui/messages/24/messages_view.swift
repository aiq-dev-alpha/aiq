import SwiftUI

struct ScreenView: View {
    var backgroundColor: Color = .white
    var textColor: Color = .black
    var accentColor: Color = .blue
    var cornerRadius: CGFloat = 20
    var padding: CGFloat = 28
    var onTap: (() -> Void)?
    
    @State private var isVisible = false
    @State private var scale: CGFloat = 0.95
    @State private var isHovered = false
    
    var body: some View {
        VStack {
            Text("Component")
                .foregroundColor(textColor)
                .fontWeight(.semibold)
        }
        .padding(padding)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(accentColor.opacity(isHovered ? 0.6 : 0.2), lineWidth: isHovered ? 2 : 1)
        )
        .shadow(
            color: Color.black.opacity(isHovered ? 0.12 : 0.6),
            radius: isHovered ? 14 : 8,
            x: 0,
            y: isHovered ? 4 : 2
        )
        .scaleEffect(scale)
        .offset(y: isHovered ? -3 : 0)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.37)) {
                isVisible = true
                scale = 1.0
            }
        }
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .onTapGesture {
            onTap?()
        }
    }
}

struct ScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenView()
    }
}
