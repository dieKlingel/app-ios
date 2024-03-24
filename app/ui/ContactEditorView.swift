import SwiftUI
import linphonesw

struct ContactEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: CoreStore
    let contact: Friend?
    
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var server: String = ""
    
    init(_ contact: Friend? = nil) {
        self.contact = contact
    }
    
    private func onSave() {
        let list = try! store.core.defaultFriendList ?? store.core.createFriendList()
        let contact = try! contact ?? store.core.createFriend()
        let address = try! Factory.Instance.createAddress(addr: "sip:\(username)@\(server)")

        contact.edit()
        try! contact.setName(newValue: name)
        try! contact.setAddress(newValue: address)
        contact.done()
        
        let state = list.addFriend(linphoneFriend: contact)
        print(state)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Name")
                        TextField("Main Entry", text: $name)
                            .multilineTextAlignment(.trailing)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                }
                
                Section {
                    HStack {
                        Text("Username")
                        TextField("main.home", text: $username)
                            .multilineTextAlignment(.trailing)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                    
                    HStack {
                        Text("Server")
                        TextField("sip.dieklingel.com", text: $server)
                            .multilineTextAlignment(.trailing)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                }
            }
            .navigationTitle("Door")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        onSave()
                        dismiss()
                    }
                    .disabled(name.isEmpty || username.isEmpty || server.isEmpty)
                }
            }
        }
    }
}
