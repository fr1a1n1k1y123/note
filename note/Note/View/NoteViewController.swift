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
    let noteStr = NSLocalizedString("NoteVC.NavTitle", comment: "")
    let doneStr = NSLocalizedString("doneBtn", comment: "")
    let confirmStr = NSLocalizedString("ConfirmBtn", comment: "")
    let cancelStr = NSLocalizedString("CancelBtn", comment: "")
    let alertTitle = NSLocalizedString("NoteVC.alertTitle", comment: "")
    let alertPlaceHolder = NSLocalizedString("NoteVC.alertPlaceHolder", comment: "")

    private let noteTableview = UITableView()
    let viewModel = NoteViewModel()
    let newNoteBtn = UIButton()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configNavigationBar()
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noteTableview)
        view.addSubview(newNoteBtn)
        configTableView()
        configNewnoteBtn()
        viewModel.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let navigationBar = navigationController?.navigationBar else{return}
        noteTableview.snp.remakeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        newNoteBtn.snp.remakeConstraints { make in
            make.height.equalTo(70)
            make.width.equalTo(70)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom).offset(-100)
        }
        
    }

    
    func configTableView(){
        noteTableview.dataSource = self
        noteTableview.delegate = self
        noteTableview.register(NoteCell.self, forCellReuseIdentifier: NoteCell.identifier)
    }
    func configNewnoteBtn(){
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 70, weight: .bold, scale: .large)
        let largeImage = UIImage(systemName: "plus.circle", withConfiguration: largeConfig)
        newNoteBtn.setImage(largeImage, for: .normal)
        newNoteBtn.tintColor = .label
        newNoteBtn.addTarget(self, action: #selector(didTapPlusBtn), for: .touchUpInside)
    }
    
    func configNavigationBar(){
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapPlusBtn))

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(didtapEdit))
        navigationItem.title = noteStr
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationItem.leftBarButtonItem?.tintColor = .label
    }
    

    @objc func didtapEdit(){
        
        if  navigationItem.leftBarButtonItem?.title != doneStr{

            navigationItem.leftBarButtonItem? = UIBarButtonItem(title: doneStr, style: .done, target: self, action: #selector(didtapEdit))
            newNoteBtn.isHidden = true
        }else{
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(didtapEdit))
        
            newNoteBtn.isHidden = false
        }
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationItem.leftBarButtonItem?.tintColor = .label
        UIView.animate(withDuration: 0.3) {
            UIView.animate(withDuration: 0.3, animations: {
                self.noteTableview.isEditing.toggle()
                for n in 0..<(self.viewModel.notes?.first?.noteList.count ?? 0){
                    let indexPath = IndexPath(row: n, section: 0)
                    let cell = self.noteTableview.cellForRow(at: indexPath) as? NoteCell
                    let title = cell?.titleLabel.text
                    self.viewModel.updateTitle(row: n, title: title ?? "")
                }
            }, completion: { _ in
                DispatchQueue.main.async {
                    self.noteTableview.reloadData()
                    
                }
            })
        }
    }
    
    @objc func didTapPlusBtn(){
    
        let alertController = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
              
              alertController.addTextField { (textField) in
                  textField.placeholder = self.alertPlaceHolder
              }
              
              let cancelAction = UIAlertAction(title: cancelStr, style: .cancel, handler: nil)
              alertController.addAction(cancelAction)
              
              let okAction = UIAlertAction(title: confirmStr, style: .default) { (action) in
                  if let textField = alertController.textFields?.first, let inputText = textField.text {
                      let newNote = Note()
                      newNote.title = inputText
                      self.viewModel.addNewNote(newNote: newNote)
                      let vc = NoteContentViewController()
                      vc.row = 0
                      vc.delegate = self
                      vc.navigationItem.title = self.viewModel.notes?.first?.noteList[0].title ?? ""
                      vc.textView.text = self.viewModel.notes?.first?.noteList[0].content ?? ""
                      vc.isSaved = false
                      self.navigationController?.pushViewController(vc, animated: true)
                  }
              }
              alertController.addAction(okAction)
              
              present(alertController, animated: true, completion: nil)
    }
    
 

}

extension NoteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notes?.first?.noteList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.identifier, for: indexPath) as! NoteCell
        cell.titleText = viewModel.notes?.first?.noteList[indexPath.row].title ?? ""
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
        vc.navigationItem.title = self.viewModel.notes?.first?.noteList[indexPath.row].title ?? ""
        vc.textView.text = viewModel.notes?.first?.noteList[indexPath.row].content ?? ""
        navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveNote(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteNote(forRowAt: indexPath)
        }
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
  
}
extension NoteViewController: NoteContentViewControllerDelegate{
    func reset(row: Int, content: String, viewController: NoteContentViewController) {
        viewModel.resetContent(row: row, content: content)
        viewController.textView.text = viewModel.notes?.first?.noteList[row].content ?? ""
        
        

    }
    
  
    
    func updateContent(row: Int, content: String) {
        viewModel.updateContent(row: row, content: content)
        
    }
  
    
}
extension NoteViewController: NoteViewModelDelegate{
    func reloadList() {
        noteTableview.reloadData()
    }
}

