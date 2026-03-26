//
//  NotificationManager.swift
//  DailyBalance
//
//  Created by Ejimofor I J (FCES) on 24/03/2026.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Hydration Reminder 💧"
        content.body = "Don't forget to drink water and log your meals!"
        content.sound = .default
        
        var date = DateComponents()
        date.hour = 18 // 6 PM daily
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
