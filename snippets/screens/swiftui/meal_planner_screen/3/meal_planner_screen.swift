import SwiftUI
struct Screen: View {
    @State private var data = ""
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Data")) {
                    Text("Content")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Screen")
        }
    }
}
