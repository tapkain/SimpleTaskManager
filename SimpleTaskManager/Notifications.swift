//
//  Notifications.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/18/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UserNotifications

class Notifications: NSObject {
  static let sharedInstance = Notifications()
  private let center = UNUserNotificationCenter.current()
  
  override init() {
    super.init()
    center.delegate = self
  }
  
  func requestPermission() {
    let options: UNAuthorizationOptions = [.alert, .sound];
    center.requestAuthorization(options: options) {_,_  in
    }
  }
  
  func removeAllNotificationRequests() {
    center.removeAllPendingNotificationRequests()
    center.removeAllDeliveredNotifications()
  }
  
  func scheduleNotification(with task: Task) {
    let content = UNMutableNotificationContent()
    content.title = task.title!
    content.sound = UNNotificationSound.default()
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2,
                                                    repeats: false)
    
    //let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
    //let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
    //repeats: false)
    
    let identifier = "SimpleTaskManagerNotification"
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    center.add(request)
  }
}
  
  
// MARK: - UNUserNotificationCenterDelegate
extension Notifications: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}
