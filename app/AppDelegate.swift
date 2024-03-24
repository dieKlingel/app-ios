import Foundation
import CallKit
import os
import linphonesw

class AppDelegate: NSObject, UIApplicationDelegate, CXProviderDelegate {
    private static let logger = Logger(
          subsystem: Bundle.main.bundleIdentifier!,
          category: String(describing: AppDelegate.self)
    )
    
    let core: Core
    let provider: CXProvider
    
    override init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .applicationSupportDirectory,
            .userDomainMask,
            true
        ).first

        self.core = try! Factory.Instance.createCore(
            configPath: path?.appending("/linphonerc"),
            factoryConfigPath: nil,
            systemContext: nil
        )
        
        let config = CXProviderConfiguration()
        config.supportsVideo = true
        config.supportedHandleTypes = [.generic]

        self.provider = CXProvider(configuration: config)
        super.init()
        
        provider.setDelegate(self, queue: .main)
    }
    
    func application(
        _
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        core.pushNotificationEnabled = true
        core.callkitEnabled = true
        
        try! core.start()
        
        return true
    }
    
    func providerDidReset(_ provider: CXProvider) {
        // TODO: implemnt didReset
        AppDelegate.logger.debug("The CXProvider did reset.")
    }
}
