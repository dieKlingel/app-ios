import SwiftUI
import SwiftData
import linphonesw

struct AccountView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @ObservedObject var app: AppState
    
    @State private var username = ""
    @State private var password = ""
    @State private var domain = ""
    @State private var transport = TransportType.Tls
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account")) {
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $password)
                    TextField("Server: sip.dieklingel.com", text: $domain)
                        .autocapitalization(.none)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                }
                Section(header: Text("Network")) {
                    Picker("Transport", selection: $transport) {
                        Text("TLS (recommended)").tag(TransportType.Tls)
                        Text("TCP").tag(TransportType.Tcp)
                        Text("UDP").tag(TransportType.Udp)
                    }
                    
                }
                Section {
                    Button("Remove Account", role: .destructive) {
                        if let account = app.unregister() {
                            context.delete(account)
                            try! context.save()
                        }
                        dismiss()
                    }
                    .disabled(app.account == nil)
                }
            }
            .navigationTitle("SIP Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button("Done") {
                        if let account = app.unregister() {
                            account.username = username
                            account.password = password
                            account.domain = domain
                            account.transport = transport
                            
                            try! context.save()
                            app.register(account: account)
                        } else {
                            let account = Account(username: username, password: password, domain: domain, transport: transport)
                            
                            context.insert(account)
                            app.register(account: account)
                        }             
                        dismiss()
                    }
                    .disabled(username.isEmpty || password.isEmpty || domain.isEmpty)
                }
            }
        }
        .onAppear {
            username = app.account?.username ?? username
            password = app.account?.password ?? password
            domain = app.account?.domain ?? domain
            transport = app.account?.transport ?? transport
        }
    }
}

#Preview {
    AccountView(app: AppState())
}
