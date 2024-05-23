//
//  Data.swift
//  note
//
//  Created by 羅群瀝 on 2024/5/2.
//

import Foundation
import RealmSwift

class Notes: Object{
    let noteList = List<Note>()
}

class Note: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var backup: String = ""
    
}
