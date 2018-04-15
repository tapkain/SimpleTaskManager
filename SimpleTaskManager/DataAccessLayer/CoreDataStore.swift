//
//  CoreDataStore.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/15/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import CoreData

class CoreDataStore {
  var managedObjectContext: NSManagedObjectContext
  
  
  // MARK: - Object Lifecycle
  
  init(completionClosure: @escaping () -> ()) {
    //This resource is the same name as your xcdatamodeld contained in your project
    guard let modelURL = Bundle.main.url(forResource: "SimpleTaskManager", withExtension:"momd") else {
      fatalError("Error loading model from bundle")
    }
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
      fatalError("Error initializing mom from: \(modelURL)")
    }
    
    let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
    
    managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = psc
    
    let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
    queue.async {
      guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
        fatalError("Unable to resolve document directory")
      }
      let storeURL = docURL.appendingPathComponent("SimpleTaskManager.sqlite")
      do {
        try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        //The callback block is expected to complete the User Interface and therefore should be presented back on the main queue so that the user interface does not need to be concerned with which queue this call is coming from.
        DispatchQueue.main.sync(execute: completionClosure)
      } catch {
        fatalError("Error migrating store: \(error)")
      }
    }
  }
  
  deinit {
    save()
  }
  
  
  // MARK: - CRUD
  
  func save() {
    do {
      try managedObjectContext.save()
    } catch {
      fatalError("Failure to save context: \(error)")
    }
  }
  
  func fetchTodoItems(completionHandler: @escaping ([TodoItem]) -> Void) {
    managedObjectContext.perform {
      do {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItem")
        let results = try self.managedObjectContext.fetch(fetchRequest) as! [TodoItemMO]
        let todoItems = results.map { $0.toTodoItem() }
        completionHandler(todoItems)
      } catch {
        completionHandler([])
      }
    }
  }
  
  func create(todoItem: TodoItem, completionHandler: @escaping (TodoItem?) -> Void) {
    managedObjectContext.perform {
      do {
        let managedTodoItem = NSEntityDescription.insertNewObject(forEntityName: "TodoItem", into: self.managedObjectContext) as! TodoItemMO
        managedTodoItem.from(todoItem: todoItem)
        try self.managedObjectContext.save()
        completionHandler(todoItem)
      } catch {
        completionHandler(nil)
      }
    }
  }
  
  func update(todoItem: TodoItem, completionHandler: @escaping (TodoItem?) -> Void) {
    privateManagedObjectContext.perform {
      do {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItem")
        fetchRequest.predicate = NSPredicate(format: "title == %@", todoItem.title)
        let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [TodoItemMO]
        if let managedTodoItem = results.first {
          do {
            managedTodoItem.from(todoItem: todoItem)
            try self.privateManagedObjectContext.save()
            completionHandler(todoItem)
          } catch {
            completionHandler(nil)
          }
        }
      } catch {
        completionHandler(nil)
      }
    }
  }
  
  func delete(todoItem: TodoItem, completionHandler: @escaping (TodoItem) -> Void) {
    privateManagedObjectContext.perform {
      do {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItem")
        fetchRequest.predicate = NSPredicate(format: "title == %@", todoItem.title)
        let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [TodoItemMO]
        if let managedTodoItem = results.first {
          self.privateManagedObjectContext.delete(managedTodoItem)
          do {
            try self.privateManagedObjectContext.save()
            completionHandler(todoItem)
          } catch {
            completionHandler(nil)
          }
        }
      } catch {
        completionHandler(nil)
      }
    }
  }
}
