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
  private var categories: [Category]!
  
  @IBOutlet weak var showNotificationsSwitch: UISwitch!
  @IBOutlet weak var categoriesView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    showNotificationsSwitch.isOn = Preferences.sharedInstance.showNotifications
    reloadCategoriesView()
  }
  
  func reloadCategoriesView() {
    CoreDataStore.sharedInstance.fetch(Category.fetchRequest()) { categories in
      DispatchQueue.main.async {
        self.categories = categories
        self.categoryDelegate = CategoryViewDelegate(categories: categories, userInteractionEnabled: self.categoriesView.isUserInteractionEnabled)
        self.categoriesView.delegate = self.categoryDelegate
        self.categoriesView.dataSource = self.categoryDelegate
        self.categoriesView.reloadData()
      }
    }
  }
}


// MARK: - Actions
extension SettingsViewController {
  @IBAction func onShowNotificationsChanged() {
    Preferences.sharedInstance.showNotifications = showNotificationsSwitch.isOn
    if !showNotificationsSwitch.isOn {
      Notifications.sharedInstance.removeAllNotificationRequests()
    }
  }
}


// MARK: - Navigation
extension SettingsViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let categoryDetails = segue.destination as? CategoryDetailsViewController else {
      return
    }
    
    categoryDetails.dismissBlock = self.reloadCategoriesView
    if segue.identifier == "editSegue" {
      if let cell = sender as? CategoryCell,
         let indexPath = categoriesView.indexPath(for: cell) {
        categoryDetails.category = categories[indexPath.row]
      }
    }
  }
}
