//
//  Print.swift
//  note
//
//  Created by 羅群瀝 on 2024/5/3.
//

import Foundation
import UIKit

public func print(_ items: String, fileName: String = #file, function: String = #function, line: Int = #line, separator: String = "", terminator: String = "\n"){
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS  "
    
    let pretty = "\(formatter.string(from: Date())) \(URL(fileURLWithPath: fileName).lastPathComponent) [#\(line)] \(function) \n\t-> "
    let output = items.map{"\($0)"}.joined(separator: separator)
    Swift.print(pretty+output, terminator: terminator)
    
}
