import SwiftUI
import linphonesw

@main
struct Main: App {
    let core: Core = try! Factory.Instance.createCore(configPath: nil, factoryConfigPath: nil, systemContext: nil)
    
    init() {
        try! core.start()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(
                    HomeViewModel(core)
                )
                .environment(
                    AccountViewModel(core)
                )
        }
    }
}
