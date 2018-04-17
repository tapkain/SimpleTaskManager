//
//  Task+Helper.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/17/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import CoreData

extension Task {
  var categoriesList: [Category] {
    guard let result = categories?.allObjects.map({ $0 as! Category }) else {
      return []
    }
    return result
  }
}
