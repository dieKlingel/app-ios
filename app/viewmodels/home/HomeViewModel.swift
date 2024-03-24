import os
import linphonesw

@Observable
class HomeViewModel: NSObject {
    private static let logger = Logger(
          subsystem: Bundle.main.bundleIdentifier!,
          category: String(describing: HomeViewModel.self)
    )
    
    private let _core: Core
    private(set) var registrationState = RegistrationState.None
    
    var doorbells: [Friend] = []
    
    init(_ core: Core) {
        self._core = core
        super.init()
        
        self._core.addDelegate(delegate: CoreDelegateStub(
            onGlobalStateChanged: onGlobalStateChanged,
            onRegistrationStateChanged: onRegistrationStateChanged
        ))
    }
  
    /// force registration refresh to be initiated upon next iterate
    public func refreshRegisters() {
        _core.refreshRegisters()
    }
    
    private func onGlobalStateChanged(
        core: Core,
        state: GlobalState,
        message: String
    ) {
        HomeViewModel.logger.info("Global state changed: \(message).")
    }
    
    private func onRegistrationStateChanged(
        core: Core,
        config: ProxyConfig, 
        state: RegistrationState,
        message: String
    ) {
        HomeViewModel.logger.info("Registraion state chnaged: \(message).")
        registrationState = state
    }
}
