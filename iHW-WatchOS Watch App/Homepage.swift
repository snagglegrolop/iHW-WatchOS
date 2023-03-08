//
//  Homepage.swift
//  iHW-WatchOS Watch App
//
//  Created by Zachary Abrahamson  on 1/3/23.
//

import SwiftUI
import UserNotifications
import Alamofire
import Foundation

func RelativeWidth(CurrentWidth: CGFloat) -> CGFloat {
    
    let stepone = SGConvenience.deviceWidth / CurrentWidth
    return SGConvenience.deviceWidth / stepone
}

struct HomeGrownButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: RelativeWidth(CurrentWidth: 100), height: RelativeWidth(CurrentWidth: 40))
            .background(.red)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeInOut(duration: 0.4), value: configuration.isPressed)
            .font(.system(size: 20, weight: .bold))
            
            

        
    }
}




struct Homepage: View {

    var body: some View {
        
        NavigationView {

            ZStack {
                    VStack(spacing: 30) {
                        NavigationLink(destination: Sign_In()) {
                            Text("Sign In")
                        }
                        .buttonStyle(HomeGrownButton())
                        
                        NavigationLink(destination: About()) {
                            Text("About")
                        }
                        .buttonStyle(HomeGrownButton())
                    }
            }
            .onAppear {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
                    if success {
                        print("Permission granted")
                        
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
                URLCache.shared.removeAllCachedResponses()
  
            }
            
        }
        

        
    }
        
        
}


struct Homepage_Previews: PreviewProvider {
        static var previews: some View {
            Homepage()
        }
    }


