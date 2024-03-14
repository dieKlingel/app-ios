import SwiftUI
import SwiftData
import linphonesw

struct HomeView: View {
    @ObservedObject var store: CoreStore
        
    var body: some View {
        NavigationView {
            List {
                Text("Hallo")
                /*ForEach(friends, id: \.self) {friend in
                 NavigationLink(destination: FriendEditorView(app: app, friend: friend)) {
                 //FriendCardView(friend: friend)
                 }
                 .disabled(app.registrationState != RegistrationState.Ok)
                 .swipeActions {
                 Button(role: .destructive, action: {
                 context.delete(friend)
                 }) {
                 Text("Delete")
                 }
                 NavigationLink(destination: FriendEditorView(app: app, friend: friend)) {
                 Text("Edit")
                 }
                 }
                 }*/
            }
            .navigationTitle(Text("dieKlingel"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        store.core.refreshRegisters()
                    } label: {
                        switch store.registrationState {
                        case .None:
                            Text("None")
                        case .Progress:
                            Text("Progress")
                        case .Ok:
                            Text("Ok")
                        case .Cleared:
                            Text("Cleared")
                        case .Failed:
                            Text("Failed")
                        case .Refreshing:
                            Text("Refreshing")
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AccountView(core: store.core)
                    } label: {
                        Image(systemName: "person.fill")
                    }
                }
            }
        }.navigationViewStyle(.stack)
    }
}

