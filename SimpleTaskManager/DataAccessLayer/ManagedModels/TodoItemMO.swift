//
//  TodoItemMO.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/15/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import CoreData

class TodoItemMO: NSManagedObject {
  @NSManaged var title: String?
  @NSManaged var dueDate: Date?
}

extension TodoItemMO {
  func toTodoItem() -> TodoItem {
    return TodoItem(title: title!, dueDate: dueDate!, categories: [])
  }
  
  func from(todoItem: TodoItem) {
    dueDate = todoItem.dueDate
    title = todoItem.title
  }
}
