import Foundation
import linphonesw

extension Core {
    func setAccount(account: Account?) {
        self.clearAllAuthInfo()
        self.clearAccounts()
        
        guard let account = account else {
          return
        }
        
        let auth = try! Factory.Instance.createAuthInfo(
            username: account.username,
            userid: nil,
            passwd: account.password,
            ha1: nil,
            realm: nil,
            domain: account.server
        )
        self.addAuthInfo(info: auth)
        
        let address = try! Factory.Instance.createAddress(addr: "sip:\(account.username)@\(account.server)")
        try! address.setTransport(newValue: account.transport)
        
        let params = try!self.createAccountParams()
        try! params.setServeraddress(newValue: address)
        try! params.setIdentityaddress(newValue: address)
        params.pushNotificationAllowed = true
        params.remotePushNotificationAllowed = true
    
        let acc = try! self.createAccount(params: params)
        try! self.addAccount(account: acc)
        self.defaultAccount = acc
    }
    
    func getAccount() -> Account? {
        guard let acc = self.defaultAccount else {
            return nil
        }
        
        return Account(account: acc)
    }
}
