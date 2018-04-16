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
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    if selected {
      title.text = nil
      title.attributedText = Styles.strikethrough(from: titleText)
    } else {
      title.attributedText = nil
      title.text = titleText
    }
  }
  
  @IBOutlet weak var categoriesView: UICollectionView!
  @IBOutlet weak var dueDate: UILabel!
  @IBOutlet weak var title: UILabel!
  var titleText: String!
}
