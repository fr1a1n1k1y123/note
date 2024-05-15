//
//  File.swift
//  note
//
//  Created by 羅群瀝 on 2024/5/2.
//

import Foundation
import UIKit
import SnapKit

class NoteCell: UITableViewCell, UITextFieldDelegate {
    static let identifier = "NoteCell"
    
    var titleText = ""{
        didSet{
            titleLabel.text = titleText
        }
    }
    
    let titleLabel: UITextField = {
        let label = UITextField()
        label.font = .systemFont(ofSize: 20)
       return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        titleLabel.delegate = self
        
    }
   
    required init?(coder: NSCoder) {
        fatalError("init (coder:) has not bee implemented")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.right.equalTo(contentView.snp.right).offset(-20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
        
    }
    
    func isEnabled(){
        titleLabel.isEnabled = true
    }
    func isNotEnabled(){
        titleLabel.isEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    

    
    
}

