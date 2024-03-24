import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(HomeViewModel.self) private var vm
    
    var body: some View {
        NavigationStack {
            if let call = vm.activeCall {
                ActiveCallView(call: call)
            } else {
                Group {
                    Button {
                    
                    } label: {
                        Text("test")
                    }
                }
                .navigationTitle(Text("dieKlingel"))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button {
                                
                            } label: {
                                Label("Add", systemImage: "plus.circle")
                            }
                            
                            NavigationLink {
                                AccountView()
                            } label: {
                                Label("Account", systemImage: "person.crop.circle")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            vm.refreshRegisters()
                        } label: {
                            switch(vm.registrationState) {
                            case .Cleared:
                                Text("Cleared")
                            case .Failed:
                                Text("Failed")
                            case .Ok:
                                Text("Ok")
                            case .Progress:
                                Text("Progress")
                            case .Refreshing:
                                Text("Refreshing")
                            default:
                                EmptyView()
                            }
                        }
                    }
                }
            }
        }
    }
}
