import WidgetKit
import SwiftUI

struct PhotoWidgetEntry: TimelineEntry {
  let date: Date
  let manifest: PhotoWidgetManifest?
  let slideshowIndex: Int
}

struct PhotoWidgetProvider: TimelineProvider {
  func placeholder(in context: Context) -> PhotoWidgetEntry {
    PhotoWidgetEntry(date: Date(), manifest: nil, slideshowIndex: 0)
  }

  func getSnapshot(in context: Context, completion: @escaping (PhotoWidgetEntry) -> Void) {
    completion(currentEntry())
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<PhotoWidgetEntry>) -> Void) {
    let entry = currentEntry()
    guard let manifest = entry.manifest,
          manifest.enabled,
          manifest.style == "slideshow",
          manifest.photos.count > 1
    else {
      completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600))))
      return
    }

    let interval = max(15, manifest.slideshowIntervalSec)
    var entries: [PhotoWidgetEntry] = []
    let now = Date()
    for i in 0..<manifest.photos.count {
      let date = now.addingTimeInterval(Double(i * interval))
      entries.append(
        PhotoWidgetEntry(date: date, manifest: manifest, slideshowIndex: i)
      )
    }
    completion(Timeline(entries: entries, policy: .atEnd))
  }

  private func currentEntry() -> PhotoWidgetEntry {
    let manifest = PhotoWidgetData.loadManifest()
    return PhotoWidgetEntry(date: Date(), manifest: manifest, slideshowIndex: 0)
  }
}
