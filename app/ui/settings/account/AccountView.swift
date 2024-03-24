import SwiftUI
import linphonesw

struct AccountView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AccountViewModel.self) var vm
    
    @State private var username = ""
    @State private var password = ""
    @State private var server = ""
    @State private var transport = TransportType.Tls
    
    var body: some View {
        NavigationStack {
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
                        self.vm.account = Account(
                            username: username,
                            server: server,
                            password: password,
                            transport: transport
                        )
                        
                        dismiss()
                    }
                    .disabled(username.isEmpty || password.isEmpty || server.isEmpty)
                }
            }
            .onAppear {
                username = vm.account?.username ?? ""
                password = vm.account?.password ?? ""
                server = vm.account?.server ?? ""
                transport = vm.account?.transport ?? TransportType.Tls
            }
        }
    }
}
