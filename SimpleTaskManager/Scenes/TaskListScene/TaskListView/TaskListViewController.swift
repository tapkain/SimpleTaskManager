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
  
  func deleteRow(at indexPath: IndexPath, fromStore: Bool = false) {
    var tasks = self.tasks(for: indexPath)
    let deletedTask = tasks.remove(at: indexPath.row)
    
    if fromStore {
      CoreDataStore.sharedInstance.delete(deletedTask)
    }
    
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    CoreDataStore.sharedInstance.fetch(Task.fetchRequest()) { tasks in
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
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    var height: CGFloat = 55
    let padding: CGFloat = 5
    
    var rowWidth: CGFloat = 0
    let categories = task(for: indexPath).categoriesList
    for category in categories {
      let size = Styles.size(of: category.name!, font: Styles.categoryFont)
      rowWidth += size.width + padding * 3
      if rowWidth >= tableView.frame.width * 0.55 {
        rowWidth = 0
        height += size.height * 2
      }
    }
    
    if rowWidth > 0 {
      height += Styles.size(of: "", font: Styles.categoryFont).height * 2
    }
    
    height += padding
    return height
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: TaskListCell.identifier, for: indexPath)
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? TaskListCell else { return }
    let task = self.task(for: indexPath)
    
    cell.titleText = task.title
    cell.title.text = task.title
    cell.dueDate.text = Styles.dateFormatter.string(from: task.dueDate!)
    cell.categories = task.categoriesList
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
      let lastRow = indexPath.section == 0 ? completedTasks.count : currentTasks.count
      let atIndexPath = IndexPath(row: lastRow, section: atSection)
      self.deleteRow(at: indexPath)
      self.insertRow(at: atIndexPath, task: task)
    })
    
    CoreDataStore.sharedInstance.save()
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      deleteRow(at: indexPath, fromStore: true)
    }
  }
}


// MARK: - Navigation
extension TaskListViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "editSegue" {
      if let taskDetails = segue.destination as? TaskDetailsViewController,
         let cell = sender as? TaskListCell,
         let indexPath = tableView.indexPath(for: cell) {
        taskDetails.task = task(for: indexPath)
      }
    }
  }
}
