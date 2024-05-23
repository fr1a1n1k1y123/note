//
//  noteWidgetTimelineProvider.swift
//  note
//
//  Created by 羅群瀝 on 2024/5/22.
//

import SwiftUI
import RealmSwift
import UIKit
import WidgetKit

struct noteWidgetTimelineProvider: TimelineProvider {
    let widgetPlaceholderTitle = NSLocalizedString("widgetPlaceHolderTitle", comment: "")
    let widgetPlaceholderContent = NSLocalizedString("widgetPlaceHoldercContent", comment: "")
    
    typealias Entry = noteWidgetEntry
    
    func placeholder(in context: Context) -> Entry {
        return noteWidgetEntry(date: Date(), title: "", content: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        
        let entry = noteWidgetEntry(date: Date(), title: widgetPlaceholderTitle, content: widgetPlaceholderContent)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let config = Realm.Configuration(
            fileURL: FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.chunli.note")?.appendingPathComponent("default.realm"),
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                // Perform migrations if needed
            }
        )
        Realm.Configuration.defaultConfiguration = config

        let realm = try? Realm()
        let notes = realm?.objects(Notes.self)
        let note = notes?.first?.noteList[0]
        let entry = noteWidgetEntry(date: Date(), title: note?.title ?? "", content: note?.content ?? "")
          let timeline = Timeline(entries: [entry], policy: .never)
          completion(timeline)
    }
}

