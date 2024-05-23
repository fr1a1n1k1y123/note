//
//  noteWidgetBundle.swift
//  noteWidget
//
//  Created by 羅群瀝 on 2024/5/21.
//

import WidgetKit
import SwiftUI

@main
struct ViewSizeWidget: Widget {
    let kind: String = "noteWidget"
    let widgetTitle = NSLocalizedString("widgetTitle", comment: "")
    let widgetSubtitle = NSLocalizedString("widgetSubtitle", comment: "")
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: noteWidgetTimelineProvider()) { entry in
            noteWidgetView(entry: entry)
        }
        .configurationDisplayName(widgetTitle)
        .description(widgetSubtitle)
        .supportedFamilies([
            .systemMedium,
            .systemLarge,
        ])
    }
}
