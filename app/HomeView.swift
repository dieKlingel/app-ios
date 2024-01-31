import SwiftUI
import SwiftData

struct HomeView: View {
    var body: some View {
        NavigationStack {
            Section {
                Text("Hello World")
            }
            .navigationTitle(Text("dieKlingel"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AccountView(), label: {
                        Image(systemName: "person.crop.circle")
                    })
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
