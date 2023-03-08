import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    private var methodChannels: [MethodChannel] = []
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
    FirebaseApp.configure()
    startListeningFlutterCalls()
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func startListeningFlutterCalls() {
        guard let controller: FlutterViewController = window?.rootViewController as? FlutterViewController else { return }
            
        MethodChannels.allCases.forEach { item in
            let methodChannel = MethodChannelFactory.get(type: item, controller: controller)
            methodChannel.startListening()
            methodChannels.append(methodChannel)
        }
    }
}
