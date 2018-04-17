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
    
    var rightButtonTitle = ""
    isNewTask = task == nil
    
    if isNewTask {
      let newTask: Task = CoreDataStore.sharedInstance.create()
      newTask.completed = false
      task = newTask
      rightButtonTitle = "Add"
      title = "Add Task"
    } else {
      rightButtonTitle = "Edit"
      title = "Edit Task"
    }
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightButtonTitle, style: .plain, target: self, action: #selector(onFinishEditButtonPressed))
    
    setupViews()
  }
  
  func setupViews() {
    taskTitle.text = task.title
    dueDate.minimumDate = Date()
    
    if let date = task.dueDate {
      dueDate.date = date
    }
    
    CoreDataStore.sharedInstance.fetch(Category.fetchRequest()) { categories in
      self.allCategories = categories
      self.categoryDelegate = CategoryViewDelegate(categories: categories, userInteractionEnabled: self.categoriesView.isUserInteractionEnabled)
      self.categoriesView.delegate = self.categoryDelegate
      self.categoriesView.dataSource = self.categoryDelegate
      self.categoriesView.allowsMultipleSelection = true
    }
  }
}


// MARK: - Actions
extension TaskDetailsViewController {
  @objc func onFinishEditButtonPressed() {
    task.title = taskTitle.text
    task.dueDate = dueDate.date
    
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
