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
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 70)
            .padding()
            .background(.red)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .scaleEffect(configuration.isPressed ? 1.0 : 0.8)
            .animation(.easeInOut(duration: 0.4), value: configuration.isPressed)
        
        
    }
}

class USINfo: ObservableObject {
    @Published var isSentforWifi = false
    @Published var DayDateLong = "Having trouble connecting to internet"
    @Published var CycleDay = ""
    @Published var DivisionDescription = ""
    @Published var SchoolDayDescription = ""
    
    @Published var lessThanFiveMinTrue = false
    @Published var SchoolDidEndVar = false

    @Published var Finished = ""
    
    @Published var USCounter: Int = 0
    @Published var periodNames: [String] = []
    @Published var startTimesShort: [String] = []
    @Published var endTimesShort: [String] = []
    
    @Published var startTimesLong: [String] = []
    @Published var endTimesLong: [String] = []

    @Published var schoolEndDay: [String] = []
    
    
    func USgetInfo(futuredays: Int, completion: @escaping (Bool, Error?) -> Void) {
        let url = "https://www.hw.com/portals/0/reports/DailySchedulesUS.xml?t="
        let urlRequest = URLRequest(url: URL(string: url)!)
        URLCache.shared.removeCachedResponse(for: urlRequest)
        print(#line)
        AF.request(urlRequest)
            .responseString { response in
                if let error = response.error {
                    completion(false, error)
                    return
                }
                print(#line)
                if let string = response.value {
                    self.isSentforWifi = true
                    let xml = XMLHash.parse(string)
                    let FutureDays: Int = futuredays
                    
                    self.DayDateLong = (xml["Calendar"]["CalendarDay"][FutureDays]["DayDateLong"].element?.text)!
                    
                    self.CycleDay = (xml["Calendar"]["CalendarDay"][FutureDays]["CycleDay"].element?.text)!
                    self.SchoolDayDescription = (xml["Calendar"]["CalendarDay"][FutureDays]["SchoolDayDescription"].element?.text)!
                    
                    self.schoolEndDay = []
                    self.periodNames = []
                    self.startTimesShort = []
                    self.endTimesShort = []
                    self.startTimesLong = []
                    self.endTimesLong = []
                    
                    
                    for elem in xml["Calendar"]["CalendarDay"].all {
                        self.schoolEndDay.append(elem["DayDateLong"].element!.text)
                    }
                    
                    self.schoolEndDay = [self.schoolEndDay.last!]
                    
                    for elem in xml["Calendar"]["CalendarDay"][FutureDays]["Period"].all {
                        self.periodNames.append(elem["PeriodDescription"].element!.text)
                        self.startTimesShort.append(elem["StartTimeText"].element!.text)
                        self.endTimesShort.append(elem["EndTimeText"].element!.text)
                        self.startTimesLong.append(elem["StartTime"].element!.text)
                        self.endTimesLong.append(elem["EndTime"].element!.text)
                    }
                    self.periodNames.append("school ends")
                    print()
                    print(#line)
                    
                    for i in 0..<self.startTimesShort.count {
                        print(#line)
                        print("\(self.periodNames[i]) is from \(self.startTimesShort[i]) to \(self.endTimesShort[i])!")
                    }
                    print(#line)
                    print()
                    completion(true, nil)

                }
            }
    

    }
}

class XMLInfo: ObservableObject {
    @Published var isSentforWifi = false
    
    @Published var DayDateLong = "Having trouble connecting to internet"
    @Published var CycleDay = ""
    @Published var DivisionDescription = ""
    @Published var SchoolDayDescription = ""
    @Published var Per1_Per = ""
    @Published var Per2_Per = ""
    @Published var Break_Per = ""
    @Published var Per3_Per = ""
    @Published var Per4_Per = ""
    @Published var Per5_Per = ""
    @Published var Per6_Per = ""
    @Published var Per7_Per = ""
    @Published var Per8_Per = ""
    @Published var Per9_Per = ""
    @Published var Per1_StartTime = ""
    @Published var Per1_EndTime = ""
    @Published var Per2_StartTime = ""
    @Published var Per2_EndTime = ""
    @Published var Break_StartTime = ""
    @Published var Break_EndTime = ""
    @Published var Per3_StartTime = ""
    @Published var Per3_EndTime = ""
    @Published var Per4_StartTime = ""
    @Published var Per4_EndTime = ""
    @Published var Per5_StartTime = ""
    @Published var Per5_EndTime = ""
    @Published var Per6_StartTime = ""
    @Published var Per6_EndTime = ""
    @Published var Per7_StartTime = ""
    @Published var Per7_EndTime = ""
    @Published var Per8_StartTime = ""
    @Published var Per8_EndTime = ""
    @Published var Per9_StartTime = ""
    @Published var Per9_EndTime = ""
    @Published var selectedTab = "TodaySchoolDay"
    
    
    
    @Published var Finished = ""
    
    @Published var Per1_StartTimeLong = "1/1/1900 8:00:00 AM"
    @Published var Per1_EndTimeLong = "1/1/1900 8:40:00 AM"
    @Published var Per2_StartTimeLong = "1/1/1900 8:45:00 AM"
    @Published var Per2_EndTimeLong = "1/1/1900 9:25:00 AM"
    @Published var Break_StartTimeLong = "1/1/1900 9:25:00 AM"
    @Published var Break_EndTimeLong = "1/1/1900 9:50:00 AM"
    @Published var Per3_StartTimeLong = "1/1/1900 9:55:00 AM"
    @Published var Per3_EndTimeLong = "1/1/1900 10:35:00 AM"
    @Published var Per4_StartTimeLong = "1/1/1900 10:40:00 AM"
    @Published var Per4_EndTimeLong = "1/1/1900 11:20:00 AM"
    @Published var Per5_StartTimeLong = "1/1/1900 11:25:00 AM"
    @Published var Per5_EndTimeLong = "1/1/1900 12:05:00 PM"
    @Published var Per6_StartTimeLong = "1/1/1900 12:10:00 PM"
    @Published var Per6_EndTimeLong = "1/1/1900 12:50:00 PM"
    @Published var Per7_StartTimeLong = "1/1/1900 12:55:00 PM"
    @Published var Per7_EndTimeLong = "1/1/1900 1:35:00 PM"
    @Published var Per8_StartTimeLong = "1/1/1900 1:40:00 PM"
    @Published var Per8_EndTimeLong = "1/1/1900 2:20:00 PM"
    @Published var Per9_StartTimeLong = "1/1/1900 2:25:00 PM"
    @Published var Per9_EndTimeLong = "1/1/1900 3:05:00 PM"
    @Published var MScounter: Int = 0
    @Published var lessThanFiveMinTrue = false
    @Published var SchoolDidEndVar = false
    @Published var DayOfWeek = "Tuesday"
    
    @Published var dsf: [String] = []
    
    @Published var dsn: [String] = []
    
    @Published var dst: [String] = []
    
    
    
    func MSgetInfo(futuredays: Int, completion: @escaping (Bool, Error?) -> Void) {
        let url = "https://www.hw.com/portals/0/reports/DailySchedulesMS.xml?t="
        let urlRequest = URLRequest(url: URL(string: url)!)
   
        URLCache.shared.removeCachedResponse(for: urlRequest)
        
        
        
        
    
    
    AF.request(urlRequest)
        .responseString { response in
            if let error = response.error {
                            completion(false, error)
                            return
                        }
            if let string = response.value {
                self.isSentforWifi = true
                let xml = XMLHash.parse(string)
                let FutureDays: Int = futuredays
                self.DayDateLong = (xml["Calendar"]["CalendarDay"][FutureDays]["DayDateLong"].element?.text)!
                self.DayOfWeek = (xml["Calendar"]["CalendarDay"][FutureDays]["DayOfWeek"].element?.text)!
                self.CycleDay = (xml["Calendar"]["CalendarDay"][FutureDays]["CycleDay"].element?.text)!
                self.DivisionDescription = (xml["Calendar"]["CalendarDay"][FutureDays]["DivisionDescription"].element?.text)!
                self.SchoolDayDescription = (xml["Calendar"]["CalendarDay"][FutureDays]["SchoolDayDescription"].element?.text)!
                self.Per1_StartTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][0]["StartTimeText"].element?.text)!
                self.Per1_EndTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][0]["EndTimeText"].element?.text)!
                self.Per2_StartTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][1]["StartTimeText"].element?.text)!
                self.Per2_EndTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][1]["EndTimeText"].element?.text)!
                self.Break_StartTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][2]["StartTimeText"].element?.text)!
                self.Break_EndTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][2]["EndTimeText"].element?.text)!
                self.Per3_StartTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][3]["StartTimeText"].element?.text)!
                self.Per3_EndTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][3]["EndTimeText"].element?.text)!
                self.Per4_StartTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][4]["StartTimeText"].element?.text)!
                self.Per4_EndTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][4]["EndTimeText"].element?.text)!
                self.Per5_StartTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][5]["StartTimeText"].element?.text)!
                self.Per5_EndTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][5]["EndTimeText"].element?.text)!
                self.Per6_StartTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][6]["StartTimeText"].element?.text)!
                self.Per6_EndTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][6]["EndTimeText"].element?.text)!
                self.Per7_StartTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][7]["StartTimeText"].element?.text)!
                self.Per7_EndTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][7]["EndTimeText"].element?.text)!
                self.Per8_StartTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][8]["StartTimeText"].element?.text)!
                self.Per8_EndTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][8]["EndTimeText"].element?.text)!
                self.Per9_StartTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][9]["StartTimeText"].element?.text)!
                self.Per9_EndTime = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][9]["EndTimeText"].element?.text)!
                self.Per1_StartTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][0]["StartTime"].element?.text)!
                self.Per1_EndTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][0]["EndTime"].element?.text)!
                self.Per2_StartTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][1]["StartTime"].element?.text)!
                self.Per2_EndTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][1]["EndTime"].element?.text)!
                self.Break_StartTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][2]["StartTime"].element?.text)!
                self.Break_EndTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][2]["EndTime"].element?.text)!
                self.Per3_StartTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][3]["StartTime"].element?.text)!
                self.Per3_EndTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][3]["EndTime"].element?.text)!
                self.Per4_StartTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][4]["StartTime"].element?.text)!
                self.Per4_EndTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][4]["EndTime"].element?.text)!
                self.Per5_StartTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][5]["StartTime"].element?.text)!
                self.Per5_EndTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][5]["EndTime"].element?.text)!
                self.Per6_StartTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][6]["StartTime"].element?.text)!
                self.Per6_EndTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][6]["EndTime"].element?.text)!
                self.Per7_StartTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][7]["StartTime"].element?.text)!
                self.Per7_EndTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][7]["EndTime"].element?.text)!
                self.Per8_StartTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][8]["StartTime"].element?.text)!
                self.Per8_EndTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][8]["EndTime"].element?.text)!
                self.Per9_StartTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][9]["StartTime"].element?.text)!
                self.Per9_EndTimeLong = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][9]["EndTime"].element?.text)!
                
                self.Per1_Per = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][0]["PeriodDescription"].element?.text)!
                self.Per2_Per = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][1]["PeriodDescription"].element?.text)!
                self.Break_Per = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][2]["PeriodDescription"].element?.text)!
                self.Per3_Per = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][3]["PeriodDescription"].element?.text)!
                self.Per4_Per = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][4]["PeriodDescription"].element?.text)!
                self.Per5_Per = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][5]["PeriodDescription"].element?.text)!
                self.Per6_Per = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][6]["PeriodDescription"].element?.text)!
                self.Per7_Per = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][7]["PeriodDescription"].element?.text)!
                self.Per8_Per = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][8]["PeriodDescription"].element?.text)!
                self.Per9_Per = (xml["Calendar"]["CalendarDay"][FutureDays]["Period"][9]["PeriodDescription"].element?.text)!

                
                
                //                        print("It is \(self.DayDateLong), but it is a \(self.DivisionDescription) day \(self.CycleDay)")
                //                        print(type(of: self.DayDateLong))
                //                        print("Period 1 starts at \(self.Per1_StartTime)")
                                completion(true, nil)
                            
                self.dsf = [self.Per1_Per, self.Per2_Per, self.Break_Per, self.Per3_Per, self.Per4_Per, self.Per5_Per, self.Per6_Per, self.Per7_Per, self.Per8_Per, self.Per9_Per, "school ends"]
                
                self.dsn = [self.Per1_StartTime, self.Per2_StartTime, self.Break_StartTime, self.Per3_StartTime, self.Per4_StartTime, self.Per5_StartTime, self.Per6_StartTime, self.Per7_StartTime, self.Per8_StartTime, self.Per9_StartTime]
                self.dst = [self.Per1_EndTime, self.Per2_EndTime, self.Break_EndTime, self.Per3_EndTime, self.Per4_EndTime, self.Per5_EndTime, self.Per6_EndTime, self.Per7_EndTime, self.Per8_EndTime, self.Per9_EndTime]
                
                
                
            }
        }
}
    
    
    
    
    
}


