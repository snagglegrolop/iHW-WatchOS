//
//  iHW_WatchOSApp.swift
//  iHW-WatchOS Watch App
//
//  Created by Zachary Abrahamson  on 1/3/23.
//

import SwiftUI




@main struct iHW_WatchOS_Watch_AppApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var xmlinfo = XMLInfo()
    @StateObject var usinfo = USINfo()
    var body: some Scene {
        WindowGroup {
            Homepage()
                .environmentObject(xmlinfo)
                .environmentObject(usinfo)
                .onChange(of: xmlinfo.MScounter) { z in
                    print(z)
                    
                }

                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        print("Active")
                    } else if newPhase == .inactive {
                        print("Inactive")
                    } else if newPhase == .background {
                        print("Background")
                        xmlinfo.resetToInit()
                        usinfo.resetToInit()
                        print("Resetted because background")
                         
                    }
                }
            
        }
    }
}



struct iHW_WatchOSApp_Previews: PreviewProvider {
        static var previews: some View {
            Homepage()
        }
    }
