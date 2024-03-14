import Foundation
import linphonesw

class CoreStore : ObservableObject {
    @Published var registrationState: RegistrationState = RegistrationState.None
    
    let core: Core
    
    init(core: Core) {
        self.core = core
        
        core.addDelegate(delegate: CoreDelegateStub(
            onRegistrationStateChanged: onRegistrationStateChaged
        ))
    }
    
    private func onRegistrationStateChaged(core: Core, proxyConfig: ProxyConfig, state: RegistrationState, message: String) {
        self.registrationState = state
        print("Registration state changed: \(message)")
    }
}
