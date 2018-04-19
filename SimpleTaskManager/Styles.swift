//
//  Styles.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/16/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit

struct Styles {
  static func strikethrough(from text: String) -> NSAttributedString {
    let attributeString = NSMutableAttributedString(string: text)
    attributeString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
    return attributeString
  }
  
  static func size(of text: String, font: UIFont) -> CGSize {
    let text = text as NSString
    return text.size(withAttributes: [.font: font])
  }
  
  static let systemFont: UIFont = {
    return UIFont.systemFont(ofSize: UIFont.systemFontSize)
  }()
  
  static let categoryFont: UIFont = {
    return UIFont.systemFont(ofSize: 14, weight: .medium)
  }()
  
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
  }()
}
