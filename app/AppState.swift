//
//  AppState.swift
//  app
//
//  Created by Kai Mayer on 31.01.24.
//

import Foundation
import linphonesw

class AppState : ObservableObject {
    @Published var globalState: GlobalState
    @Published var registrationState: RegistrationState
    @Published var account: Account?
    
    let core = try! Factory.Instance.createCore(configPath: nil, factoryConfigPath: nil, systemContext: nil)
    
    init() {
        globalState = core.globalState
        registrationState = RegistrationState.None
        
        core.addDelegate(delegate: CoreDelegateStub(
            onGlobalStateChanged: { core, state, message in
                self.globalState = state
            },
            onRegistrationStateChanged: { core, proxyConfig, state, message in
                self.registrationState = state
                print(message)
            }
        ))
    }
    
    func register(account: Account) {
        let info = try! core.authInfoList.first ?? Factory.Instance.createAuthInfo(username: account.username, userid: nil, passwd: nil, ha1: nil, realm: nil, domain: nil)
        info.username = account.username
        info.password = account.password
        info.domain = account.domain
        core.addAuthInfo(info: info)

        let params = try! core.createAccountParams()
        let address = try! Factory.Instance.createAddress(addr: account.toSipAddressString())
        try! params.setIdentityaddress(newValue: address)
        try! params.setServeraddress(newValue: address)
        params.registerEnabled = true
        params.transport = account.transport
        
        let config = try! core.defaultAccount ?? core.createAccount(params: params)
        config.params = params
        
        try! core.addAccount(account: config)
        core.defaultAccount = config
        
        self.account = account
    }
    
    func unregister() -> Account? {
        core.clearAccounts()
        core.clearAllAuthInfo()
        
        let account = self.account
        self.account = nil
        return account
    }
}
