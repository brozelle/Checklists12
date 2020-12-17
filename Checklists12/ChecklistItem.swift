//
//  ChecklistItem.swift
//  Checklists12
//
//  Created by Buck Rozelle on 12/8/20.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    //Sets up the unique notification ID.
    override init() {
      super.init()
      itemID = DataModel.nextChecklistItemID()
    }
    
    deinit{
        removeNotification()
    }
    
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            //Puts the item's text into the notification message.
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default
            //Extracts the date info
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
            //Test the local notifcations
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            //Creates the notification object
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            //adds the new notification to the notification center
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("We should schedule a notification!")
        }
    }
    
    func removeNotification() {
      let center = UNUserNotificationCenter.current()
      center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
}


