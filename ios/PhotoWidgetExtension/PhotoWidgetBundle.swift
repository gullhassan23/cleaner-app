import WidgetKit
import SwiftUI

@main
struct PhotoWidgetBundle: WidgetBundle {
  var body: some Widget {
    PhotoWidget()
  }
}

struct PhotoWidget: Widget {
  let kind: String = "PhotoWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: PhotoWidgetProvider()) { entry in
      PhotoWidgetEntryView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .configurationDisplayName("Photo Widget")
    .description("Photos from Cleaner App.")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}
