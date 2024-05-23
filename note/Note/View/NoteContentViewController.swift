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
    func reset(row: Int, content: String, viewController:NoteContentViewController)
}

class NoteContentViewController: UIViewController, UIGestureRecognizerDelegate {
    let alertTitle = NSLocalizedString("NoteContentVC.alertTitle", comment: "")
    let alertSubTitle = NSLocalizedString("NoteContentVC.alertSubTitle", comment: "")
    let confirmStr = NSLocalizedString("ConfirmBtn", comment: "")
    let cancelStr = NSLocalizedString("CancelBtn", comment: "")
    let doneStr = NSLocalizedString("doneBtn", comment: "")

    weak var delegate: NoteContentViewControllerDelegate?
    var row: Int?
    var resetBtn = UIBarButtonItem()
    var shareBtn = UIBarButtonItem()
    var backBtn = UIBarButtonItem()
    let scrollView = UIScrollView()
    var isSaved = true
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
        if isSaved == true{
            resetBtn = UIBarButtonItem(image: UIImage(systemName: "clock.arrow.circlepath"), style: .done, target: self, action: #selector(resetNote))
            resetBtn.tintColor = .label
        }
        shareBtn = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(didtapShareBtn))
        shareBtn.tintColor = .label
        navigationItem.rightBarButtonItems = [shareBtn]
        backBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(didtapBackBtn))
        backBtn.tintColor = .label
        navigationItem.leftBarButtonItems = [backBtn,resetBtn]
        navigationController?.interactivePopGestureRecognizer?.delegate = self
      
    }
    @objc func didtapBackBtn(){
        navigationController?.popViewController(animated: true)
    }
    @objc func didTapDone(){
        isSaved = true
        delegate?.updateContent(row: row ?? 0, content: textView.text)
        textView.resignFirstResponder()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        guard let navigationBar = navigationController?.navigationBar else{return}
    
 
        textView.frame = CGRect(x: 10, y: 0, width: view.width - 20, height: view.height)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20
    }
    @objc func resetNote(){
        let alertController = UIAlertController(title: alertTitle, message: alertSubTitle, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelStr, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
              
        let okAction = UIAlertAction(title: confirmStr, style: .destructive) { (action) in
            self.delegate?.reset(row: self.row ?? 0, content: self.textView.text, viewController:self)

        }
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
      
    }
    @objc func didtapShareBtn(){
        let activityVC = UIActivityViewController(activityItems: [textView.text!], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }

    

}
extension NoteContentViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if isSaved == true{
            resetBtn = UIBarButtonItem(image: UIImage(systemName: "clock.arrow.circlepath"), style: .done, target: self, action: #selector(resetNote))
            resetBtn.tintColor = .label

        }
        navigationItem.rightBarButtonItems = [shareBtn]
        navigationItem.leftBarButtonItems = [backBtn,resetBtn]
    }
  
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isSaved == true{
            resetBtn = UIBarButtonItem(image: UIImage(systemName: "clock.arrow.circlepath"), style: .done, target: self, action: #selector(resetNote))
            resetBtn.tintColor = .label
        }
       let doneBtn = UIBarButtonItem(title:doneStr, style: .done, target: self, action: #selector(didTapDone))
        doneBtn.tintColor = .label
        navigationItem.rightBarButtonItems = [doneBtn,shareBtn]
        navigationItem.leftBarButtonItems = [backBtn,resetBtn]
        return true
    }
    
    
}