struct USMSSelect: View {
    @State public var MiddleNav : Bool = false
    @State public var UpperNav : Bool = false
    @State var ButtonLook = GrowingButton2()
    @StateObject var xmlinfo = XMLInfo()
    @StateObject var usinfo = USINfo()
    
    
    var body: some View {
        if #available(watchOS 9.0, *) {
            VStack(spacing: 10){
                
                NavigationLink("Upper School Schedule", destination: UpperSchoolSchedule(usinfo: usinfo))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .font(.system(size: 25.5, weight: .bold))
                        .buttonStyle(ButtonLook)
                
                
                NavigationLink("Middle School Schedule", destination: MiddleSchoolSchedule(xmlinfo: xmlinfo))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .font(.system(size: 25.5, weight: .bold))
                        .buttonStyle(ButtonLook)
                
            }
        } else {
            
            NavigationView {
                VStack(spacing: 10){
                    
                    
                        NavigationLink("Upper School Schedule",
                           destination: UpperSchoolSchedule(usinfo: usinfo)
                        )
                            
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            
                            
                        
                        
                    
                    .buttonStyle(ButtonLook)
                    
                    
                        
                        NavigationLink(
                            "Middle School Schedule",
                            destination: MSSView()
                        )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            
                            
                        
                        
                    
                    .buttonStyle(ButtonLook)
                }
                
            }
            
        }
        
    }
    
}

struct Schedule_Previews: PreviewProvider {
    static var previews: some View {
        USMSSelect()
    }
}
