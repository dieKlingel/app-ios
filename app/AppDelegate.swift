import AVFAudio
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
    let controller: CXCallController
    
    private var calls: [UUID:Call] = [:]
    
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
        self.controller = CXCallController(queue: .main)
        super.init()
        
        provider.setDelegate(self, queue: .main)
        core.addDelegate(delegate: CoreDelegateStub(
            onCallStateChanged: onCallStateChanged
        ))
    }
    
    func onCallStateChanged(core: Core, call: Call, state: Call.State, message: String) {
        AppDelegate.logger.info("Call state changed [id: \(call.callLog?.callId ?? "N/A")]: \(message)")
        switch(state) {
        case .IncomingReceived, .PushIncomingReceived:
            let uuid = UUID()
            calls.updateValue(call, forKey: uuid)
            
            let update = CXCallUpdate()
            provider.reportNewIncomingCall(with: uuid, update: update, completion: { error in
                guard let error = error else {
                    return
                }
                AppDelegate.logger.warning("An error oucoired during reporting an incomming call: \(error)")
            })
        case .End:
            guard let uuid = calls.first(where: { $0.value.callLog?.callId == call.callLog?.callId })?.key else {
                return
            }
            controller.requestTransaction(
                with: [CXEndCallAction(call: uuid)],
                completion: { error in
                    guard let error = error else {
                        return
                    }
                    AppDelegate.logger.warning("Failed to end a call: \(error)")
                }
            )
        case .Released:
            guard let uuid = calls.first(where: { $0.value.callLog?.callId == call.callLog?.callId })?.key else {
                return
            }
            calls.removeValue(forKey: uuid)
        default:
            break
        }
    }
    
    func application(
        _
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        core.pushNotificationEnabled = true
        core.callkitEnabled = true
        if let config = core.pushNotificationConfig {
            config.teamId = "3QLZPMLJ3W"
        } else {
            AppDelegate.logger.warning("Could not configure push notifications, because the config was nil")
        }

        try! core.start()
        
        return true
    }
    
    func application(
        _
        application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let token = deviceToken.map{String(format: "%02X", $0)}.joined()
        AppDelegate.logger.info("Did register for remote notifications with token: \(token).")
        core.didRegisterForRemotePushWithStringifiedToken(deviceTokenStr: "\(token):remote")
    }
    
    func providerDidReset(_ provider: CXProvider) {
        // TODO: implemnt didReset
        AppDelegate.logger.debug("The CXProvider did reset.")
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        guard let call = calls[action.callUUID] else {
            action.fulfill()
            AppDelegate.logger.debug("Tried to accept a incomming call, which did not exist.")
            return;
        }

        let params = try! core.createCallParams(call: call)
        params.videoEnabled = true
        params.videoDirection = .RecvOnly
        try! call.acceptWithParams(params: params)
        
        AppDelegate.logger.info("Accepted an incomming call: [id: \(call.callLog?.callId ?? "N/A")].")
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        guard let call = calls[action.callUUID] else {
            action.fulfill()
            AppDelegate.logger.debug("Tried to end a call, which did not exist. [uuid: \(action.callUUID)]")
            return;
        }

        try? call.terminate()
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        AppDelegate.logger.debug("The CXProvider did activate the audio session")
        core.activateAudioSession(actived: true)
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        AppDelegate.logger.debug("The CXProvider did deactivate the audio session")
        core.activateAudioSession(actived: false)
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        guard let call = calls[action.callUUID] else {
            action.fulfill()
            AppDelegate.logger.debug("Tried to mute a call, which did not exist. [uuid: \(action.callUUID)]")
            return;
        }
        
        call.microphoneMuted = action.isMuted
        action.fulfill()
    }
}
