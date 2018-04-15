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
    save {_ in}
  }
  
  
  // MARK: - CRUD
  
  func save(_ completionHandler: @escaping (Bool) -> Void) {
    do {
      try managedObjectContext.save()
      completionHandler(true)
    } catch {
      completionHandler(false)
      fatalError("Failure to save context: \(error)")
    }
  }
  
  func fetch<Entity: NSManagedObject>(completionHandler: @escaping ([Entity]) -> Void) {
    managedObjectContext.perform {
      do {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Entity.self))
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
  
  func delete<Entity: NSManagedObject>(_ entity: Entity, completionHandler: @escaping (Bool) -> Void) {
    managedObjectContext.perform {
      self.managedObjectContext.delete(entity)
      self.save { result in
        completionHandler(result)
      }
    }
  }
}
