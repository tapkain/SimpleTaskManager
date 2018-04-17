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

  private var oldBackgroundColor: UIColor?
  
  override var isSelected: Bool {
    didSet {
      if isSelected {
        oldBackgroundColor = category.backgroundColor
        category.backgroundColor = UIColor(named: "MainDark")
        category.textColor = UIColor.white
      } else {
        category.backgroundColor = oldBackgroundColor
        category.textColor = UIColor.black
      }
    }
  }
  
  @IBOutlet weak var category: UILabel!
}
