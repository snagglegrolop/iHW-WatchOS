//
//  USMath_Comp.swift
//  iHW-WatchOS Watch App
//
//  Created by Zachary Abrahamson  on 3/31/23.
//

import SwiftUI

struct USPeriodUntilTextFinished: View {
    @EnvironmentObject var usinfo: USINfo
    @State private var Finished = ""
    @State private var Array = ["", "", ""]
    @State private var ToDateArray = ""
    @State private var customdate = Date()
    @State private var TimeDif = ""
    @State private var nextPeriod = ""
    @State private var nextPeriodText = ""
    @State private var SchoolWillEndVar = false
    @State private var FiveMinColor: Color = .red
    @State private var endingWeekday = ""
    @AppStorage("lastSchedRequestTime") var lastSchedRequestTime: Double = 0
    @State private var NextToNotif: [TimeInterval] = []
    @State private var nextPer: [String] = []
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text(TimeDif)
                .multilineTextAlignment(.center)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(usinfo.isSentforWifi ? FiveMinColor : .blue)
                .lineLimit(nil)
                .onReceive(timer) { time in
                    getNearestPeriod()
                }
        }.onAppear {
            usinfo.USgetInfo(futuredays: usinfo.USCounter) { success, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    usinfo.isSentforWifi = false
                    return
                }
                
                if success {
                    // Do something with the parsed XML data
                    print("XML data parsed successfully!")
                } else {
                    print("Failed to parse XML data.")
                    usinfo.isSentforWifi = false
                }
            }
            
            let date = Date()
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy/MM/dd"
            ToDateArray = dateformatter.string(from: date)
            
            getNearestPeriod()
            if usinfo.DayDateLong ==  UpperSchoolSchedule.thisFormatter.string(from: Date()) {
                print(usinfo.dayDateLongDately, Date())
                NotificationManager.instance.clearNotifs()
                for j in 0..<NextToNotif.count {
                    if NextToNotif[j] > 300.0 {
                        NotificationManager.instance.scheduleMSNotif(inSeconds: NextToNotif[j], nextPers: nextPer[j], UST_MSF: true, nextClassName: usinfo.ClassesDict[nextPer[j]] ?? "Free")
                        
                        print("scheduled notif for in \(NextToNotif[j]) seconds for \(nextPer[j])")
                        print()
                        print(NextToNotif)
                        print(nextPer)
                    }
                }
            } else {
                print("oksaoksaoksa")
            }
            
        }
        

        
    }
    
    private func getNearestPeriod() {
        guard usinfo.isSentforWifi else {
            TimeDif =
            """
There is no wifi currently!
Tap to try again...
"""
            return
        }
        var sils = usinfo.startTimesLong
        sils.append(usinfo.endTimesLong.last!)
        
            var secondArray: [Double] = []
            
            for i in sils {
                
                secondArray.append(GetDiffSeconds(stringXML: i))
                
            }
            
            if let closestPositive = secondArray.filter({ $0 > 0 }).sorted().first, let index = secondArray.firstIndex(of: closestPositive) {
                NextToNotif = []
                nextPer = []
                for p in index..<secondArray.count {
                    NextToNotif.append(secondArray[p])
                    
                    nextPer.append(usinfo.periodNames[p])
                }
//                print(NextToNotif)
//                print(nextPer)
                    nextPeriod = sils[index]
                    nextPeriodText = usinfo.periodNames[index]
                usinfo.currentPeriod = usinfo.periodNames[index - 1]
                
                
                if usinfo.periodNames[index] == usinfo.periodNames.last! {
                    SchoolWillEndVar = true
                }
                
                usinfo.SchoolDidEndVar = false
                if closestPositive <= 300.0 {
                    usinfo.lessThanFiveMinTrue = true
                } else {
                    usinfo.lessThanFiveMinTrue = false
                }
            } else {
                
                usinfo.SchoolDidEndVar = true
                SchoolWillEndVar = false
                usinfo.lessThanFiveMinTrue = false
                nextPeriod = usinfo.endTimesLong.last!
            }
            
            
                switch usinfo.lessThanFiveMinTrue {
                case true: FiveMinColor = .red
                default: FiveMinColor = .purp
                }
                
                
                
            
            
            let (h,m,s) = secondsToHoursMinutesSeconds(Int(GetDiffSeconds(stringXML: nextPeriod)))
            
        
        
                    if usinfo.SchoolDidEndVar {
                        TimeDif =  "School is over"
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
        usinfo.timediftext = TimeDif
        
    }
    
    func GetDiffSeconds(stringXML: String) -> TimeInterval {
        let str = stringXML
        Array = str.components(separatedBy: " ")
        usinfo.Finished = "\(ToDateArray), \(Array[1]), \(Array[2])"
        

        let mydate = DateFormatter()
        mydate.dateFormat = "yyyy/MM/dd, hh:mm:ss, a"
        let weekform = DateFormatter()
        weekform.dateFormat = "EEEE"
        let BeginStrings = mydate.string(from: Date())
        let beginning = mydate.date(from: BeginStrings)
        let ending = mydate.date(from: usinfo.Finished)
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



struct USCont_Previews: PreviewProvider {
    static var previews: some View {
        USContent().environmentObject(USINfo()).environmentObject(XMLInfo())
    }
}

struct USContent: View {
    
    var body: some View {
        USPeriodUntilTextFinished()
            
    }
 }

