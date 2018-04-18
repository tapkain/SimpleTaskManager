//
//  Preferences.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/18/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

class Preferences {
  static let sharedInstance = Preferences()
  
  enum PreferenceKey: String {
    case showNotifications = "showNotifications"
  }
  
  var showNotifications: Bool {
    get {
      guard let value = UserDefaults.standard.object(forKey: PreferenceKey.showNotifications.rawValue) as? Bool else {
        return true
      }
      
      return value
    }
    
    set {
      UserDefaults.standard.set(newValue, forKey: PreferenceKey.showNotifications.rawValue)
    }
  }
}
