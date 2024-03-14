import SwiftUI
import SwiftData
import linphonesw

class Test {
    public var i = "a"
}

struct AccountView: View {
    @Environment(\.dismiss) private var dismiss
    
    public let core: Core;
    
    @State private var username = ""
    @State private var password = ""
    @State private var server = ""
    @State private var transport = TransportType.Tls
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Username")
                    TextField("Max", text: $username)
                        .multilineTextAlignment(.trailing)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                
                HStack {
                    Text("Password")
                    SecureField("", text: $password)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("Server")
                    TextField("sip.dieklingel.com", text: $server)
                        .multilineTextAlignment(.trailing)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.URL)
                }
            }
            
            Section {
                Picker("Transport", selection: $transport) {
                    Text("TLS (recomended)").tag(TransportType.Tls)
                    Text("TCP").tag(TransportType.Tcp)
                    Text("UDP").tag(TransportType.Udp)
                    Text("DTLS").tag(TransportType.Dtls)
                }
            }
        }
        .navigationTitle("SIP Account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button("Done") {
                    core.clearAccounts()
                    core.clearAllAuthInfo()
                    
                    let address = try! Factory.Instance.createAddress(addr: "sip:\(username)@\(server)")
                    let authInfo = try! Factory.Instance.createAuthInfo(username: username, userid: nil, passwd: password, ha1: nil, realm: nil, domain: server)
                    core.addAuthInfo(info: authInfo)
                    
                    let params = try! core.createAccountParams()
                    params.pushNotificationAllowed = true
                    params.registerEnabled = true
                    params.transport = transport
                    try! params.setServeraddress(newValue: address)
                    try! params.setIdentityaddress(newValue: address)
                    
                    let account = try! core.createAccount(params: params)
                    try! core.addAccount(account: account)
                    core.defaultAccount = account
                    
                    dismiss()
                }
                .disabled(username.isEmpty || password.isEmpty || server.isEmpty)
            }
        }
        .onAppear {
            if let account = core.defaultAccount {
                username = account.params?.identityAddress?.username ?? ""
                password = account.findAuthInfo()?.password ?? ""
                server = account.params?.identityAddress?.domain ?? ""
            }
        }
    }
}

//#Preview {
//AccountView(data: "a")
//}
