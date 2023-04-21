//
//  SwiftUIView.swift
//  iHW-WatchOS Watch App
//
//  Created by Zachary Abrahamson  on 1/4/23.
//

import SwiftUI


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
                fontsize = 13
            }
        }
        
        
    }
}


struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
