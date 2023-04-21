//
//  CacheBar.swift
//  iHW-WatchOS Watch App
//
//  Created by Zachary Abrahamson  on 2/28/23.
//

import SwiftUI
import UserNotifications


extension Array {
    func pprint() {
        for i in self {
            print(i)
        }
    }
}



enum SGConvenience{
    #if os(watchOS)
    static var deviceWidth: CGFloat = WKInterfaceDevice.current().screenBounds.size.width
    
    #elseif os(iOS)
    static var deviceWidth: CGFloat = UIScreen.main.bounds.size.width
    #elseif os(macOS)
    static var deviceWidth: CGFloat? = NSScreen.main?.visibleFrame.size.width // You could implement this to force a CGFloat and get the full device screen size width regardless of the window size with .frame.size.width
    #endif
}

class NotificationManager {
    static let instance = NotificationManager()
    func requestAuth() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("Notification Error: \(error.localizedDescription)")
            } else {
                print("Notification success!")
            }
        }
    }
    

    
    func scheduleMSNotif(inSeconds: TimeInterval, nextPers: String, UST_MSF: Bool, nextClassName: String) {
        let content = UNMutableNotificationContent()
        
        if nextClassName == "Free" {
            if UST_MSF {
                if nextPers == "school ends" {
                    content.title = "School has ended"
                    content.body = "Have a great day!"
                } else {
                    
                    content.title = "\(nextPers) has begun"
                    content.body = "Have fun!"
                }
            } else {
                if nextPers == "school ends" {
                    content.title = "School has ended"
                    content.body = "Have a great day!"
                } else {
                    content.title = "Passing period has begun"
                    content.body = "Five minutes until \(nextPers)"
                }
            }
        } else {
            if UST_MSF {
                if nextPers == "school ends" {
                    content.title = "School has ended"
                    content.body = "Have a great day!"
                } else {
                    content.title = "\(nextPers), \(nextClassName), has begun"
                    content.body = "Have fun!"
                }
            } else {
                if nextPers == "school ends" {
                    content.title = "School has ended"
                    content.body = "Have a great day!"
                } else {
                    content.title = "Passing period has begun"
                    content.body = "Five minutes until \(nextClassName), \(nextPers)"
                }
                
            }
        }
        content.sound = .default
        content.badge = 1
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        print("notif sent")
    }
    
    func clearNotifs() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
