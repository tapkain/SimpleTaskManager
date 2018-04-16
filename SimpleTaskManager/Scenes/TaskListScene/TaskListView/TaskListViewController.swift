//
//  TaskListViewController.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/15/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit

class TaskListViewController: UITableViewController {
  var currentTasks = [Task]()
  var completedTasks = [Task]()
  
  func tasks(for indexPath: IndexPath) -> [Task] {
    return (indexPath.section == 0 ? currentTasks : completedTasks)
  }
  
  func task(for indexPath: IndexPath) -> Task {
    return tasks(for: indexPath)[indexPath.row]
  }
  
  func deleteRow(at indexPath: IndexPath) {
    var tasks = self.tasks(for: indexPath)
    tasks.remove(at: indexPath.row)
    
    if indexPath.section == 0 {
      currentTasks = tasks
    } else {
      completedTasks = tasks
    }
    
    tableView.deleteRows(at: [indexPath], with: .left)
  }
  
  func insertRow(at indexPath: IndexPath, task: Task) {
    var tasks = self.tasks(for: indexPath)
    tasks.append(task)
    
    if indexPath.section == 0 {
      currentTasks = tasks
    } else {
      completedTasks = tasks
    }
    
    tableView.insertRows(at: [indexPath], with: .right)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    CoreDataStore.sharedInstance.fetch { (tasks: [Task]) in
      self.currentTasks = tasks.filter{ !$0.completed }
      self.completedTasks = tasks.filter{ $0.completed }
      
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
}


// MARK: - UITableViewDataSource
extension TaskListViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return ["Current", "Completed"][section]
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return [currentTasks.count, completedTasks.count][section]
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TaskListCell.identifier, for: indexPath) as! TaskListCell
    cell.categoriesView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? TaskListCell else { return }
    let task = self.task(for: indexPath)
    
    cell.titleText = task.title
    cell.title.text = task.title
    cell.setSelected(task.completed, animated: true)
  }
}


// MARK: - UITableViewDelegate
extension TaskListViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let task = self.task(for: indexPath)
    task.completed = !task.completed
    
    tableView.performBatchUpdates({
      let atSection = abs(indexPath.section - 1)
      let atIndexPath = IndexPath(row: 0, section: atSection)
      self.deleteRow(at: indexPath)
      self.insertRow(at: atIndexPath, task: task)
    })
    
    CoreDataStore.sharedInstance.save()
  }
}
