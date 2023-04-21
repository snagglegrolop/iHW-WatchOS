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
import Foundation

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
    @Published var lookingDate = Date()
    
    @Published var isSentforWifi = false
    @Published var DayDateLong = "Having trouble connecting to internet"
    @Published var CycleDay = ""
    @Published var DivisionDescription = ""
    @Published var SchoolDayDescription = ""
    @Published var currentPeriod: String? = ""
    @Published var updatedXML = false
    
    @Published var lessThanFiveMinTrue = false
    @Published var SchoolDidEndVar = false

    @Published var Finished = ""
    
    @Published var ClassesDict: [String: String] {
        didSet {
            UserDefaults.standard.set(ClassesDict, forKey: "ClassesDictUS")
        }
    }

    init() {
        if let savedClassesDict = UserDefaults.standard.dictionary(forKey: "ClassesDictUS") as? [String: String] {
            self.ClassesDict = savedClassesDict
        } else {
            self.ClassesDict = ["Block 6": "Free", "Community Time/Junior Seminar": "Free", "Co-Curricular": "Free", "Block 2": "Free", "Block 7": "Free", "Directed Study": "Free", "Block 5": "Free", "Block 3": "Free", "Community Time/Sophomore Seminar": "Free", "Block 4": "Free", "Senior Seminar": "Free", "Block 1": "Free"]
        }
    }
    
    
    @Published var dayDateLongDately = Date()
    
    @Published var CalendarID: [String] = []
    
    @Published var LastMSReqTime = Date()
    
    
    @Published var USCounter: Int = 0
    @Published var periodNames: [String] = []
    @Published var startTimesShort: [String] = []
    @Published var endTimesShort: [String] = []
    
    @Published var startTimesLong: [String] = []
    @Published var endTimesLong: [String] = []
    @Published var allDayDateLongs: Set<String> = []
    @Published var schoolEndDay: [String] = []
    @Published var schoolEndDately = Date()
    @Published var timediftext = ""
    
    func resetToInit() {
        self.lookingDate = Date()
        self.isSentforWifi = false
        self.DayDateLong = "Having trouble connecting to internet"
        self.CycleDay = ""
        self.DivisionDescription = ""
        self.SchoolDayDescription = ""
        
        self.updatedXML = false
        
        self.lessThanFiveMinTrue = false
        self.SchoolDidEndVar = false

        self.Finished = ""
        
        self.dayDateLongDately = Date()
        
        self.CalendarID = []
        
        self.LastMSReqTime = Date()
        
        
        self.USCounter = 0
        self.periodNames = []
        self.startTimesShort = []
        self.endTimesShort = []
        
        self.startTimesLong = []
        self.endTimesLong = []
        self.allDayDateLongs = []
        self.schoolEndDay = []
        self.schoolEndDately = Date()
        self.timediftext = ""
    }
    
    func USgetInfo(futuredays: Int, completion: @escaping (Bool, Error?) -> Void) {
        let url = "https://www.hw.com/portals/0/reports/DailySchedulesUS.xml?t="
        let urlRequest = URLRequest(url: URL(string: url)!)
        if let dtOut = UserDefaults.standard.string(forKey: "LastUSGet") {
            if dtOut != UpperSchoolSchedule.thisFormatter.string(from: Date()) || !self.updatedXML {
                URLCache.shared.removeCachedResponse(for: urlRequest)
            }
        }
        AF.request(urlRequest)
            .responseString { response in
                if let error = response.error {
                    self.isSentforWifi = false
                    completion(false, error)
                    return
                }
                if let string = response.value {
                    let xml = XMLHash.parse(string)
                    let FutureDays: Int = futuredays
                    
                    self.CalendarID = []

                    for elem in xml["Calendar"]["CalendarDay"].all {
                        self.CalendarID.append(elem["CalendarID"].element!.text)
                    }
                    
                    guard self.CalendarID.count > futuredays else {
                        return
                    }
                    let str = UpperSchoolSchedule.thisFormatter.string(from: Date())
                    UserDefaults.standard.setValue(str, forKey: "LastUSGet")
                    
                    self.DayDateLong = (xml["Calendar"]["CalendarDay"][FutureDays]["DayDateLong"].element?.text)!
                    self.CycleDay = (xml["Calendar"]["CalendarDay"][FutureDays]["CycleDay"].element?.text)!
                    self.SchoolDayDescription = (xml["Calendar"]["CalendarDay"][FutureDays]["SchoolDayDescription"].element?.text)!
                    
                    self.periodNames = []
                    self.startTimesShort = []
                    self.endTimesShort = []
                    self.startTimesLong = []
                    self.endTimesLong = []
                    self.schoolEndDay = []

                    
                    for elem in xml["Calendar"]["CalendarDay"].all {
                        self.schoolEndDay.append(elem["DayDateLong"].element!.text)
                        self.allDayDateLongs.update(with: elem["DayDateLong"].element!.text)
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
                    
                    
                    
                    if let dodin = MiddleSchoolSchedule.thisFormatter.date(from: self.DayDateLong), let doisd = MiddleSchoolSchedule.thisFormatter.date(from: self.schoolEndDay[0]) {
                        self.dayDateLongDately = dodin
                        self.schoolEndDately = doisd
                    }
                    if !self.isSentforWifi {
                        self.isSentforWifi = true
                    }
                    completion(true, nil)

                }
            }
    

    }
}
extension Date {
    static func fromTimeInterval(_ timeInterval: TimeInterval, timeZone: TimeZone) -> Date {
        let date = Date(timeIntervalSinceReferenceDate: timeInterval)
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: timeZone, from: date)
        return calendar.date(from: components)!
    }
}

