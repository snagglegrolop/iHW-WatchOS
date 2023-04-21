//
//  Math_Comp.swift
//  iHW-WatchOS Watch App
//
//  Created by Zachary Abrahamson  on 2/3/23.
//



import Foundation
import SwiftUI
import UserNotifications




struct PeriodUntilTextFinished: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @EnvironmentObject var xmlinfo: XMLInfo
    @State private var reset = false
    @State private var Finished = ""
    @State private var Array = ["", "", ""]
    @State private var ToDateArray = ""
    @State private var customdate = Date()
    @State private var TimeDif = ""
    @State private var nextPeriod = ""
    @State private var SchoolWillEndVar = false
    @State private var FiveMinColor: Color = .red
    @State private var endingWeekday = ""
    @State private var nextPeriodText = ""
    @State private var NextToNotif: [TimeInterval] = []
    @State private var NextToNotifClass: [String] = []
    @State private var nextPer: [String] = []
    var body: some View {
        VStack {
            Text(TimeDif)
                .multilineTextAlignment(.center)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(xmlinfo.isSentforWifi ? FiveMinColor : .blue)
                .lineLimit(nil)
                .onReceive(timer) { time in
                    getNearestPeriod()
                    
                    
                }
        }.onAppear {
            xmlinfo.MSgetInfo(futuredays: xmlinfo.MScounter) { success, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    xmlinfo.isSentforWifi = false
                    return
                }
                
                if success {
                    // Do something with the parsed XML data
                    print("XML data parsed successfully!")
                } else {
                    print("Failed to parse XML data.")
                    xmlinfo.isSentforWifi = false
                }
            }
            let date = Date()
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy/MM/dd"
            ToDateArray = dateformatter.string(from: date)
            getNearestPeriod()
            
            if xmlinfo.DayDateLong ==  MiddleSchoolSchedule.thisFormatter.string(from: Date()) {
                NotificationManager.instance.clearNotifs()
                for j in 0..<NextToNotif.count {
                    if NextToNotif[j] > 300.0 {
                        if nextPer[j] == nextPer.last || nextPer[j] == "House / Activities" || nextPer[j] == "school ends" {
                            NotificationManager.instance.scheduleMSNotif(inSeconds: NextToNotif[j], nextPers: nextPer[j], UST_MSF: false, nextClassName: NextToNotifClass[j])
                            
                            print("scheduled notif for in \(NextToNotif[j]) seconds for \(nextPer[j]), \(NextToNotifClass[j])")
                        } else {
                            NotificationManager.instance.scheduleMSNotif(inSeconds: NextToNotif[j] - 300.0, nextPers: nextPer[j], UST_MSF: false, nextClassName: NextToNotifClass[j])
                            
                            print("scheduled notif for in \(NextToNotif[j] - 300.0) seconds for \(nextPer[j]), \(NextToNotifClass[j])")
                        }
                    }
                }
            } else {
                print("dodmt send theo notif")
            }
            print("...")
            
        }
        

        
    }
    
    private func getNearestPeriod() {
        if !xmlinfo.isSentforWifi {
            TimeDif =
            "There is no wifi currently!\nTap to try again..."
            return
        }
            let sil = [xmlinfo.Per1_StartTimeLong, xmlinfo.Per2_StartTimeLong, xmlinfo.Break_StartTimeLong, xmlinfo.Per3_StartTimeLong, xmlinfo.Per4_StartTimeLong, xmlinfo.Per5_StartTimeLong, xmlinfo.Per6_StartTimeLong, xmlinfo.Per7_StartTimeLong, xmlinfo.Per8_StartTimeLong, xmlinfo.Per9_StartTimeLong, xmlinfo.Per9_EndTimeLong]
            var secondArray: [Double] = []
            
            for i in sil {
                
                secondArray.append(GetDiffSeconds(stringXML: i))
                
            }
            
            
        
        if let closestPositive = secondArray.filter({ $0 > 0 }).sorted().first, let index = secondArray.firstIndex(of: closestPositive) {
            NextToNotif = []
            NextToNotifClass = []
            nextPer = []
            
            for p in index..<secondArray.count {
                NextToNotif.append(secondArray[p])
                nextPer.append(xmlinfo.dsf[p])
                if p <= 1 {
                    NextToNotifClass.append(xmlinfo.ClassesArray[Int(xmlinfo.CycleDay)! - 1][p])
                } else if p >= 3 && p <= 9 {
                    NextToNotifClass.append(xmlinfo.ClassesArray[Int(xmlinfo.CycleDay)! - 1][p - 1])
                } else {
                    NextToNotifClass.append("Free")
                }
            }
            xmlinfo.SchoolDidEndVar = false
            
            switch index {
                case 0:
                    nextPeriod = xmlinfo.Per1_StartTimeLong
                    nextPeriodText = xmlinfo.Per1_Per
                xmlinfo.currentPeriodText = ""
                case 1:
                    nextPeriod = xmlinfo.Per2_StartTimeLong
                    nextPeriodText = xmlinfo.Per2_Per
                xmlinfo.currentPeriodText = xmlinfo.Per1_Per
                case 2:
                    nextPeriod = xmlinfo.Break_StartTimeLong
                    nextPeriodText = xmlinfo.Break_Per
                xmlinfo.currentPeriodText = xmlinfo.Per2_Per
                case 3:
                    nextPeriod = xmlinfo.Per3_StartTimeLong
                    nextPeriodText = xmlinfo.Per3_Per
                xmlinfo.currentPeriodText = xmlinfo.Break_Per
                case 4:
                    nextPeriod = xmlinfo.Per4_StartTimeLong
                    nextPeriodText = xmlinfo.Per4_Per
                xmlinfo.currentPeriodText = xmlinfo.Per3_Per
                case 5:
                        nextPeriod = xmlinfo.Per5_StartTimeLong
                    nextPeriodText = xmlinfo.Per5_Per
                xmlinfo.currentPeriodText = xmlinfo.Per4_Per
                case 6:
                        nextPeriod = xmlinfo.Per6_StartTimeLong
                nextPeriodText = xmlinfo.Per6_Per
                xmlinfo.currentPeriodText = xmlinfo.Per5_Per
                case 7:
                        nextPeriod = xmlinfo.Per7_StartTimeLong
                nextPeriodText = xmlinfo.Per7_Per
                xmlinfo.currentPeriodText = xmlinfo.Per6_Per
                case 8:
                        nextPeriod = xmlinfo.Per8_StartTimeLong
                nextPeriodText = xmlinfo.Per8_Per
                xmlinfo.currentPeriodText = xmlinfo.Per7_Per
                case 9:
                        nextPeriod = xmlinfo.Per9_StartTimeLong
                nextPeriodText = xmlinfo.Per9_Per
                xmlinfo.currentPeriodText = xmlinfo.Per8_Per
                case 10:
                        nextPeriod = xmlinfo.Per9_EndTimeLong
                    SchoolWillEndVar = true
                    nextPeriodText = "School"
                xmlinfo.currentPeriodText = xmlinfo.Per9_Per
                default:
                    xmlinfo.SchoolDidEndVar = false
                    SchoolWillEndVar = false
                    xmlinfo.lessThanFiveMinTrue = false
                    nextPeriod = xmlinfo.Per9_EndTimeLong
                xmlinfo.currentPeriodText = ""
                }
                if closestPositive <= 300.0 {
                    xmlinfo.lessThanFiveMinTrue = true
                } else {
                    xmlinfo.lessThanFiveMinTrue = false
                }
            } else {
                
                xmlinfo.SchoolDidEndVar = true
                SchoolWillEndVar = false
                xmlinfo.lessThanFiveMinTrue = false
                nextPeriod = xmlinfo.Per9_EndTimeLong
                xmlinfo.currentPeriodText = ""
            }
            
            
                switch xmlinfo.lessThanFiveMinTrue {
                case true: FiveMinColor = .red
                default: FiveMinColor = .purp
                }
                
                
                
            
            
            let (h,m,s) = secondsToHoursMinutesSeconds(Int(GetDiffSeconds(stringXML: nextPeriod)))
            
        
        
                    if xmlinfo.SchoolDidEndVar {
                        TimeDif = "School is over"
                    } else {
                        if SchoolWillEndVar {
                            if h == 0 && m == 0 {
                                TimeDif =  "\(nextPeriodText) ends in \(s) seconds"
                            } else if h == 0 {
                                TimeDif =  "\(nextPeriodText) ends in \(m) minutes and \(s) seconds"
                            } else {
                                TimeDif =  "\(nextPeriodText) ends in \(h) hours, \(m) minutes, and \(s) seconds"
                            }
                        } else if !SchoolWillEndVar {
                            if h == 0 && m == 0 {
                                TimeDif =  "\(nextPeriodText) begins in \(s) seconds"
                            } else if h == 0 {
                                TimeDif =  "\(nextPeriodText) begins in \(m) minutes and \(s) seconds"
                            } else {
                                TimeDif =  "\(nextPeriodText) begins in \(h) hours, \(m) minutes, and \(s) seconds"
                            }
        
                        }
        
                    }
        
        
    }
    
    func GetDiffSeconds(stringXML: String) -> TimeInterval {
        let str = stringXML
        Array = str.components(separatedBy: " ")
        xmlinfo.Finished = "\(ToDateArray), \(Array[1]), \(Array[2])"
        

        let mydate = DateFormatter()
        mydate.dateFormat = "yyyy/MM/dd, hh:mm:ss, a"
        let weekform = DateFormatter()
        weekform.dateFormat = "EEEE"
        let BeginStrings = mydate.string(from: Date())
        let beginning = mydate.date(from: BeginStrings)
        let ending = mydate.date(from: xmlinfo.Finished)
        guard ending != nil else {
            return -10
        }
        let diffinSeconds = ending!.timeIntervalSinceReferenceDate - beginning!.timeIntervalSinceReferenceDate
        return(diffinSeconds)
        
    }


    private func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

}



struct Cont_Previews: PreviewProvider {
    static var previews: some View {
        Content().environmentObject(USINfo()).environmentObject(XMLInfo())
    }
}

struct Content: View {
    var body: some View {
        PeriodUntilTextFinished()
        
    }
 }

