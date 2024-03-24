import Foundation
import linphonesw

struct Account {
    let username: String
    let server: String
    let password: String
    let transport: TransportType
    
    init(username: String, server: String, password: String, transport: TransportType) {
        self.username = username
        self.server = server
        self.password = password
        self.transport = transport
    }
    
    init(account: linphonesw.Account) {
        username = account.findAuthInfo()?.username ?? ""
        server = account.params?.serverAddress?.domain ?? ""
        password = account.findAuthInfo()?.password ?? ""
        transport = account.params?.serverAddress?.transport ?? TransportType.Tls
    }
}
