//
//  SettingsViewController.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/18/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  let showNotificationPref = "showNotification"
  
  @IBOutlet weak var showNotificationsSwitch: UISwitch!
  @IBOutlet weak var categoryButton: UIButton!
  @IBOutlet weak var categoriesView: UICollectionView!
  
  override func viewDidLoad() {
    showNotificationsSwitch.isOn = Preferences.sharedInstance.showNotifications
  }
}


// MARK: - Actions
extension SettingsViewController {
  @IBAction func onCategoryButtonPressed() {
    // TODO: implement category adding/editing
  }
  
  @IBAction func onShowNotificationsChanged() {
    Preferences.sharedInstance.showNotifications = showNotificationsSwitch.isOn
    if !showNotificationsSwitch.isOn {
      Notifications.sharedInstance.removeAllNotificationRequests()
    }
  }
}
