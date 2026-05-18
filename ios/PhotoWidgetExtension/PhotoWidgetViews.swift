import SwiftUI
import WidgetKit

struct PhotoWidgetEntryView: View {
  var entry: PhotoWidgetEntry

  var body: some View {
    if let manifest = entry.manifest, manifest.enabled, !manifest.photos.isEmpty {
      if manifest.style == "slideshow" {
        SlideshowWidgetView(manifest: manifest, index: entry.slideshowIndex)
      } else {
        GridWidgetView(manifest: manifest)
      }
    } else {
      EmptyWidgetView()
    }
  }
}

struct GridWidgetView: View {
  let manifest: PhotoWidgetManifest

  var body: some View {
    let sorted = manifest.photos.sorted { $0.order < $1.order }
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    LazyVGrid(columns: columns, spacing: 4) {
      ForEach(0..<4, id: \.self) { i in
        if i < sorted.count,
           let image = PhotoWidgetData.loadImage(manifest: manifest, fileName: sorted[i].fileName) {
          Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .clipped()
        } else {
          Color.gray.opacity(0.2)
        }
      }
    }
    .padding(4)
  }
}

struct SlideshowWidgetView: View {
  let manifest: PhotoWidgetManifest
  let index: Int

  var body: some View {
    let sorted = manifest.photos.sorted { $0.order < $1.order }
    let safeIndex = sorted.isEmpty ? 0 : index % sorted.count
    if safeIndex < sorted.count,
       let image = PhotoWidgetData.loadImage(
         manifest: manifest,
         fileName: sorted[safeIndex].fileName
       ) {
      Image(uiImage: image)
        .resizable()
        .scaledToFill()
        .clipped()
    } else {
      EmptyWidgetView()
    }
  }
}

struct EmptyWidgetView: View {
  var body: some View {
  ZStack {
      Color(.systemGray6)
      VStack(spacing: 6) {
        Image(systemName: "photo.on.rectangle.angled")
          .font(.title2)
          .foregroundStyle(.secondary)
        Text("Tap to set up")
          .font(.caption)
          .foregroundStyle(.secondary)
      }
    }
  }
}
