import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "NizamScreenCapture") {
      ScreenCaptureChannel.register(with: registrar.messenger())
    }
  }
}

/// Ekran paylaşımı kanalı (lib/features/meetings/data/screen_capture_channel.dart). `available`:
/// yayın uzantısı pakette ve App Group bu derlemenin imzasında var mı. Varsayılan derleme
/// (ücretsiz Apple Kimliği ile imzalanabilen) App Group taşımaz → false, düğme görünmez.
enum ScreenCaptureChannel {
  static func register(with messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: "io.nizamio.mobile/screen_capture", binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "available":
        result(available())
      case "start", "stop":
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  static func available() -> Bool {
    let info = Bundle.main.infoDictionary
    guard let group = info?["RTCAppGroupIdentifier"] as? String, !group.isEmpty,
      let ext = info?["RTCScreenSharingExtension"] as? String, !ext.isEmpty,
      FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group) != nil,
      let plugins = Bundle.main.builtInPlugInsURL
    else { return false }
    return FileManager.default.fileExists(
      atPath: plugins.appendingPathComponent("ScreenShare.appex").path)
  }
}
