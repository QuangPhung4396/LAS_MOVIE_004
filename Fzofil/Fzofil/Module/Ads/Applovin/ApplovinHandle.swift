import UIKit
import AppLovinSDK
import AdSupport

extension NSNotification.Name {
    static let applovin_ready = NSNotification.Name(rawValue: "applovin_ready")
}

public class ApplovinHandle: NSObject {
    
    // MARK: - properties
    private var _isReady = false
    
    var isReady: Bool {
        return _isReady
    }
    
    // MARK: - initial
    @objc public static let shared = ApplovinHandle()
    
    // MARK: private
    
    // MARK: public
    @objc public func awake(completion: @escaping () -> Void) {
        if ALSdk.shared() == nil {
            return
        }
        ALSdk.shared()!.mediationProvider = "max"
        ALSdk.shared()!.initializeSdk { (configuration: ALSdkConfiguration) in
            self._isReady = true
            completion()
            NotificationCenter.default.post(name: .applovin_ready, object: nil)
        }
    }
}
