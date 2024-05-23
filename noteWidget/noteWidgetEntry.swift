//
//  noteWidgetEntry.swift
//  note
//
//  Created by 羅群瀝 on 2024/5/22.
//

import Foundation
import WidgetKit
import SwiftUI
import RealmSwift

struct noteWidgetEntry: TimelineEntry {
    let date: Date
    let title: String
    let content: String
}
