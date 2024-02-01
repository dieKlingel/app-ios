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
}