class XMLInfo: ObservableObject {
    
    @Published var lookingDate = Date()
    
    @Published var isSentforWifi = false
    @Published var schoolEndDately = Date()

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
    @Published var updatedXML = false
    @Published var CalendarID: [String] = []
    @Published var allDayDateLongs: Set<String> = []

    @Published var ClassesArray: [[String]] {
        didSet {
            UserDefaults.standard.set(ClassesArray, forKey: "ClassesArrayMS")
        }
    }

    init() {
        if let savedClassesArray = UserDefaults.standard.array(forKey: "ClassesArrayMS") as? [[String]] {
            self.ClassesArray = savedClassesArray
        } else {
            self.ClassesArray = [[String]](repeating: [String](repeating: "Free", count: 9), count: 6)
        }
    }

    
    @Published var ToDateArray = ""
    @Published var dayDateLongDately = Date()
    @Published var Finished = ""
    
    @Published var schoolEndDay: [String] = []

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
    
    
    @Published var currentPeriodText = ""
    
    @Published var lastGottedDately = Date()
    
    func resetToInit() {
        self.lookingDate = Date()

        self.isSentforWifi = false
        self.schoolEndDately = Date()
        self.lastGottedDately = Date()

        self.DayDateLong = "Having trouble connecting to internet"
        self.CycleDay = ""
        self.DivisionDescription = ""
        self.SchoolDayDescription = ""
        self.Per1_Per = ""
        self.Per2_Per = ""
        self.Break_Per = ""
        self.Per3_Per = ""
        self.Per4_Per = ""
        self.Per5_Per = ""
        self.Per6_Per = ""
        self.Per7_Per = ""
        self.Per8_Per = ""
        self.Per9_Per = ""
        self.Per1_StartTime = ""
        self.Per1_EndTime = ""
        self.Per2_StartTime = ""
        self.Per2_EndTime = ""
        self.Break_StartTime = ""
        self.Break_EndTime = ""
        self.Per3_StartTime = ""
        self.Per3_EndTime = ""
        self.Per4_StartTime = ""
        self.Per4_EndTime = ""
        self.Per5_StartTime = ""
        self.Per5_EndTime = ""
        self.Per6_StartTime = ""
        self.Per6_EndTime = ""
        self.Per7_StartTime = ""
        self.Per7_EndTime = ""
        self.Per8_StartTime = ""
        self.Per8_EndTime = ""
        self.Per9_StartTime = ""
        self.Per9_EndTime = ""
        self.selectedTab = "TodaySchoolDay"
        self.updatedXML = false
        self.CalendarID = []
        self.allDayDateLongs = []

        

        

        
        self.ToDateArray = ""
        self.dayDateLongDately = Date()
        self.Finished = ""
        
        self.schoolEndDay = []

        self.Per1_StartTimeLong = "1/1/1900 8:00:00 AM"
        self.Per1_EndTimeLong = "1/1/1900 8:40:00 AM"
        self.Per2_StartTimeLong = "1/1/1900 8:45:00 AM"
        self.Per2_EndTimeLong = "1/1/1900 9:25:00 AM"
        self.Break_StartTimeLong = "1/1/1900 9:25:00 AM"
        self.Break_EndTimeLong = "1/1/1900 9:50:00 AM"
        self.Per3_StartTimeLong = "1/1/1900 9:55:00 AM"
        self.Per3_EndTimeLong = "1/1/1900 10:35:00 AM"
        self.Per4_StartTimeLong = "1/1/1900 10:40:00 AM"
        self.Per4_EndTimeLong = "1/1/1900 11:20:00 AM"
        self.Per5_StartTimeLong = "1/1/1900 11:25:00 AM"
        self.Per5_EndTimeLong = "1/1/1900 12:05:00 PM"
        self.Per6_StartTimeLong = "1/1/1900 12:10:00 PM"
        self.Per6_EndTimeLong = "1/1/1900 12:50:00 PM"
        self.Per7_StartTimeLong = "1/1/1900 12:55:00 PM"
        self.Per7_EndTimeLong = "1/1/1900 1:35:00 PM"
        self.Per8_StartTimeLong = "1/1/1900 1:40:00 PM"
        self.Per8_EndTimeLong = "1/1/1900 2:20:00 PM"
        self.Per9_StartTimeLong = "1/1/1900 2:25:00 PM"
        self.Per9_EndTimeLong = "1/1/1900 3:05:00 PM"
        self.MScounter = 0
        self.lessThanFiveMinTrue = false
        self.SchoolDidEndVar = false
        self.DayOfWeek = "Tuesday"
        
        self.dsf = []
        
        self.dsn = []
        
        self.dst = []
    }
    
