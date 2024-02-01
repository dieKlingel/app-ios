import SwiftUI
import SwiftData

struct HomeView: View {
    @ObservedObject var app: AppState
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("hello world")
            }
            .navigationTitle(Text("dieKlingel"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    switch(app.registrationState) {
                    case .None, .Cleared:
                        EmptyView()
                    case .Progress, .Refreshing:
                        Text("Connecting")
                    case .Ok:
                        Text("Connected")
                    case .Failed:
                        Text("Failed")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AccountView(app: app), label: {
                        Image(systemName: "person.crop.circle")
                    })
                }
            }
        }
    }
}

#Preview {
    HomeView(
        app: AppState()
    )
}
