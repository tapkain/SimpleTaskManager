//
//  CoreDataStore.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/15/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import CoreData

class CoreDataStore {
  // MARK: - Properties
  
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "SimpleTaskManager")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  private lazy var managedObjectContext = {
    return persistentContainer.viewContext
  }()
  
  static let sharedInstance = CoreDataStore()
  
  // MARK: - CRUD
  
  func save(_ completionHandler: ((Bool) -> Void)? = nil) {
    do {
      if (!managedObjectContext.hasChanges) {
        completionHandler?(true)
        return
      }
      
      try managedObjectContext.save()
      completionHandler?(true)
    } catch {
      completionHandler?(false)
      fatalError("Failure to save context: \(error)")
    }
  }
  
  func fetch<Entity: NSManagedObject>(_ fetchRequest: NSFetchRequest<Entity>, completionHandler: @escaping ([Entity]) -> Void) {
    managedObjectContext.perform {
      do {
        let entities = try self.managedObjectContext.fetch(fetchRequest) as! [Entity]
        completionHandler(entities)
      } catch {
        completionHandler([])
      }
    }
  }
  
  func create<Entity: NSManagedObject>() -> Entity {
    return NSEntityDescription.insertNewObject(forEntityName: String(describing: Entity.self), into: self.managedObjectContext) as! Entity
  }
  
  func delete<Entity: NSManagedObject>(_ entity: Entity, completionHandler: ((Bool) -> Void)? = nil) {
    managedObjectContext.perform {
      self.managedObjectContext.delete(entity)
      self.save { result in
        completionHandler?(result)
      }
    }
  }
}
