//
//  TaskDetailsViewController.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/17/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit

class TaskDetailsViewController: UIViewController {
  var task: Task!
  var categoryDelegate: CategoryViewDelegate!
  var isNewTask = false
  var allCategories: [Category]!
  
  @IBOutlet weak var categoriesView: UICollectionView!
  @IBOutlet weak var dueDate: UIDatePicker!
  @IBOutlet weak var taskTitle: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationButtons()
    setupViews()
  }
  
  func setupNavigationButtons() {
    var rightBarButtonItems: [UIBarButtonItem] = []
    var rightButtonTitle = ""
    isNewTask = task == nil
    
    if isNewTask {
      let newTask: Task = CoreDataStore.sharedInstance.create()
      task = newTask
      rightButtonTitle = "Add"
      title = "Add Task"
    } else {
      let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(onDeleteButtonPressed))
      rightBarButtonItems.append(deleteButton)
      rightButtonTitle = "Edit"
      title = "Edit Task"
    }
    
    let editButton = UIBarButtonItem(title: rightButtonTitle, style: .plain, target: self, action: #selector(onFinishEditButtonPressed))
    rightBarButtonItems.append(editButton)
    rightBarButtonItems.reverse()
    navigationItem.rightBarButtonItems = rightBarButtonItems
  }
  
  func setupViews() {
    taskTitle.text = task.title
    dueDate.minimumDate = Date()
    
    if let date = task.dueDate {
      dueDate.date = date
    }
    
    CoreDataStore.sharedInstance.fetch(Category.fetchRequest()) { categories in
      self.setupCategoriesView(with: categories)
    }
  }
  
  func setupCategoriesView(with categories: [Category]) {
    allCategories = categories
    categoryDelegate = CategoryViewDelegate(categories: categories, userInteractionEnabled: categoriesView.isUserInteractionEnabled)
    categoriesView.delegate = categoryDelegate
    categoriesView.dataSource = categoryDelegate
    categoriesView.allowsMultipleSelection = true
    
    if !isNewTask {
      for category in task.categoriesList {
        if let row = categories.index(of: category) {
          let indexPath = IndexPath(row: row, section: 0)
          
          DispatchQueue.main.async {
            self.categoriesView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
          }
        }
      }
    }
  }
}


// MARK: - Actions
extension TaskDetailsViewController {
  @objc func onDeleteButtonPressed() {
    CoreDataStore.sharedInstance.delete(task) {_ in
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  @objc func onFinishEditButtonPressed() {
    guard let taskTitle = taskTitle.text, taskTitle.count > 0 else {
      return
    }
    
    let oldDueDate = task.dueDate
    task.dueDate = dueDate.date
    task.title = taskTitle
    
    if oldDueDate == nil || oldDueDate! != dueDate.date {
      if Preferences.sharedInstance.showNotifications {
        Notifications.sharedInstance.scheduleNotification(with: task)
      }
    }
    
    let selectedCategories = categoriesView.indexPathsForSelectedItems?.map { allCategories[$0.row] }
    task.categories = NSSet(array: selectedCategories ?? [])
    
    CoreDataStore.sharedInstance.save {_ in
      self.isNewTask = false
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  override func willMove(toParentViewController parent: UIViewController?) {
    if isNewTask {
      CoreDataStore.sharedInstance.delete(task)
    }
  }
}
