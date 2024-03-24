//
//  AccountViewModel.swift
//  app
//
//  Created by Kai Mayer on 24.03.24.
//

import Foundation
import linphonesw

@Observable
class AccountViewModel: NSObject {
    private let _core: Core
    public var account: Account? {
        set {
            _core.setAccount(account: newValue)
        }
        get {
            return _core.getAccount()
        }
    }
    
    init(_ core: Core) {
        self._core = core
    }
}
