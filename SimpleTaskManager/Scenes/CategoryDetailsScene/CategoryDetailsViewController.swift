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
  @IBOutlet weak var dialogCenterY: NSLayoutConstraint!
  
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
    name.delegate = self
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(tap)
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


// MARK - Keyboard Handling {
extension CategoryDetailsViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    hideKeyboard()
    return false
  }
  
  @objc func hideKeyboard() {
    view.endEditing(true)
  }
  
  @objc func handleKeyboardNotification(notification: NSNotification) {
    guard let userInfo = notification.userInfo else {
      return
    }
    
    guard let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
      return
    }
    
    let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
    UIView.animate(withDuration: 0.3) {
      let constant = -keyboardFrame.height + self.dialog.frame.height / 2
      self.dialogCenterY.constant = isKeyboardShowing ? constant : 0
      self.dialog.layoutIfNeeded()
    }
  }
}
