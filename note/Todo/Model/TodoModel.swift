//
//  TodoModel.swift
//  note
//
//  Created by 羅群瀝 on 2024/5/20.
//

import Foundation
import RealmSwift

class Todos: Object{
    let todoList = List<Todo>()
}

class Todo: Object{
    @objc dynamic var date: String = ""
    @objc dynamic var startTime: String = ""
    @objc dynamic var endTime: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var isFinish:Bool = false
    
    
}
