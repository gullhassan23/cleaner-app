import Foundation
import UIKit

struct PhotoWidgetManifest: Codable {
  let version: Int
  let enabled: Bool
  let style: String
  let slideshowIntervalSec: Int
  let cacheDirectory: String
  let photos: [PhotoEntry]
  let updatedAt: Int64

  struct PhotoEntry: Codable {
    let fileName: String
    let order: Int
  }
}

enum PhotoWidgetData {
  static let appGroupId = "group.com.example.cleaner_app"
  static let manifestName = "widget_manifest.json"

  static func loadManifest() -> PhotoWidgetManifest? {
    guard let container = FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: appGroupId
    ) else { return nil }
    let url = container
      .appendingPathComponent("photo_widget", isDirectory: true)
      .appendingPathComponent(manifestName)
    guard let data = try? Data(contentsOf: url) else { return nil }
    return try? JSONDecoder().decode(PhotoWidgetManifest.self, from: data)
  }

  static func loadImage(manifest: PhotoWidgetManifest, fileName: String) -> UIImage? {
    let path = URL(fileURLWithPath: manifest.cacheDirectory)
      .appendingPathComponent(fileName)
      .path
    return UIImage(contentsOfFile: path)
  }
}
