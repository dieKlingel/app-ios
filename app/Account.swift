import SwiftData
import linphonesw

@Model
class Account {
    public var username: String
    public var password: String
    public var domain: String
    private var _transport: Int
    
    public var transport: TransportType {
        get {
            return TransportType(rawValue: _transport) ?? TransportType.Tls
        }
        set {
            _transport = newValue.rawValue
        }
    }
        
    init(username: String = "", password: String = "", domain: String = "", transport: TransportType = TransportType.Tls) {
        self.username = username
        self.password = password
        self.domain = domain
        self._transport = transport.rawValue
    }
    
    func toSipAddressString() -> String {
        return "sip:\(username)@\(domain)"
    }
}
