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
            .frame(width: RelativeWidth(CurrentWidth: 120), height: RelativeWidth(CurrentWidth: 50))
            .background(.red)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeInOut(duration: 0.4), value: configuration.isPressed)
            .font(.system(size: 23, weight: .bold))
            
            

        
    }
}




struct Homepage: View {
    
    var body: some View {
        
        VStack {
            
            if #available(watchOS 9.0, *) {
                NavigationStack {
                    
                    
                    
                    ZStack {
                        VStack(spacing: 30) {
                            // making this into usmsselect because i honestly dont need sign in rn
                            NavigationLink(destination: USMSSelect()) {
                                Text("Schedule")
                            }
                            .buttonStyle(HomeGrownButton())
                            .padding(.bottom, 10.0)
                            
                            NavigationLink(destination: About()) {
                                Text("About")
                            }
                            .buttonStyle(HomeGrownButton())
                            .padding(.bottom, 10.0)
                            
                            
                        }
                        
                        
                        
                    }
                    .onAppear {
                        NotificationManager.instance.requestAuth()
                        
                        
                        
                    }
                    
                    
                }
                
                
                
            } else {
                
                NavigationView {
                    
                    
                    
                    
                    
                    
                    VStack(spacing: 30) {
                        //                    VStack {
                        // making this into usmsselect because i honestly dont need sign in rn
                        
                        
                        NavigationLink(destination: USMSSelect()) {
                            Text("Schedule")
                        }
                        
                        .buttonStyle(HomeGrownButton())
                        
                        .padding(.bottom, 10.0)
                        NavigationLink(destination: About()) {
                            Text("About")
                            
                        }
                        .padding(.bottom, 10.0)
                        .buttonStyle(HomeGrownButton())
                        
                        
                        
                        
                        
                        
                        
                    }
                    .onAppear {
                        NotificationManager.instance.requestAuth()
                        
                        
                        
                    }
                    
                    
                }
                .navigationViewStyle(StackNavigationViewStyle())
                
            }
            
        }
        .onAppear() {
            if let dtOutMS = UserDefaults.standard.string(forKey: "LastMSGet"), let dtOutUS = UserDefaults.standard.string(forKey: "LastUSGet") {
            print(dtOutMS, "and", dtOutUS, "are the last requested dates of getting info for MS and US respectively.")
            } else {
                print("no saved info")
            }
        }
    }
        
        
}


struct Homepage_Previews: PreviewProvider {
    
        static var previews: some View {
            Homepage().environmentObject(USINfo()).environmentObject(XMLInfo())
        }
    }


