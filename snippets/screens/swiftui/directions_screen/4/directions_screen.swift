import SwiftUI
struct Screen: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Content")
                }
                .padding()
            }
            .navigationTitle("Screen")
        }
    }
}
