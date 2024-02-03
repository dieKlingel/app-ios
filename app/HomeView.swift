import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) var context
    @ObservedObject var app: AppState
    
    @Query var friends: [Friend]
    @State var isInFriendEditor = false
        
    init(app: AppState) {
        self.app = app
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("hello")
                ForEach(friends) {friend in
                    Text(friend.address)
                }
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
                    Button{
                        isInFriendEditor = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AccountView(app: app), label: {
                        Image(systemName: "person.crop.circle")
                    })
                }
            }
            .sheet(isPresented: $isInFriendEditor) {
                FriendEditorView(app: app)
            }
        }
    }
}

#Preview {
    HomeView(
        app: AppState()
    )
}
