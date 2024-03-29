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
    @ObservedObject var xmlinfo: XMLInfo
    @State private var Finished = ""
    @State var Array = ["", "", ""]
    @State var ToDateArray = ""
    @State var customdate = Date()
    @State private var TimeDif = ""
    @State var nextPeriod = ""
    @State var SchoolWillEndVar = false
    @State var FiveMinColor: Color = .red
    @State var endingWeekday = ""
    @State var nextPeriodText = ""
    @AppStorage("lastSchedRequestTime") var lastSchedRequestTime: Double = 0
    @State private var NextToNotif: [TimeInterval] = []
    @State private var nextPer: [String] = []
    var body: some View {
        VStack {
            Spacer().frame(height: xmlinfo.isSentforWifi ? 15 : 0)
            Text(TimeDif)
                .multilineTextAlignment(.center)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(xmlinfo.isSentforWifi ? FiveMinColor : .blue)
                .lineLimit(nil)
                .onAppear() {
                    xmlinfo.MSgetInfo(futuredays: xmlinfo.MScounter) { success, error in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                            return
                        }
                        
                        if success {
                            // Do something with the parsed XML data
                            print("XML data parsed successfully!")
                        } else {
                            print("Failed to parse XML data.")
                        }
                    }
                }
        }.onAppear {
            let date = Date()
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy/MM/dd"
            ToDateArray = dateformatter.string(from: date)
            getNearestPeriod()
            NotificationManager.instance.clearNotifs()
            for j in 0..<NextToNotif.count {
                if NextToNotif[j] > 300.0 {
                    NotificationManager.instance.scheduleMSNotif(inSeconds: NextToNotif[j] - 300.0, nextPers: nextPer[j], UST_MSF: false)
                    
                    print("scheduled notif for in \(NextToNotif[j] - 300.0) seconds for \(nextPer[j])")
                    print()
                    print(NextToNotif)
                    print(nextPer)
                }
            }
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                getNearestPeriod()
            }
            print("...")
            
        }
        

        
    }
    
    private func getNearestPeriod() {
        guard xmlinfo.isSentforWifi else {
            TimeDif =
            """
There is no wifi currently!
Tap to try again...
"""
            return
        }
            let sil = [xmlinfo.Per1_StartTimeLong, xmlinfo.Per2_StartTimeLong, xmlinfo.Break_StartTimeLong, xmlinfo.Per3_StartTimeLong, xmlinfo.Per4_StartTimeLong, xmlinfo.Per5_StartTimeLong, xmlinfo.Per6_StartTimeLong, xmlinfo.Per7_StartTimeLong, xmlinfo.Per8_StartTimeLong, xmlinfo.Per9_StartTimeLong, xmlinfo.Per9_EndTimeLong]
            var secondArray: [Double] = []
            
            for i in sil {
                
                secondArray.append(GetDiffSeconds(stringXML: i))
                
            }
            
            
        
        if let closestPositive = secondArray.filter({ $0 > 0 }).sorted().first, let index = secondArray.firstIndex(of: closestPositive) {
            NextToNotif = []
            
            
            for p in index..<secondArray.count {
                NextToNotif.append(secondArray[p])
                nextPer.append(xmlinfo.dsf[p])
               
                
            }
            switch index {
                case 0:
                    nextPeriod = xmlinfo.Per1_StartTimeLong
                    nextPeriodText = "Period 1"
                case 1:
                    nextPeriod = xmlinfo.Per2_StartTimeLong
                    nextPeriodText = "Period 2"
                case 2:
                    nextPeriod = xmlinfo.Break_StartTimeLong
                    nextPeriodText = "Break"
                case 3:
                    nextPeriod = xmlinfo.Per3_StartTimeLong
                    nextPeriodText = "Period 3"
                case 4:
                    nextPeriod = xmlinfo.Per4_StartTimeLong
                    nextPeriodText = "Period 4"
                case 5:
                        nextPeriod = xmlinfo.Per5_StartTimeLong
                    nextPeriodText = "Period 5"
                case 6:
                        nextPeriod = xmlinfo.Per6_StartTimeLong
                    nextPeriodText = "Period 6"
                case 7:
                        nextPeriod = xmlinfo.Per7_StartTimeLong
                    nextPeriodText = "Period 7"
                case 8:
                        nextPeriod = xmlinfo.Per8_StartTimeLong
                    nextPeriodText = "Period 8"
                case 9:
                        nextPeriod = xmlinfo.Per9_StartTimeLong
                    nextPeriodText = "Period 9"
                case 10:
                        nextPeriod = xmlinfo.Per9_EndTimeLong
                    SchoolWillEndVar = true
                    nextPeriodText = "School"
                default:
                        xmlinfo.SchoolDidEndVar = false
                    SchoolWillEndVar = false
                    xmlinfo.lessThanFiveMinTrue = false
                    nextPeriod = xmlinfo.Per9_EndTimeLong
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
        Content()
    }
}

struct Content: View {
    @ObservedObject var xmlinfo = XMLInfo()
    var body: some View {
        PeriodUntilTextFinished(xmlinfo: xmlinfo)
        
    }
 }

