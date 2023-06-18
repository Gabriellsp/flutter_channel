import UIKit
import Flutter
import SystemConfiguration

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
          let channel = FlutterMethodChannel(name: "flutter.seventh/network_connection",
                                                    binaryMessenger: controller.binaryMessenger)
          channel.setMethodCallHandler({
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
              guard call.method == "hasInternet" else {
                  result(FlutterMethodNotImplemented)
                  return
                }
              self.isInternetAvailable(result: result)
          })

      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    func isInternetAvailable(result: FlutterResult) {
        var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
            }) else {
                result(false)
                return
            }
            var flags: SCNetworkReachabilityFlags = []
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
                result(false)
                return
            }
            
            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)
            result(isReachable && !needsConnection)
    }
}
