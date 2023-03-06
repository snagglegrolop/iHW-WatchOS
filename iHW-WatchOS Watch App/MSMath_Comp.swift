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
            getNearestPeriod(repeats: onScreen)
            let date = Date()
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy/MM/dd"
            ToDateArray = dateformatter.string(from: date)
            if !onScreen {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    MSMakeNotifs()
                }
            }
            
            
        }
    }
    
    func MSMakeNotifs() {
        let currentTime = Date().timeIntervalSince1970

            if lastSchedRequestTime == 0 || !Calendar.current.isDate(Date(timeIntervalSince1970: lastSchedRequestTime), inSameDayAs: Date()) {
                print("IT IS A NEW DAY but for notifs")

                if !onScreen {
                    
                    let TUFiveArray = [xmlinfo.FirstTUFiveMNotif, xmlinfo.SecondTUFiveMNotif, xmlinfo.BreakTUFiveMNotif, xmlinfo.ThirdTUFiveMNotif, xmlinfo.FourthTUFiveMNotif, xmlinfo.FifthTUFiveMNotif, xmlinfo.SixthTUFiveMNotif, xmlinfo.SeventhTUFiveMNotif, xmlinfo.EigthTUFiveMNotif, xmlinfo.NinthTUFiveMNotif]
                    
                    for TimeUntil in TUFiveArray {
                        print(TimeUntil)
                        
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
                        
                        let content = UNMutableNotificationContent()
                        
                        content.title = "Five minutes until next period!"
                        content.body = "\(nextperiodNotif) is in 5 minutes"
                        print(nextperiodNotif)
                        content.sound = UNNotificationSound.default
                        
                        
                        
                        
                        // show this notification five seconds from now
                        if TimeUntil > 0.0 {
                            let identifier = UUID().uuidString
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeUntil, repeats: false)
                            
                            // choose a random identifier
                            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                            print(identifier)
                            // add our notification request
                            UNUserNotificationCenter.current().add(request) { (error) in
                                if let error = error {
                                    print("Error \(error.localizedDescription)")
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
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: repeats) { timer in
    
            if xmlinfo.DayDateLong == "Having trouble connecting to internet" {
                xmlinfo.MSgetInfo(futuredays: xmlinfo.MScounter)
            } else {
                var timersArray: [Double] = []
                let StartTimeArray = [xmlinfo.Per1_StartTimeLong, xmlinfo.Per2_StartTimeLong, xmlinfo.Break_StartTimeLong, xmlinfo.Per3_StartTimeLong, xmlinfo.Per4_StartTimeLong, xmlinfo.Per5_StartTimeLong, xmlinfo.Per6_StartTimeLong, xmlinfo.Per7_StartTimeLong, xmlinfo.Per8_StartTimeLong, xmlinfo.Per9_StartTimeLong, xmlinfo.Per9_EndTimeLong]
                for Starts in StartTimeArray {
                    let TimesArray = GetDiffSeconds(stringXML: Starts)
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
                
                
                if timersArray[0] >= 0.0 {
                    if timersArray[0] <= 300.0 {
                        xmlinfo.lessThanFiveMinTrue = true
                        
                        
                    } else if timersArray[0] > 300.0  {
                        xmlinfo.lessThanFiveMinTrue = false
                        
                    }
                    
                    
                    nextPeriod = xmlinfo.Per1_StartTimeLong
                    nextPeriodText = "Period 1"
                    
//                    print("Per1 is next")
                } else if timersArray[1] >= 0.0 {
                    if timersArray[1] <= 300.0 {
                        xmlinfo.lessThanFiveMinTrue = true
                        

                    } else if timersArray[1] > 300.0 {
                        xmlinfo.lessThanFiveMinTrue = false
                        
                        
                    }
                    nextPeriod = xmlinfo.Per2_StartTimeLong
                    nextPeriodText = "Period 2"
                    
//                    print("Per2 is next")
                } else if timersArray[2] >= 0.0 {
                    if timersArray[2] <= 300.0 {
                        xmlinfo.lessThanFiveMinTrue = true
                        

                    } else if timersArray[2] > 300.0 {
                        xmlinfo.lessThanFiveMinTrue = false
                        
                        
                    }
                    
                    nextPeriod = xmlinfo.Break_StartTimeLong
                    nextPeriodText = "Break"
                    
//                    print("Break is next")
                } else if timersArray[3] >= 0.0 {
                    if timersArray[3] <= 300.0 {
                        xmlinfo.lessThanFiveMinTrue = true
                        

                    } else if timersArray[3] > 300.0 {
                        xmlinfo.lessThanFiveMinTrue = false
                        
                        
                    }
                    nextPeriod = xmlinfo.Per3_StartTimeLong
                    nextPeriodText = "Period 3"
                    
//                    print("Per4 is next")
                } else if timersArray[4] >= 0.0 {
                    if timersArray[4] <= 300.0 {
                        xmlinfo.lessThanFiveMinTrue = true
                        

                    } else if timersArray[4] > 300.0 {
                        xmlinfo.lessThanFiveMinTrue = false
                        
                        
                    }
                    nextPeriod = xmlinfo.Per4_StartTimeLong
                    nextPeriodText = "Period 4"
                    
//                    print("Per5 is next")
                } else if timersArray[5] >= 0.0 {
                    if timersArray[5] <= 300.0 {
                        xmlinfo.lessThanFiveMinTrue = true
                        

                    } else if timersArray[5] > 300.0 {
                        xmlinfo.lessThanFiveMinTrue = false
                        
                        
                    }
                    nextPeriod = xmlinfo.Per5_StartTimeLong
                    nextPeriodText = "Period 5"
                    
//                    print("Per6 is next")
                } else if timersArray[6] >= 0.0 {
                    if timersArray[6] <= 300.0 {
                        xmlinfo.lessThanFiveMinTrue = true
                        

                    } else if timersArray[6] > 300.0 {
                        xmlinfo.lessThanFiveMinTrue = false
                        
                        
                    }
                    nextPeriod = xmlinfo.Per6_StartTimeLong
                    nextPeriodText = "Period 6"
                    
//                    print("Per7 is next")
                } else if timersArray[7] >= 0.0 {
                    if timersArray[7] <= 300.0 {
                        xmlinfo.lessThanFiveMinTrue = true
                        

                    } else if timersArray[7] > 300.0 {
                        xmlinfo.lessThanFiveMinTrue = false
                        
                        
                    }
                    nextPeriod = xmlinfo.Per7_StartTimeLong
                    nextPeriodText = "Period 7"
//                    print("Per8 is next")
                } else if timersArray[8] >= 0.0 {
                    if timersArray[8] <= 300.0 {
                        xmlinfo.lessThanFiveMinTrue = true
                        

                    } else if timersArray[8] > 300.0 {
                        xmlinfo.lessThanFiveMinTrue = false
                        
                        
                    }
                    nextPeriod = xmlinfo.Per8_StartTimeLong
                    nextPeriodText = "Period 8"
                    
//                    print("Per9 is next")
                } else if timersArray[9] >= 0.0 {
                    if timersArray[9] <= 300.0 {
                        xmlinfo.lessThanFiveMinTrue = true
                        

                    } else if timersArray[9] > 300.0 {
                        xmlinfo.lessThanFiveMinTrue = false
                        
                        
                    }
                    nextPeriod = xmlinfo.Per9_StartTimeLong
                    nextPeriodText = "Period 9"
//                    print("Per9End is next")
                } else if timersArray[10] >= 0.0 {
                    if timersArray[10] <= 300.0 {
                        xmlinfo.lessThanFiveMinTrue = true
                        

                    } else if timersArray[10] > 300.0 {
                        xmlinfo.lessThanFiveMinTrue = false
                        
                        
                    }
                    nextPeriod = xmlinfo.Per9_EndTimeLong
                    SchoolWillEndVar = true
                    nextPeriodText = "School"
//                    print("School ends next")
                } else if timersArray[10] <= 0.0 {
//                    print("school ended already")
                    xmlinfo.SchoolDidEndVar = true
                    SchoolWillEndVar = false
                    xmlinfo.lessThanFiveMinTrue = false
                    nextPeriod = xmlinfo.Per9_EndTimeLong
                    
                    
                    
                }
                if xmlinfo.lessThanFiveMinTrue {
                    
                    FiveMinColor = .red
                } else if !xmlinfo.lessThanFiveMinTrue {
                    FiveMinColor = .purp
                }
                
                
            }
            
            
            
            let (h,m,s) = secondsToHoursMinutesSeconds(Int(GetDiffSeconds(stringXML: nextPeriod)))
            if xmlinfo.SchoolDidEndVar {
                TimeDif = "School is over"
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
        Array = str.components(separatedBy: " ")
        xmlinfo.Finished = "\(ToDateArray), \(Array[1]), \(Array[2])"
        

        let mydate = DateFormatter()
        mydate.dateFormat = "yyyy/MM/dd, hh:mm:ss, a"
        let weekform = DateFormatter()
        weekform.dateFormat = "EEEE"
        let BeginStrings = mydate.string(from: Date())
        let beginning = mydate.date(from: BeginStrings)
        let ending = mydate.date(from: xmlinfo.Finished)
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
        PeriodUntilTextFinished(xmlinfo: xmlinfo, onScreen: true)
        
    }
 }

