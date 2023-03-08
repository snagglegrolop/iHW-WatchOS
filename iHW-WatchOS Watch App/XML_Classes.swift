//
//  XML_Classes.swift
//  iHW-WatchOS Watch App
//
//  Created by Zachary Abrahamson  on 3/7/23.
//

import Foundation
import Alamofire
import SWXMLHash
import SwiftUI


enum SGConvenience{
    #if os(watchOS)
    static var deviceWidth:CGFloat = WKInterfaceDevice.current().screenBounds.size.width
    #elseif os(iOS)
    static var deviceWidth:CGFloat = UIScreen.main.bounds.size.width
    #elseif os(macOS)
    static var deviceWidth:CGFloat? = NSScreen.main?.visibleFrame.size.width // forces a CGFloat and gets full device screen size width regardless of the window size with .frame.size.width
    #endif
}

@MainActor class XMLInfo: ObservableObject {
    @Published var DayDateLong = "Having trouble connecting to internet" {
        didSet {
            self.wifienable = false
        }
    }
    
    @Published var wifienable = true
    @Published var CycleDay = "2"
    @Published var DivisionDescription = "MS"
    @Published var SchoolDayDescription = "MS Day 2"
    @Published var selectedTab = "TodaySchoolDay"
    @Published var Finished = ""
    @Published var MScounter: Int = 0
    @Published var xmlDateMS = "11/15/2022"
    @Published var lessThanFiveMinTrue = false
    @Published var SchoolDidEndVar = false
    @Published var DayOfWeek = "Tuesday"
//    @AppStorage("lastRequestTime") var lastRequestTime: Double = 0
    @Published var CanMS_Nav = false
    
    
    
    @Published var StartTimeShort_Dict: [String: String] =
    [
        "Per1": "",
        "Per2": "",
        "Break": "",
        "Per3": "",
        "Per4": "",
        "Per5": "",
        "Per6": "",
        "Per7": "",
        "Per8": "",
        "Per9": ""
    ]
    
    @Published var EndTimeShort_Dict: [String: String] =
    [
        "Per1": "",
        "Per2": "",
        "Break": "",
        "Per3": "",
        "Per4": "",
        "Per5": "",
        "Per6": "",
        "Per7": "",
        "Per8": "",
        "Per9": ""
    ]
    
    @Published var StartTimeLong_Dict: [String: String] =
    [
        "Per1": "1/1/1900 8:00:00 AM",
        "Per2": "1/1/1900 8:45:00 AM",
        "Break": "1/1/1900 9:25:00 AM",
        "Per3": "1/1/1900 9:50:00 AM",
        "Per4": "1/1/1900 10:40:00 AM",
        "Per5": "1/1/1900 11:25:00 AM",
        "Per6": "1/1/1900 12:10:00 PM",
        "Per7": "1/1/1900 12:55:00 PM",
        "Per8": "1/1/1900 1:40:00 PM",
        "Per9": "1/1/1900 2:25:00 PM"
    ]
    
    @Published var EndTimeLong_Dict: [String: String] =
    [
        "Per1": "1/1/1900 8:40:00 AM",
        "Per2": "1/1/1900 9:25:00 AM",
        "Break": "1/1/1900 9:50:00 AM",
        "Per3": "1/1/1900 10:35:00 AM",
        "Per4": "1/1/1900 11:20:00 AM",
        "Per5": "1/1/1900 12:05:00 PM",
        "Per6": "1/1/1900 12:50:00 PM",
        "Per7": "1/1/1900 1:35:00 PM",
        "Per8": "1/1/1900 2:20:00 PM",
        "Per9": "1/1/1900 3:05:00 PM"
    ]
    
    
    
