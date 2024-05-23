//
//  noteWidget.swift
//  noteWidget
//
//  Created by 羅群瀝 on 2024/5/21.
//
import SwiftUI
import RealmSwift
import UIKit
import WidgetKit

struct noteWidgetView : View {
   
    let entry: noteWidgetEntry

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading){
                
                // Show view size
                Text(entry.title)
                
                // Show provider info
                Text(entry.content)
                    
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            .containerBackground(for: .widget) {
                        Color.white
                    }
            
        }
    }
}
struct ViewSizeWidget_Previews: PreviewProvider {
    static var previews: some View {
        noteWidgetView(entry: noteWidgetEntry(date: Date(), title: "記事本", content: "方便操作，簡易設計"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

