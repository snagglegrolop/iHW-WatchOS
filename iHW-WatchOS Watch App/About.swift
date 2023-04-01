//
//  SwiftUIView.swift
//  iHW-WatchOS Watch App
//
//  Created by Zachary Abrahamson  on 1/4/23.
//

import SwiftUI

import UserNotifications

struct testview: View {
    @ObservedObject var xmlinfo = XMLInfo()
   
    
    var body: some View {
        
        VStack {
            Button("Request Permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            }
            
            Button("Schedule Notification") {
                let content = UNMutableNotificationContent()
                let nextperiodNotif = "Next Period"
                content.title = "Five minutes until next period!"
                content.body = "\(nextperiodNotif) is in 5 minutes"
                
                content.sound = UNNotificationSound.default
                
                
               
                
                // show this notification five seconds from now
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)

                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                // add our notification request
                UNUserNotificationCenter.current().add(request)
                
                
                
            }
            
        }
    }
}


struct About: View {
    @State var fontsize: CGFloat = 20
    var body: some View {
        VStack {
            
            Form {
                Section {
                    
                    Text("App idea by Zachary, but code put into motion by Zachary Abrahamson '26, Andrew Jo '26, and Kazach '26")
                        .multilineTextAlignment(.center)
                        .font(.system(size: fontsize, weight: .light))
                }
                Section {
                    Text("iHW built from the ground up for Apple WatchOS")
                        .multilineTextAlignment(.center)
                        .font(.system(size: fontsize, weight: .light))
                }
                Section {
                    Text("Project started in January of 2022")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: fontsize, weight: .light))
                }
            }
        }
        .onAppear {
            if #unavailable(watchOS 9.0) {
                fontsize = 15
            }
        }
        
        
    }
}


struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
