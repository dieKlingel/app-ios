import SwiftUI

struct DoorbellTab: View {
    @Environment(HomeViewModel.self) private var vm
    
    var body: some View {
        NavigationStack {
            Button {
                vm.invite(uri: "sip:koifresh@sip.linphone.org")
            } label: {
                Text("test")
            }
        }
    }
}