    func MSgetInfo(futuredays: Int) {
        let url = "https://www.hw.com/portals/0/reports/DailySchedulesMS.xml?t="
        let urlRequest = URLRequest(url: URL(string: url)!)
//        let currentTime = Date().timeIntervalSince1970
        let calendar = Calendar.current
        let mydate = DateFormatter()
        mydate.dateFormat = "yyyy/MM/dd, hh:mm:ss, a"
        
//        if lastRequestTime == 0 || !Calendar.current.isDate(Date(timeIntervalSince1970: lastRequestTime), inSameDayAs: Date()) {
//
//            URLCache.shared.removeAllCachedResponses()
//            //URLCache.shared.removeCachedResponse(for: urlRequest)
//            lastRequestTime = currentTime
//            print("IT IS A NEW DAY")
//
//
//
//
//        } else {
//            print("SAME DAY")
//        }
                
         AF.request(urlRequest)
                .responseString { response in
                    
                    
                    if let string = response.value {
//                        print("hey")
//                        print(" ")
                        
                        let xml = XMLHash.parse(string)
                        let FutureDays: Int = futuredays
                        self.xmlDateMS = (xml["Calendar"]["CalendarDay"][FutureDays]["Date"].element?.text)!
                        self.DayDateLong = (xml["Calendar"]["CalendarDay"][FutureDays]["DayDateLong"].element?.text)!
                        self.DayOfWeek = (xml["Calendar"]["CalendarDay"][FutureDays]["DayOfWeek"].element?.text)!
                        self.CycleDay = (xml["Calendar"]["CalendarDay"][FutureDays]["CycleDay"].element?.text)!
                        self.DivisionDescription = (xml["Calendar"]["CalendarDay"][FutureDays]["DivisionDescription"].element?.text)!
                        self.SchoolDayDescription = (xml["Calendar"]["CalendarDay"][FutureDays]["SchoolDayDescription"].element?.text)!
                        
                        
                        self.StartTimeShort_Dict["Per1"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][0]["StartTimeText"].element?.text)!
                        self.StartTimeShort_Dict["Per2"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][1]["StartTimeText"].element?.text)!
                    self.StartTimeShort_Dict["Break"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][2]["StartTimeText"].element?.text)!
                        self.StartTimeShort_Dict["Per3"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][3]["StartTimeText"].element?.text)!
                        self.StartTimeShort_Dict["Per4"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][4]["StartTimeText"].element?.text)!
                        self.StartTimeShort_Dict["Per5"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][5]["StartTimeText"].element?.text)!
                        self.StartTimeShort_Dict["Per6"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][6]["StartTimeText"].element?.text)!
                        self.StartTimeShort_Dict["Per7"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][7]["StartTimeText"].element?.text)!
                        self.StartTimeShort_Dict["Per8"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][8]["StartTimeText"].element?.text)!
                        self.StartTimeShort_Dict["Per9"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][9]["StartTimeText"].element?.text)!

                        
                        self.StartTimeLong_Dict["Per1"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][0]["StartTime"].element?.text)!
                        self.StartTimeLong_Dict["Per2"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][1]["StartTime"].element?.text)!
                    self.StartTimeLong_Dict["Break"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][2]["StartTime"].element?.text)!
                        self.StartTimeLong_Dict["Per3"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][3]["StartTime"].element?.text)!
                        self.StartTimeLong_Dict["Per4"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][4]["StartTime"].element?.text)!
                        self.StartTimeLong_Dict["Per5"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][5]["StartTime"].element?.text)!
                        self.StartTimeLong_Dict["Per6"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][6]["StartTime"].element?.text)!
                        self.StartTimeLong_Dict["Per7"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][7]["StartTime"].element?.text)!
                        self.StartTimeLong_Dict["Per8"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][8]["StartTime"].element?.text)!
                        self.StartTimeLong_Dict["Per9"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][9]["StartTime"].element?.text)!

                        
                        self.EndTimeShort_Dict["Per1"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][0]["EndTimeText"].element?.text)!
                        self.EndTimeShort_Dict["Per2"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][1]["EndTimeText"].element?.text)!
                    self.EndTimeShort_Dict["Break"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][2]["EndTimeText"].element?.text)!
                        self.EndTimeShort_Dict["Per3"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][3]["EndTimeText"].element?.text)!
                        self.EndTimeShort_Dict["Per4"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][4]["EndTimeText"].element?.text)!
                        self.EndTimeShort_Dict["Per5"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][5]["EndTimeText"].element?.text)!
                        self.EndTimeShort_Dict["Per6"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][6]["EndTimeText"].element?.text)!
                        self.EndTimeShort_Dict["Per7"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][7]["EndTimeText"].element?.text)!
                        self.EndTimeShort_Dict["Per8"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][8]["EndTimeText"].element?.text)!
                        self.EndTimeShort_Dict["Per9"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][9]["EndTimeText"].element?.text)!

                        
                        self.EndTimeLong_Dict["Per1"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][0]["EndTime"].element?.text)!
                        self.EndTimeLong_Dict["Per2"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][1]["EndTime"].element?.text)!
                    self.EndTimeLong_Dict["Break"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][2]["EndTime"].element?.text)!
                        self.EndTimeLong_Dict["Per3"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][3]["EndTime"].element?.text)!
                        self.EndTimeLong_Dict["Per4"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][4]["EndTime"].element?.text)!
                        self.EndTimeLong_Dict["Per5"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][5]["EndTime"].element?.text)!
                        self.EndTimeLong_Dict["Per6"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][6]["EndTime"].element?.text)!
                        self.EndTimeLong_Dict["Per7"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][7]["EndTime"].element?.text)!
                        self.EndTimeLong_Dict["Per8"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][8]["EndTime"].element?.text)!
                        self.EndTimeLong_Dict["Per9"] = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][9]["StartTime"].element?.text)!
                        
                        
                        print("""


                        Start Time Short: \(self.StartTimeShort_Dict)

                        Start Time Long: \(self.StartTimeLong_Dict)

                        End Time Short: \(self.EndTimeShort_Dict)

                        End Time Long: \(self.EndTimeLong_Dict)
                                                    

                        """)
                        
                        
                        
                        
                        
//                        print("It is \(self.DayDateLong), but it is a \(self.DivisionDescription) day \(self.CycleDay)")
//                        print(type(of: self.DayDateLong))
//                        print("Period 1 starts at \(self.Per1_StartTime)")
                        
                        if !calendar.isDateInToday(mydate.date(from: self.Finished) ?? Date()) {
                            print("ITS A NEW DAY BUT OTHER NEW DAY THING IS BEING BROKEN")
                            URLCache.shared.removeAllCachedResponses()
                            self.MSgetInfo(futuredays: self.MScounter)
                        } else {
                            print("its fr not a new day and not going to mention the semi debugger thing")
                        }
                        
                        
                            
                        
                        
                        
                    }
                }
        }
        
    
    @Published var isHoliday = false
    // TU means Time Until
    @Published var TimeUntil_FiveMinute_Notif: [String: Double] =
    [
        
        "First": -20,
        "Second": -19,
        "Break": -18,
        "Third": -17,
        "Fourth": -16,
        "Fifth": -15,
        "Sixth": -14,
        "Seventh": -13,
        "Eigth": -12,
        "Ninth": -11,
        
        
    
    ]
    
    @Published var Popup_PoppedUp = false
    func tabLoad() {
        if self.isHoliday == true {
            self.selectedTab = "Holiday"
        }
        
        else if Date().dayOfWeek()! == "Saturday" || Date().dayOfWeek()! == "Sunday" {
            self.selectedTab = "Weekend"
        } else {
            self.selectedTab = "TodaySchoolDay"
        }
    }
    
}

