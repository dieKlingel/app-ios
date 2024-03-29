import SwiftUI
import SwiftData
import linphonesw

struct HomeView: View {
    @State var tab = Tabs.doorbell
    @Environment(HomeViewModel.self) private var vm
    
    var body: some View {
        NavigationStack {
            switch(vm.call?.state) {
            case .OutgoingInit, .OutgoingRinging, .OutgoingProgress:
                OutgoingCallView(call: vm.call!)
            case .Connected, .StreamsRunning:
                ActiveCallView(call: vm.call!)
            default:
                TabView(selection: $tab) {
                    DoorbellTab()
                        .tabItem {
                            VStack {
                                Image(systemName: "bell.fill")
                                Text("dieKlingel")
                            }
                        }
                        .tag(Tabs.doorbell)
                    
                    KeypadTab()
                        .tabItem {
                            VStack {
                                Image(systemName: "circle.grid.3x3.fill")
                                Text("Keypad")
                            }
                        }
                        .tag(Tabs.keypad)
                }
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

enum Tabs: Int {
    case doorbell
    case keypad
}
