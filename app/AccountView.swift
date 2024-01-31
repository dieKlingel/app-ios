import SwiftUI

struct AccountView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var username = "";
    @State private var password = "";
    @State private var server = "";
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account")) {
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $password)
                    TextField("Server: sip.dieklingel.com", text: $server)
                        .autocapitalization(.none)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                }
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button("Done") {
                        // TODO: save account
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AccountView()
}
