//
//  Category.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/15/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CategoryMO: NSManagedObject {
  @NSManaged var name: String?
  @NSManaged var color: UIColor?
}

extension CategoryMO {
  func toCategory() -> Category {
    return Category(name: name!, color: color!)
  }
}
