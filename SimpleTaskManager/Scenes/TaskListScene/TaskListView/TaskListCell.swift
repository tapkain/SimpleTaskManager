//
//  TaskListCell.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/15/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit

class TaskListCell: UITableViewCell {
  static let identifier = String(describing: TaskListCell.self)
  
  override func prepareForReuse() {
    super.prepareForReuse()
    categoriesView.delegate = nil
    categoriesView.dataSource = nil
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  func setupView() {
    backgroundView = UIView()
    backgroundView?.backgroundColor = .white
  }
  
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    if highlighted {
      backgroundView?.backgroundColor = .red
    } else {
      backgroundView?.backgroundColor = .white
    }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    if selected {
      backgroundView?.backgroundColor = .blue
    } else {
      backgroundView?.backgroundColor = .white
    }
  }

//  override func setSelected(_ selected: Bool, animated: Bool) {
//    if selected {
//      backgroundView?.backgroundColor = .gray
//    } else {
//      backgroundView?.backgroundColor = .white
//    }
//    if selected {
////      title.text = nil
////      let attr = [ NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle ]
////      title.attributedText = NSAttributedString(string: titleText, attributes: attr)
//      selectedBackgroundView?.backgroundColor = .red
//    } else {
//      selectedBackgroundView?.backgroundColor = .white
////      title.attributedText = nil
////      title.text = titleText
//    }
 // }
  
  @IBOutlet weak var categoriesView: UICollectionView!
  @IBOutlet weak var dueDate: UILabel!
  @IBOutlet weak var title: UILabel!
  var titleText: String!
}
