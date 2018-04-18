//
//  AppDelegate.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/15/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    Notifications.sharedInstance.requestPermission()
    return true
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    CoreDataStore.sharedInstance.save()
  }
}