    func MSgetInfo(futuredays: Int, completion: @escaping (Bool, Error?) -> Void) {
        let url = "https://www.hw.com/portals/0/reports/DailySchedulesMS.xml?t="
        let urlRequest = URLRequest(url: URL(string: url)!)
   
        if let dtOut = UserDefaults.standard.string(forKey: "LastMSGet") {
            if dtOut != MiddleSchoolSchedule.thisFormatter.string(from: Date()) || !self.updatedXML {
                URLCache.shared.removeCachedResponse(for: urlRequest)
            }
        }
            
        
        
        
    
    
    AF.request(urlRequest)
        .responseString { response in
            if let error = response.error {
                self.isSentforWifi = false
                            completion(false, error)
                            return
                        }
            if let string = response.value {
                let xml = XMLHash.parse(string)
                let FutureDays: Int = futuredays
                
                self.CalendarID = []
                for elem in xml["Calendar"]["CalendarDay"].all {
                    self.CalendarID.append(elem["CalendarID"].element!.text)
                }
                guard self.CalendarID.count > futuredays else {
                    return
                }
                
                let str = MiddleSchoolSchedule.thisFormatter.string(from: Date())
                UserDefaults.standard.setValue(str, forKey: "LastMSGet")
                
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

                
                
                self.schoolEndDay = []

                for elem in xml["Calendar"]["CalendarDay"].all {
                    self.schoolEndDay.append(elem["DayDateLong"].element!.text)
                    self.allDayDateLongs.update(with: elem["DayDateLong"].element!.text)
                }
                
                
                self.schoolEndDay = [self.schoolEndDay.last!]
                
                if let dodin = MiddleSchoolSchedule.thisFormatter.date(from: self.DayDateLong), let doisd = MiddleSchoolSchedule.thisFormatter.date(from: self.schoolEndDay[0]) {
                    self.dayDateLongDately = dodin
                    self.schoolEndDately = doisd
                }
                self.dsf = [self.Per1_Per, self.Per2_Per, self.Break_Per, self.Per3_Per, self.Per4_Per, self.Per5_Per, self.Per6_Per, self.Per7_Per, self.Per8_Per, self.Per9_Per, "school ends"]
                
                self.dsn = [self.Per1_StartTime, self.Per2_StartTime, self.Break_StartTime, self.Per3_StartTime, self.Per4_StartTime, self.Per5_StartTime, self.Per6_StartTime, self.Per7_StartTime, self.Per8_StartTime, self.Per9_StartTime]
                self.dst = [self.Per1_EndTime, self.Per2_EndTime, self.Break_EndTime, self.Per3_EndTime, self.Per4_EndTime, self.Per5_EndTime, self.Per6_EndTime, self.Per7_EndTime, self.Per8_EndTime, self.Per9_EndTime]

                
                
                
                self.isSentforWifi = true

                completion(true, nil)

                
                
                
            }
        }
}
    
    
    
    
    
}


struct USMSSelect: View {
    @State public var MiddleNav : Bool = false
    @State public var UpperNav : Bool = false
    @State var ButtonLook = GrowingButton2()
    @EnvironmentObject var xmlinfo: XMLInfo
    @EnvironmentObject var usinfo: USINfo
    var body: some View {
        if #available(watchOS 9.0, *) {
            
                VStack(spacing: 10){
                    
                    NavigationLink("Upper School Schedule", destination: USSView())
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .font(.system(size: 25.5, weight: .bold))
                        .buttonStyle(ButtonLook)
                    
                    
                    NavigationLink("Middle School Schedule", destination: MSSView())
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .font(.system(size: 25.5, weight: .bold))
                        .buttonStyle(ButtonLook)
                        
                }
                

                
            
        } else {
            
            
                VStack(spacing: 10){
                    
                    
                        NavigationLink("Upper School Schedule",
                                       destination: USSView()
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

struct Schedule_Previews: PreviewProvider {
    static var previews: some View {
        USMSSelect().environmentObject(USINfo()).environmentObject(XMLInfo())
    }
}
