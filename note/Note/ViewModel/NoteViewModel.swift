//
//  NoteViewModel.swift
//  note
//
//  Created by 羅群瀝 on 2024/5/20.
//

import Foundation
import RealmSwift
protocol NoteViewModelDelegate: AnyObject{
    func reloadList()
}

class NoteViewModel:ObservableObject{
    
    weak var delegate: NoteViewModelDelegate?
    var notes: Results<Notes>?
    let realm = try? Realm()
    
    init(){
        loadRealm()
    }
    
    func loadRealm(){
        notes = realm?.objects(Notes.self)
        if notes?.count == 0{
            do{
                try self.realm?.write{
                    realm?.add(Notes())
                }
            }catch{
                print("save fail: \(error )")
            }
        }
        delegate?.reloadList()

    }
    
    func addNewNote(newNote:Note){
        do{
            try realm?.write{
                notes?.first?.noteList.insert(newNote, at: 0)
                delegate?.reloadList()
            }
        }catch{
            print("save fail: \(error )")
        }
    }
    
    func deleteNote(forRowAt indexPath: IndexPath){
        if let note = notes?.first?.noteList[indexPath.row]{
            do{
                try realm?.write{
                    realm?.delete(note)
                    delegate?.reloadList()
                }
            }catch{
                print("delete fail")
            }
        }
    }
    
    func moveNote(sourceIndexPath:IndexPath, destinationIndexPath:IndexPath){
        do{
            try realm?.write{
                notes?.first?.noteList.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
                delegate?.reloadList()
            }
        }catch{
            
        }
    }
    
    func updateTitle(row: Int, title: String){
        if let note = notes?.first?.noteList[row]{
            do{
                try realm?.write{
                    note.title = title
                }
            }catch{
                print("save title fail:\(error)")
            }
        }
    }
    
    func updateContent(row: Int, content: String){
        if let note = notes?.first?.noteList[row]{
            do{
                try realm?.write{
                    if content != note.content {
                        note.backup = note.content
                    }
                    note.content = content
                    
                }
            }catch{
                print("save content fail:\(error)")
            }
        }
    }
    func resetContent(row: Int, content: String){
        if let note = notes?.first?.noteList[row]{
            do{
                try realm?.write{
                    if note.backup != ""{
                        note.content = note.backup
                    }
                }
            }catch{
                print("save content fail:\(error)")
            }
        }
    }
}
