import SwiftUI
import linphonesw

struct AccountView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var app: AppState
    
    @State private var username = ""
    @State private var password = ""
    @State private var server = ""
    @State private var transport = TransportType.Tls
    
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
                Section(header: Text("Network")) {
                    Picker("Transport", selection: $transport) {
                        Text("TLS (recommended)").tag(TransportType.Tls)
                        Text("TCP").tag(TransportType.Tcp)
                        Text("UDP").tag(TransportType.Udp)
                    }

                }
            }
            .navigationTitle("SIP Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button("Done") {
                        let info = try! app.core.authInfoList.first ?? Factory.Instance.createAuthInfo(username: username, userid: nil, passwd: nil, ha1: nil, realm: nil, domain: nil)
                        info.username = username
                        info.password = password
                        info.domain = server
                        app.core.addAuthInfo(info: info)
        
                        let params = try! app.core.createAccountParams()
                        let address = try! Factory.Instance.createAddress(addr: "sip:\(username)@\(server)")
                        try! params.setIdentityaddress(newValue: address)
                        try! params.setServeraddress(newValue: address)
                        params.registerEnabled = true
                        params.transport = transport
                        
                        let account = try! app.core.defaultAccount ?? app.core.createAccount(params: params)
                        account.params = params
                        
                        try! app.core.addAccount(account: account)
                        app.core.defaultAccount = account
                        
                        // TODO: save account
        
                        dismiss()
                    }
                    .disabled(username.isEmpty || password.isEmpty || server.isEmpty)
                }
            }
        }
        .onAppear {
            username = app.core.authInfoList.first?.username ?? ""
            password = app.core.authInfoList.first?.password ?? ""
            server = app.core.authInfoList.first?.domain ?? ""
            transport = app.core.defaultAccount?.params?.transport ?? TransportType.Tls
        }
    }
}

#Preview {
    AccountView(app: AppState())
}
