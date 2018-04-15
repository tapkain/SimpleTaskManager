//
//  TaskListCell.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/15/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit

class TaskListCell: UITableViewCell {
  static let identifier = String(describing: self)
  
  @IBOutlet weak var categoriesView: UICollectionView!
  @IBOutlet weak var dueDate: UILabel!
  @IBOutlet weak var title: UILabel!
}
