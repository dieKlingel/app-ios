import SwiftUI
import linphonesw

@main
struct Main: App {
    private let core: Core
    private let store: CoreStore
        
    init() {
        let core = try! Factory.Instance.createCore(configPath: nil, factoryConfigPath: nil, systemContext: nil)
        let store = CoreStore(core: core)
        self.core = core
        self.store = store
        
        try! core.start()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(store: store)
        }
    }
}
