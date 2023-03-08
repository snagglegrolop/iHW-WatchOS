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
    @State var Finished = ""
    @State var Array = ["", "", ""]
    @State var ToDateArray = ""
    @State var onScreen: Bool
    @State var customdate = Date()
    @State var TimeDif = ""
    @State var nextPeriod = ""
    @State var nextPeriodText = ""
    @State var SchoolWillEndVar = false
    @State var FiveMinColor: Color = .red
    @State var endingWeekday = ""
    @State var GotNearestPeriod = false
    @AppStorage("lastSchedRequestTime") var lastSchedRequestTime: Double = 0
    @State var Popup_PoppedUp = false
    var body: some View {
        VStack {
            Spacer().frame(height: 15)
            Text(TimeDif)
                .multilineTextAlignment(.center)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(FiveMinColor)
            
        }.onAppear {
            print(#line)
            getNearestPeriod(repeats: onScreen)
            let date = Date()
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy/MM/dd"
            ToDateArray = dateformatter.string(from: date)
            if !onScreen {
                print(#line)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    print(#line)
                    MSMakeNotifs()
                }
            }
            
            
        }
    }
    
    func MSMakeNotifs() {
        let currentTime = Date().timeIntervalSince1970

            if lastSchedRequestTime == 0 || !Calendar.current.isDate(Date(timeIntervalSince1970: lastSchedRequestTime), inSameDayAs: Date()) {
                print("IT IS A NEW DAY but for notifs")
                print("62")
                if !onScreen {
                    print(#line)
                    let TUFiveArray = [
                        xmlinfo.TimeUntil_FiveMinute_Notif["First"],
                        xmlinfo.TimeUntil_FiveMinute_Notif["Second"],
                        xmlinfo.TimeUntil_FiveMinute_Notif["Break"],
                        xmlinfo.TimeUntil_FiveMinute_Notif["Third"],
                        xmlinfo.TimeUntil_FiveMinute_Notif["Fourth"],
                        xmlinfo.TimeUntil_FiveMinute_Notif["Fifth"],
                        xmlinfo.TimeUntil_FiveMinute_Notif["Sixth"],
                        xmlinfo.TimeUntil_FiveMinute_Notif["Seventh"],
                        xmlinfo.TimeUntil_FiveMinute_Notif["Eigth"],
                        xmlinfo.TimeUntil_FiveMinute_Notif["Ninth"]
                    ]
                    print(#line)
                    for TimeUntil in TUFiveArray {
                        print(xmlinfo.TimeUntil_FiveMinute_Notif)
                        print(#line)
                        var nextperiodNotif = "Next Period"
                        if TUFiveArray[0] == TimeUntil {
                            nextperiodNotif = "Period 1"
                        } else if TUFiveArray[1] == TimeUntil {
                            nextperiodNotif = "Period 2"
                        } else if TUFiveArray[2] == TimeUntil {
                            nextperiodNotif = "Break"
                        }  else if TUFiveArray[3] == TimeUntil {
                            nextperiodNotif = "Period 3"
                        }  else if TUFiveArray[4] == TimeUntil {
                            nextperiodNotif = "Period 4"
                        }  else if TUFiveArray[5] == TimeUntil {
                            nextperiodNotif = "Period 5"
                        }  else if TUFiveArray[6] == TimeUntil {
                            nextperiodNotif = "Period 6"
                        }  else if TUFiveArray[7] == TimeUntil {
                            nextperiodNotif = "Period 7"
                        }  else if TUFiveArray[8] == TimeUntil {
                            nextperiodNotif = "Period 8"
                        }  else if TUFiveArray[9] == TimeUntil {
                            nextperiodNotif = "Period 9"
                        }
                        print(#line)
                        let content = UNMutableNotificationContent()
                        
                        content.title = "Five minutes until next period!"
                        content.body = "\(nextperiodNotif) is in 5 minutes"
                        print(nextperiodNotif)
                        content.sound = UNNotificationSound.default
                        
                        print(#line)
                        
                        
                        if TimeUntil ?? -10 > 0.0 {
                            let identifier = UUID().uuidString
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeUntil!, repeats: false)
                            print(#line)
                            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                            print(identifier)


                            UNUserNotificationCenter.current().add(request) { (error) in
                                if let error = error {
                                    print("Error \(error.localizedDescription)")
                                    xmlinfo.CanMS_Nav = true

                                }else{
                                    print("send!!")
                                    if TUFiveArray[9] == TimeUntil {
                                        withAnimation {
                                            xmlinfo.Popup_PoppedUp = true
                                        }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                
                                                    xmlinfo.Popup_PoppedUp = false
                                                    xmlinfo.CanMS_Nav = true
                                            
                                        }
                                    }
                                        
                                        
                                }
                            }
                            
                            lastSchedRequestTime = currentTime
                        } else {
                            
                            print("not enough time, moving on")
                        }
                        
                        if TUFiveArray[9] == TimeUntil {
                            xmlinfo.CanMS_Nav = true
                        }
                    }
                }
        }
        else {
            print("not sending notifs :(")
            xmlinfo.CanMS_Nav = true
        }
    }
    
    public func getNearestPeriod(repeats: Bool) {
        xmlinfo.MSgetInfo(futuredays: xmlinfo.MScounter)
        print(#line)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: repeats) { timer in
            print(#line)
            if xmlinfo.DayDateLong == "Having trouble connecting to internet" {
                xmlinfo.MSgetInfo(futuredays: xmlinfo.MScounter)
                print(#line)
                //this is where the issue is, it doesn't get the wifi i think
            } else {
                print(#line)
                var timersArray: [Double] = []
                let StartTimeArray = [
                    
                    xmlinfo.StartTimeLong_Dict["Per1"],
                    xmlinfo.StartTimeLong_Dict["Per2"],
                    xmlinfo.StartTimeLong_Dict["Break"],
                    xmlinfo.StartTimeLong_Dict["Per3"],
                    xmlinfo.StartTimeLong_Dict["Per4"],
                    xmlinfo.StartTimeLong_Dict["Per5"],
                    xmlinfo.StartTimeLong_Dict["Per6"],
                    xmlinfo.StartTimeLong_Dict["Per7"],
                    xmlinfo.StartTimeLong_Dict["Per8"],
                    xmlinfo.StartTimeLong_Dict["Per9"],
                    xmlinfo.EndTimeLong_Dict["Per9"]

                ]
                for Starts in StartTimeArray {
                    print(#line)
                    let TimesArray = GetDiffSeconds(stringXML: Starts ?? "1/1/1900 8:00:00 AM")
                        timersArray.append(TimesArray)
                }
                
                    xmlinfo.FirstTUFiveMNotif = timersArray[0] - 300.0
                    print(xmlinfo.FirstTUFiveMNotif)
                    xmlinfo.SecondTUFiveMNotif = timersArray[1] - 300.0
                    print(xmlinfo.SecondTUFiveMNotif)
                    xmlinfo.BreakTUFiveMNotif = timersArray[2]
                    print(xmlinfo.BreakTUFiveMNotif)
                    xmlinfo.ThirdTUFiveMNotif = timersArray[3] - 300.0
                    print(xmlinfo.ThirdTUFiveMNotif)
                    xmlinfo.FourthTUFiveMNotif = timersArray[4] - 300.0
                    print(xmlinfo.FourthTUFiveMNotif)
                    xmlinfo.FifthTUFiveMNotif = timersArray[5] - 300.0
                    print(xmlinfo.FifthTUFiveMNotif)
                    xmlinfo.SixthTUFiveMNotif = timersArray[6] - 300.0
                    print(xmlinfo.SixthTUFiveMNotif)
                    xmlinfo.SeventhTUFiveMNotif = timersArray[7] - 300.0
                    print(xmlinfo.SeventhTUFiveMNotif)
                    xmlinfo.EigthTUFiveMNotif = timersArray[8] - 300.0
                    print(xmlinfo.EigthTUFiveMNotif)
                    xmlinfo.NinthTUFiveMNotif = timersArray[9] - 300.0
                    print(xmlinfo.NinthTUFiveMNotif)
                    
                print(#line)
                if timersArray[0] >= 0.0 {
                        if timersArray[0] <= 300.0 {
                            xmlinfo.lessThanFiveMinTrue = true
                            
                            
                        } else if timersArray[0] > 300.0  {
                            xmlinfo.lessThanFiveMinTrue = false
                            
                        }
                        
                        
                        nextPeriod = xmlinfo.StartTimeLong_Dict["Per1"] ?? "1/1/1900 8:00:00 AM"
                        nextPeriodText = "Period 1"
                        
                        //                    print("Per1 is next")
                    } else if timersArray[1] >= 0.0 {
                        if timersArray[1] <= 300.0 {
                            xmlinfo.lessThanFiveMinTrue = true
                            
                            
                        } else if timersArray[1] > 300.0 {
                            xmlinfo.lessThanFiveMinTrue = false
                            
                            
                        }
                        nextPeriod = xmlinfo.StartTimeLong_Dict["Per2"] ?? "1/1/1900 8:45:00 AM"
                        nextPeriodText = "Period 2"
                        
                        //                    print("Per2 is next")
                    } else if timersArray[2] >= 0.0 {
                        if timersArray[2] <= 300.0 {
                            xmlinfo.lessThanFiveMinTrue = true
                            
                            
                        } else if timersArray[2] > 300.0 {
                            xmlinfo.lessThanFiveMinTrue = false
                            
                            
                        }
                        
                        nextPeriod = xmlinfo.StartTimeLong_Dict["Break"] ?? "1/1/1900 9:25:00 AM"
                        nextPeriodText = "Break"
                        
                        //                    print("Break is next")
                    } else if timersArray[3] >= 0.0 {
                        if timersArray[3] <= 300.0 {
                            xmlinfo.lessThanFiveMinTrue = true
                            
                            
                        } else if timersArray[3] > 300.0 {
                            xmlinfo.lessThanFiveMinTrue = false
                            
                            
                        }
                        nextPeriod = xmlinfo.StartTimeLong_Dict["Per3"] ?? "1/1/1900 9:55:00 AM"
                        nextPeriodText = "Period 3"
                        
                        //                    print("Per4 is next")
                    } else if timersArray[4] >= 0.0 {
                        if timersArray[4] <= 300.0 {
                            xmlinfo.lessThanFiveMinTrue = true
                            
                            
                        } else if timersArray[4] > 300.0 {
                            xmlinfo.lessThanFiveMinTrue = false
                            
                            
                        }
                        nextPeriod = xmlinfo.StartTimeLong_Dict["Per4"] ?? "1/1/1900 10:40:00 AM"
                        nextPeriodText = "Period 4"
                        
                        //                    print("Per5 is next")
                    } else if timersArray[5] >= 0.0 {
                        if timersArray[5] <= 300.0 {
                            xmlinfo.lessThanFiveMinTrue = true
                            
                            
                        } else if timersArray[5] > 300.0 {
                            xmlinfo.lessThanFiveMinTrue = false
                            
                            
                        }
                        nextPeriod = xmlinfo.StartTimeLong_Dict["Per5"] ?? "1/1/1900 11:25:00 AM"
                        nextPeriodText = "Period 5"
                        
                        //                    print("Per6 is next")
                    } else if timersArray[6] >= 0.0 {
                        if timersArray[6] <= 300.0 {
                            xmlinfo.lessThanFiveMinTrue = true
                            
                            
                        } else if timersArray[6] > 300.0 {
                            xmlinfo.lessThanFiveMinTrue = false
                            
                            
                        }
                        nextPeriod = xmlinfo.StartTimeLong_Dict["Per6"] ?? "1/1/1900 12:10:00 PM"
                        nextPeriodText = "Period 6"
                        
                        //                    print("Per7 is next")
                    } else if timersArray[7] >= 0.0 {
                        if timersArray[7] <= 300.0 {
                            xmlinfo.lessThanFiveMinTrue = true
                            
                            
                        } else if timersArray[7] > 300.0 {
                            xmlinfo.lessThanFiveMinTrue = false
                            
                            
                        }
                        nextPeriod = xmlinfo.StartTimeLong_Dict["Per7"] ?? "1/1/1900 12:55:00 PM"
                        nextPeriodText = "Period 7"
                        //                    print("Per8 is next")
                    } else if timersArray[8] >= 0.0 {
                        if timersArray[8] <= 300.0 {
                            xmlinfo.lessThanFiveMinTrue = true
                            
                            
                        } else if timersArray[8] > 300.0 {
                            xmlinfo.lessThanFiveMinTrue = false
                            
                            
                        }
                        nextPeriod = xmlinfo.StartTimeLong_Dict["Per8"] ?? "1/1/1900 1:40:00 PM"
                        nextPeriodText = "Period 8"
                        
                        //                    print("Per9 is next")
                    } else if timersArray[9] >= 0.0 {
                        if timersArray[9] <= 300.0 {
                            xmlinfo.lessThanFiveMinTrue = true
                            
                            
                        } else if timersArray[9] > 300.0 {
                            xmlinfo.lessThanFiveMinTrue = false
                            
                            
                        }
                        nextPeriod = xmlinfo.StartTimeLong_Dict["Per9"] ?? "1/1/1900 2:25:00 PM"
                        nextPeriodText = "Period 9"
                        //                    print("Per9End is next")
                    } else if timersArray[10] >= 0.0 {
                        if timersArray[10] <= 300.0 {
                            xmlinfo.lessThanFiveMinTrue = true
                            
                            
                        } else if timersArray[10] > 300.0 {
                            xmlinfo.lessThanFiveMinTrue = false
                            
                            
                        }
                        nextPeriod = xmlinfo.EndTimeLong_Dict["Per9"] ?? "1/1/1900 3:05:00 PM"
                        SchoolWillEndVar = true
                        nextPeriodText = "School"
                        //                    print("School ends next")
                    } else if timersArray[10] <= 0.0 {
                        //                    print("school ended already")
                        xmlinfo.SchoolDidEndVar = true
                        SchoolWillEndVar = false
                        xmlinfo.lessThanFiveMinTrue = false
                        nextPeriod = xmlinfo.EndTimeLong_Dict["Per9"] ?? "1/1/1900 3:05:00 PM"

                        
                        
                        
                    }
                
                if xmlinfo.lessThanFiveMinTrue {
                    
                    FiveMinColor = .red
                } else if !xmlinfo.lessThanFiveMinTrue {
                    FiveMinColor = .purp
                }
                
                
            }
            
            
            print(#line)
            let (h,m,s) = secondsToHoursMinutesSeconds(Int(GetDiffSeconds(stringXML: nextPeriod)))
            if xmlinfo.SchoolDidEndVar {
                TimeDif = "School is over"
                print(#line)
            } else {
                if SchoolWillEndVar {
                    if h == 0 && m == 0 {
                        TimeDif = "\(nextPeriodText) ends in \(s) seconds"
                        
                    } else if h == 0 {
                        TimeDif = "\(nextPeriodText) ends in \(m) minutes and \(s) seconds"
                    } else {
                        TimeDif = "\(nextPeriodText) ends in \(h) hours, \(m) minutes, and \(s) seconds"
                        
                    }
                } else if !SchoolWillEndVar {
                    if h == 0 && m == 0 {
                        TimeDif = "\(nextPeriodText) begins in \(s) seconds"
                    } else if h == 0 {
                        TimeDif = "\(nextPeriodText) begins in \(m) minutes and \(s) seconds"
                    } else {
                        TimeDif = "\(nextPeriodText) begins in \(h) hours, \(m) minutes, and \(s) seconds"
                    }
                        
                }
                
                    
            }
                
        }
        
    }
    
    func GetDiffSeconds(stringXML: String) -> TimeInterval {
        let str = stringXML
        print(#line)
        Array = str.components(separatedBy: " ")
        if Array.count > 1 {
            xmlinfo.Finished = "\(ToDateArray), \(Array[1]), \(Array[2])"
            print(#line)
            
            let mydate = DateFormatter()
            mydate.dateFormat = "yyyy/MM/dd, hh:mm:ss, a"
            let weekform = DateFormatter()
            weekform.dateFormat = "EEEE"
            let BeginStrings = mydate.string(from: Date())
            print(#line)
            let beginning = mydate.date(from: BeginStrings)
            let ending = mydate.date(from: xmlinfo.Finished)
            let diffinSeconds = ending!.timeIntervalSinceReferenceDate - beginning!.timeIntervalSinceReferenceDate
            print(#line)
            
            return(diffinSeconds)
        } else {
        return -10 as TimeInterval
            }
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
        PeriodUntilTextFinished(xmlinfo: xmlinfo, onScreen: true)
        
    }
 }

