//
//  ViewController.swift
//  note
//
//  Created by 羅群瀝 on 2024/5/2.
//

import UIKit
import SnapKit
import RealmSwift

class NoteViewController: UIViewController{
    

    private let homeTableview = UITableView()
    
    
    var notes: Results<Notes>?
    let realm = try? Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeTableview)
        configTableView()
        configNavigationBar()
        loadRealm()
    }
    func configTableView(){
        homeTableview.dataSource = self
        homeTableview.delegate = self
        homeTableview.register(NoteCell.self, forCellReuseIdentifier: NoteCell.identifier)
    }
    
    func configNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapPlusBtn))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "編輯", style: .done, target: self, action: #selector(didtapEdit))
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
        homeTableview.reloadData()

    }
    @objc func didtapEdit(){
        if  navigationItem.leftBarButtonItem?.title == "完成"{
            navigationItem.leftBarButtonItem?.title = "編輯"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapPlusBtn))
        }else{
            navigationItem.leftBarButtonItem?.title = "完成"
            navigationItem.rightBarButtonItem = UIBarButtonItem()
            
        }
        UIView.animate(withDuration: 0.3) {
            UIView.animate(withDuration: 0.3, animations: {
                self.homeTableview.isEditing.toggle()
                for n in 0..<(self.notes?.first?.notes.count ?? 0){
                    let indexPath = IndexPath(row: n, section: 0)
                    let cell = self.homeTableview.cellForRow(at: indexPath) as? NoteCell
                    let title = cell?.titleLabel.text
                    self.updateTitle(row: n, title: title ?? "")
                }
            }, completion: { _ in
                DispatchQueue.main.async {
                    self.homeTableview.reloadData()
                    
                }
            })
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let navigationBar = navigationController?.navigationBar else{return}
        homeTableview.snp.remakeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    @objc func didTapPlusBtn(){
    
        let alertController = UIAlertController(title: "設定標題", message: nil, preferredStyle: .alert)
              
              alertController.addTextField { (textField) in
                  textField.placeholder = "請輸入文字"
              }
              
              let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
              alertController.addAction(cancelAction)
              
              let okAction = UIAlertAction(title: "確定", style: .default) { (action) in
                  if let textField = alertController.textFields?.first, let inputText = textField.text {
                      let newNote = Note()
                      newNote.title = inputText
                     
                      do{
                          try self.realm?.write{
                              self.notes?.first?.notes.insert(newNote, at: 0)
                              self.homeTableview.reloadData()
                          }
                      }catch{
                          print("save fail: \(error )")
                      }
                  }
              }
              alertController.addAction(okAction)
              
              present(alertController, animated: true, completion: nil)
    }

}

extension NoteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.first?.notes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.identifier, for: indexPath) as! NoteCell
        cell.titleText = notes?.first?.notes[indexPath.row].title ?? ""
        cell.accessoryType = .disclosureIndicator
        if tableView.isEditing == true{
            cell.isEnabled()
        }else{
            cell.isNotEnabled()
        }
       
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = NoteContentViewController()
        vc.row = indexPath.row
        vc.delegate = self
        vc.textView.text = notes?.first?.notes[indexPath.row].content ?? ""
        navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        do{
            try realm?.write{
                notes?.first?.notes.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
                homeTableview.reloadData()
            }
        }catch{
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let note = notes?.first?.notes[indexPath.row]{
                do{
                    try realm?.write{
                        realm?.delete(note)
                        homeTableview.reloadData()
                    }
                }catch{
                    print("delete fail")
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 返回单元格的高度
        return 50 // 自定义的单元格高度
    }
    
    func updateTitle(row: Int, title: String){
        if let note = notes?.first?.notes[row]{
            do{
                try realm?.write{
                    note.title = title
                }
            }catch{
                print("save title fail:\(error)")
            }
        }
    }
}
extension NoteViewController: NoteContentViewControllerDelegate{
    func updateContent(row: Int, content: String) {
        if let note = notes?.first?.notes[row]{
            do{
                try realm?.write{
                    note.content = content
                }
            }catch{
                print("save content fail:\(error)")
            }
        }
    }
    
    
}
