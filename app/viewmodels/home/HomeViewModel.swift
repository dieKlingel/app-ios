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
    private(set) var call: Call?
    var doorbells: [Friend] = []
    
    init(_ core: Core) {
        self._core = core
        super.init()
        
        self._core.addDelegate(delegate: CoreDelegateStub(
            onGlobalStateChanged: onGlobalStateChanged,
            onRegistrationStateChanged: onRegistrationStateChanged,
            onCallStateChanged: onCallStateChanged
        ))
    }
  
    /// force registration refresh to be initiated upon next iterate
    public func refreshRegisters() {
        _core.refreshRegisters()
    }

    public func invite(uri: String) {
        let params = try! _core.createCallParams(call: nil)
        params.videoEnabled = true
        params.videoDirection = .RecvOnly
        
        self.call = _core.inviteWithParams(url: uri, params: params)
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
    
    private func onCallStateChanged(core: Core, call: Call, state: Call.State, message: String) {
        self.call = call
        if(state == .Released) {
            self.call = nil
        }
    }
}
