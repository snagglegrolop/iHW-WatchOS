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
    @State private var isSideBarOpened = false

    @ObservedObject var usinfo: USINfo
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
                URLCache.shared.removeAllCachedResponses()

                NotificationManager.instance.requestAuth()
                
                print(#line)
                usinfo.USgetInfo(futuredays: 0) { success, error in
                    print(#line)
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    print(#line)
                    if success {
                        // Do something with the parsed XML data
                        print("XML data parsed successfully!")
                    } else {
                        print("Failed to parse XML data.")
                    }
                    print(#line)
                }
                
  
            }
            
        }
        

        
    }
        
        
}


struct Homepage_Previews: PreviewProvider {
        static var previews: some View {
            Homepage(usinfo: USINfo())
        }
    }


