//
//  SettingsViewController.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/18/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  private var categoryDelegate: CategoryViewDelegate!
  
  @IBOutlet weak var showNotificationsSwitch: UISwitch!
  @IBOutlet weak var categoryButton: UIButton!
  @IBOutlet weak var categoriesView: UICollectionView!
  
  override func viewDidLoad() {
    showNotificationsSwitch.isOn = Preferences.sharedInstance.showNotifications
    
    CoreDataStore.sharedInstance.fetch(Category.fetchRequest()) { categories in
      DispatchQueue.main.async {
        self.categoryDelegate = CategoryViewDelegate(categories: categories, userInteractionEnabled: self.categoriesView.isUserInteractionEnabled)
        self.categoriesView.delegate = self.categoryDelegate
        self.categoriesView.dataSource = self.categoryDelegate
      }
    }
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
