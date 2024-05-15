//
//  NoteContentViewController.swift
//  note
//
//  Created by 羅群瀝 on 2024/5/2.
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift

protocol NoteContentViewControllerDelegate:AnyObject{
    func updateContent(row: Int, content: String)
}

class NoteContentViewController: UIViewController {
    weak var delegate: NoteContentViewControllerDelegate?
    var row: Int?

    let scrollView = UIScrollView()
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 20)
//        textView.isScrollEnabled = false
        return textView
    }()
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.updateContent(row: row ?? 0, content: textView.text)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        textView.delegate = self
        view.addSubview(textView)
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    @objc func didTapDone(){
        textView.resignFirstResponder()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        guard let navigationBar = navigationController?.navigationBar else{return}
    
 
        textView.frame = CGRect(x: 10, y: 0, width: view.width - 20, height: view.height)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20
    }

}
extension NoteContentViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = UIBarButtonItem()
    }
  
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(didTapDone))
        return true
    }
    
    
}
