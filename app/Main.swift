import SwiftUI
import linphonesw

@main
struct Main: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(
                    HomeViewModel(delegate.core)
                )
                .environment(
                    AccountViewModel(delegate.core)
                )
        }
    }
}
