//
//  CategoryCell.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/15/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
  static let identifier = String(describing: CategoryCell.self)

  @IBOutlet weak var category: UILabel!
}
