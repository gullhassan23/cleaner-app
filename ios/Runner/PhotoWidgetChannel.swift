import Flutter
import UIKit
import WidgetKit

/// Syncs Flutter photo widget config into the shared App Group and reloads timelines.
final class PhotoWidgetChannel {
  static let channelName = "cleaner_app/photo_widget"
  static let appGroupId = "group.com.FutureDialLabs.phonecleaner.file.junk.app"
  static let widgetCacheFolder = "photo_widget/cache"
  static let manifestFileName = "widget_manifest.json"

  static func register(with controller: FlutterViewController) {
    let channel = FlutterMethodChannel(
      name: channelName,
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "saveWidgetConfig":
        handleSaveWidgetConfig(result: result)
      case "updateWidget", "refreshWidget":
        if #available(iOS 14.0, *) {
          WidgetCenter.shared.reloadAllTimelines()
        }
        result(nil)
      case "requestPinWidget":
        // iOS has no pin API; user adds widget manually from the gallery.
        result(false)
      case "isWidgetPinned":
        result(false)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private static func handleSaveWidgetConfig(result: @escaping FlutterResult) {
    guard let defaults = UserDefaults(suiteName: appGroupId) else {
      result(FlutterError(code: "NO_APP_GROUP", message: "App Group not configured", details: nil))
      return
    }

    let standard = UserDefaults.standard
    let enabled = standard.bool(forKey: "flutter.photo_widget_enabled")
    let style = standard.string(forKey: "flutter.photo_widget_style") ?? "grid"
    let interval = standard.integer(forKey: "flutter.photo_widget_slideshow_interval")
    let manifestPath = standard.string(forKey: "flutter.photo_widget_manifest_path")

    defaults.set(enabled, forKey: "photo_widget_enabled")
    defaults.set(style, forKey: "photo_widget_style")
    defaults.set(interval == 0 ? 30 : interval, forKey: "photo_widget_slideshow_interval")

    if let manifestPath, let container = FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: appGroupId
    ) {
      copyWidgetPayload(manifestPath: manifestPath, container: container)
    }

    if #available(iOS 14.0, *) {
      WidgetCenter.shared.reloadAllTimelines()
    }
    result(nil)
  }

  private static func copyWidgetPayload(manifestPath: String, container: URL) {
    let sourceManifest = URL(fileURLWithPath: manifestPath)
    guard let data = try? Data(contentsOf: sourceManifest),
          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
          let cacheDir = json["cacheDirectory"] as? String
    else { return }

    let destRoot = container.appendingPathComponent("photo_widget", isDirectory: true)
    let destCache = destRoot.appendingPathComponent("cache", isDirectory: true)
    try? FileManager.default.createDirectory(at: destCache, withIntermediateDirectories: true)

    if let photos = json["photos"] as? [[String: Any]] {
      for item in photos {
        guard let fileName = item["fileName"] as? String else { continue }
        let src = URL(fileURLWithPath: cacheDir).appendingPathComponent(fileName)
        let dst = destCache.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: src.path) {
          try? FileManager.default.removeItem(at: dst)
          try? FileManager.default.copyItem(at: src, to: dst)
        }
      }
    }

    var manifest = json
    manifest["cacheDirectory"] = destCache.path
    if let out = try? JSONSerialization.data(withJSONObject: manifest, options: [.prettyPrinted]) {
      let destManifest = destRoot.appendingPathComponent(manifestFileName)
      try? out.write(to: destManifest)
    }
  }
}
