//
//  CategoryDetailsViewController.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/18/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit

class CategoryDetailsViewController: UIViewController {
  var category: Category!
  var dismissBlock: (() -> Void)!
  let colorPickerData = [
    UIColor(named: "MainDark"),
    UIColor(named: "Orange"),
    UIColor(named: "Pink"),
    UIColor(named: "Red"),
    UIColor(named: "Sand")
  ]
  
  @IBOutlet weak var dialog: UIView!
  @IBOutlet weak var name: UITextField!
  @IBOutlet weak var colorPicker: UIPickerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if category == nil {
      let newCategory: Category = CoreDataStore.sharedInstance.create()
      category = newCategory
    } else {
      name.text = category.name
    }
    
    colorPicker.delegate = self
    colorPicker.dataSource = self
  }
}


// MARK - UIPickerViewDelegate
extension CategoryDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return colorPickerData.count
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    let view = UIView()
    view.backgroundColor = colorPickerData[row]
    return view
  }
}


// MARK: - Actions
extension CategoryDetailsViewController {
  @IBAction func onSaveButtonPressed() {
    guard let name = name.text, name.count > 0 else {
      dialog.startShakeAnimation()
      return
    }
    
    category.name = name
    let row = colorPicker.selectedRow(inComponent: 0)
    category.color = colorPickerData[row]
    
    CoreDataStore.sharedInstance.save() {_ in
      self.dismiss(animated: true, completion: self.dismissBlock)
    }
  }
}
