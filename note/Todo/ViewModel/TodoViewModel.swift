//
//  TodoViewModel.swift
//  note
//
//  Created by 羅群瀝 on 2024/5/20.
//

import Foundation
import RealmSwift

protocol TodoViewModelDelegate: AnyObject{
    func reloadList()
}


class TodoViewModel{
    var todos: Results<Todos>?
    let realm = try? Realm()
    weak var delegate: TodoViewModelDelegate?
    
    init(){
        loadRealm()
    }
    
    func loadRealm(){
        todos = realm?.objects(Todos.self)
        if todos?.count == 0{
            do{
                try self.realm?.write{
                    realm?.add(Todos())
                }
            }catch{
                print("save fail: \(error )")
            }
        }
        delegate?.reloadList()
    }
    func addNewNote(newTodo:Todo){
        do{
            try realm?.write{
                todos?.first?.todoList.insert(newTodo, at: 0)
                delegate?.reloadList()
            }
        }catch{
            print("save fail: \(error )")
        }
    }
}
