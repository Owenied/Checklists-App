//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Owen Duignan on 13/04/2017.
//  Copyright © 2017 Owen Duignan. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, NSCoding {
    
    // Variables
    var text = ""
    var checked = false
    
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        super.init()
    }
    
    // Checkmark on / off
    func toggleChecked() {
        checked = !checked
    }
    
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    // Save the data to a file
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemID, forKey: "ItemID")
    }
    
    // Method to schedule own notifications
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            
            // Put the item's text into the notification message
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            // Extract the month, day, hour and minute from the dueDate
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            
            // Trigger the notification
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            // Create the notification request object
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            // Add the new notification to the UNNotificationCenter
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Scheduled notification \(request) for itemID \(itemID))")
        }
    }
    
    // Method to remove a notification
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    // Deletion of a ChecklistItem
    deinit {
        removeNotification()
    }
    
}
































