//
//  Schedule.swift
//  iHW-WatchOS Watch App
//
//  Created by Zachary Abrahamson  on 1/7/23.
//

import SwiftUI
import Alamofire
import SWXMLHash
import UserNotifications

struct GrowingButton2: ButtonStyle {
    @ObservedObject var xmlinfo: XMLInfo
    @State var BkgColor: Color = .gray
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        
            .frame(height: 70)
            .padding()
            .background(xmlinfo.CanMS_Nav ? .red : .gray)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .scaleEffect(configuration.isPressed ? 1.0 : 0.8)
            .animation(.easeInOut(duration: 0.4), value: configuration.isPressed)
        
        
    }
}



struct USMSSelect: View {
    @ObservedObject var xmlinfo = XMLInfo()
    @State public var MiddleNav : Bool = false
    @State public var UpperNav : Bool = false
    
    
    var body: some View {
        if #available(watchOS 9.0, *) {
            NavigationStack {
                ZStack {
                    PeriodUntilTextFinished(xmlinfo: xmlinfo, onScreen: false)
                    Rectangle()
                        .fill(Color.black)

                        .frame(width: SGConvenience.deviceWidth, height: SGConvenience.deviceWidth)
                    VStack(spacing: 10){
                        Text(" ")
                            .font(.system(size: 10))
                        Button {
                            if xmlinfo.CanMS_Nav {
                                UpperNav = true
                            }
                        } label: {
                            Text("  Upper School Schedule  ")
                                .multilineTextAlignment(.center)
                            
                                .foregroundColor(.white)
                                .font(.system(size: 26, weight: .bold))
                            
                            
                        }
                        .buttonStyle(GrowingButton2(xmlinfo: xmlinfo))
                        
                        if xmlinfo.Popup_PoppedUp{
                            Spacer()
                                .frame(height: SGConvenience.deviceWidth / 2)
                            
                                Text("Notifications have been set for today.")
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .font(.system(size: CGFloat(15), weight: .semibold))
                                .foregroundColor(.red)
                                .transition(.moveAndScale)
                                
                                Text("Remember not to rely on notifications as they may come late.")
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .font(.footnote)
                                .transition(.moveAndScale)
                                .onAppear {
                                        WKInterfaceDevice.current().play(.notification)
                                    }
                            
                            
                            Spacer()
                                .frame(height: SGConvenience.deviceWidth / 2)

                        }
                        
                        Button {
                            if xmlinfo.CanMS_Nav {
                                xmlinfo.MSgetInfo(futuredays: 0)
                                xmlinfo.tabLoad()
                                MiddleNav = true
                            }
                            print(xmlinfo.CanMS_Nav)
                            print(xmlinfo.CycleDay)
                        } label: {
                            
                            Text("Middle School Schedule")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .font(.system(size: 25.5, weight: .bold))
                            
                            
                        }
                        .buttonStyle(GrowingButton2(xmlinfo: xmlinfo))
                        
                    }
                    
                    .navigationDestination(isPresented: $MiddleNav) {
                        MiddleSchoolSchedule(xmlinfo: xmlinfo)
                        
                    }
                    

                }
            }
        } else {
            
            NavigationView {
                ZStack {
                    PeriodUntilTextFinished(xmlinfo: xmlinfo, onScreen: false)
                        .zIndex(0)
                    Rectangle()
                        .fill(Color.black)
                        .zIndex(1)
                    VStack(spacing: 10){
                        
                        
                        NavigationLink("Upper School Schedule",
                                       destination: UpperSchoolSchedule()
                        )
                        
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .disabled(!xmlinfo.CanMS_Nav)
                        
                        
                        
                        
                        .buttonStyle(GrowingButton2(xmlinfo: xmlinfo))
                        if xmlinfo.Popup_PoppedUp{
                            Spacer()
                                .frame(height: SGConvenience.deviceWidth / 2)
                            
                                Text("Notifications have been set for today.")
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .font(.system(size: CGFloat(15), weight: .semibold))
                                .foregroundColor(.red)
                                .transition(.moveAndScale)
                                Text("Remember not to rely on notifications as they may come late.")
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .font(.footnote)
                                .transition(.moveAndScale)
                                .onAppear {
                                        WKInterfaceDevice.current().play(.notification)
                                    }
                            
                            
                            Spacer()
                                .frame(height: SGConvenience.deviceWidth / 2)

                        }
                        
                        
                        NavigationLink(
                            "Middle School Schedule",
                            destination: MSSView()
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .disabled(!xmlinfo.CanMS_Nav)
                        
                        
                        
                        
                        .buttonStyle(GrowingButton2(xmlinfo: xmlinfo))
                    }
                    .zIndex(2)
                }
                
            }
            
        }
        
    }
    
}

extension AnyTransition {
    static var moveAndScale: AnyTransition {
        AnyTransition.move(edge: .bottom).combined(with: .scale)
    }
}
                                            
struct Schedule_Previews: PreviewProvider {
    static var previews: some View {
        USMSSelect()
    }
}
