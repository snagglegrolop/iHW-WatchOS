//
//  CacheBar.swift
//  iHW-WatchOS Watch App
//
//  Created by Zachary Abrahamson  on 2/28/23.
//

import SwiftUI


var secondaryColor: Color = Color(.white)



enum SGConvenience{
    #if os(watchOS)
    static var deviceWidth:CGFloat = WKInterfaceDevice.current().screenBounds.size.width
    #elseif os(iOS)
    static var deviceWidth:CGFloat = UIScreen.main.bounds.size.width
    #elseif os(macOS)
    static var deviceWidth:CGFloat? = NSScreen.main?.visibleFrame.size.width // You could implement this to force a CGFloat and get the full device screen size width regardless of the window size with .frame.size.width
    #endif
}


struct MyView: View {
    @State var count = 0
    @State var repeats = false
    @State var activity = false {
        didSet {
            if self.activity {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: repeats) { timer in
                    count += 1
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            List {
                Toggle("repeats?", isOn: $repeats)
                Toggle("active?", isOn: $activity)
                
                
                Text("\(count)")
            }
        }
    }
}
    


struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
    }
}
