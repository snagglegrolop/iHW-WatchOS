//
//  MiddleSchoolSchedule.swift
//  iHW-WatchOS Watch App
//
//  Created by Zachary Abrahamson  on 1/8/23.
//



import SwiftUI
import UserNotifications

extension Color {
    static let purp = Color(red: 109 / 255, green: 175 / 255, blue: 199 / 255)
}


extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}


extension String {
    func convertToNextDate(dateFormat: String, validity: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let myDate = dateFormatter.date(from: self)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: validity, to: myDate)
        return dateFormatter.string(from: tomorrow!)
    }
}



struct MiddleSchoolSchedule: View {
    
    
    
    let Gold = Color(red: 0.4627, green: 0.8392, blue: 1.0)
    
    @State private var showingAlert = false
    
    @State var PreviousDay = "Prior Day"
    @ObservedObject var xmlinfo: XMLInfo
    
    
    let thisDate = Date()
    static var thisFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "eeee, MMM dd, yyyy"
        return df
    }
    
    
    var body: some View {
        VStack {
            Text("\(xmlinfo.MScounter == 0 ? "\(MiddleSchoolSchedule.thisFormatter.string(from: Date()))" : xmlinfo.DayDateLong)")
                .font(.system(size: 10))
            HStack {
                Button {
                    if xmlinfo.MScounter >= 1 {
                        xmlinfo.MScounter -= 1
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
                    } else {
                        PreviousDay = "Error"
                        showingAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            PreviousDay = "Prior Day"
                        }
                        
                    }
                    
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

                } label: {
                    Text(PreviousDay)
                        .font(.system(size: 15))
                    
                    
                }
                .alert("You can't go back further than today.", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                    
                }
                Divider().frame(height: RelativeWidth(CurrentWidth: 20))
                
                Button {
                    xmlinfo.MScounter += 1
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
                } label: {
                    Text("Next Day")
                        .font(.system(size: 15))
                }    
            }
            
            Spacer()
                .frame(height: RelativeWidth(CurrentWidth: 5))
          
            VStack(alignment: .center, spacing: -3) {
                Divider().frame(width: RelativeWidth(CurrentWidth: 140))
                
                
                
                Spacer()
                    .frame(height: RelativeWidth(CurrentWidth: 5))
                List {
                    
                    Button {
                        if !xmlinfo.isSentforWifi {
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
                    } label: {
                        
                        
                        if !xmlinfo.isSentforWifi {
                            PeriodUntilTextFinished(xmlinfo: xmlinfo)
                                .padding(.horizontal, 20)
                        } else {
                            VStack(alignment: .center, spacing: -7) {
                                Text("\(xmlinfo.SchoolDayDescription)")
                                    .font(.system(size: RelativeWidth(CurrentWidth: 12)))
                                    .multilineTextAlignment(.center)
                                    .ignoresSafeArea()
                                    .padding(.horizontal)
                                Spacer()
                                    .frame(height: 17)
                                Divider().frame(width: RelativeWidth(CurrentWidth: 120))
                                
                                
                                if xmlinfo.MScounter == 0 {
                                    PeriodUntilTextFinished(xmlinfo: xmlinfo)
                                } else if xmlinfo.MScounter > 0 {
                                    Spacer().frame(height: 15)
                                    Text("You are \(xmlinfo.MScounter) school days in the future")
                                        .font(.system(size: 15, weight: .bold))
                                        .padding(.horizontal, 1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.orange)
                                }
                                
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    
                    if xmlinfo.isSentforWifi {
                        Group {
                        PeriodView(perName: xmlinfo.Per1_Per, perStart: xmlinfo.Per1_StartTime, perEnd: xmlinfo.Per1_EndTime)
                        PeriodView(perName: xmlinfo.Per2_Per, perStart: xmlinfo.Per2_StartTime, perEnd: xmlinfo.Per2_EndTime)
                        PeriodView(perName: xmlinfo.Break_Per, perStart: xmlinfo.Break_StartTime, perEnd: xmlinfo.Break_EndTime)
                        PeriodView(perName: xmlinfo.Per3_Per, perStart: xmlinfo.Per3_StartTime, perEnd: xmlinfo.Per3_EndTime)
                        PeriodView(perName: xmlinfo.Per4_Per, perStart: xmlinfo.Per4_StartTime, perEnd: xmlinfo.Per4_EndTime)
                        PeriodView(perName: xmlinfo.Per5_Per, perStart: xmlinfo.Per5_StartTime, perEnd: xmlinfo.Per5_EndTime)
                        PeriodView(perName: xmlinfo.Per6_Per, perStart: xmlinfo.Per6_StartTime, perEnd: xmlinfo.Per6_EndTime)
                        PeriodView(perName: xmlinfo.Per7_Per, perStart: xmlinfo.Per7_StartTime, perEnd: xmlinfo.Per7_EndTime)
                        PeriodView(perName: xmlinfo.Per8_Per, perStart: xmlinfo.Per8_StartTime, perEnd: xmlinfo.Per8_EndTime)
                        PeriodView(perName: xmlinfo.Per9_Per, perStart: xmlinfo.Per9_StartTime, perEnd: xmlinfo.Per9_EndTime)
                    }
                    
                }
            
                    }
                
                .padding(.horizontal)
                
                
                
            }
            
        }

        
    }
    
}

struct PeriodView: View {
    var perName: String
    var perStart: String
    var perEnd: String
    var body: some View {
        Text("\(perName)\n").bold() + Text("\(perStart) to \(perEnd)").font(.system(.footnote))
    }
}
struct MSSView: View {
    @ObservedObject var xmlinfo = XMLInfo()
    var body: some View {
        MiddleSchoolSchedule(xmlinfo: xmlinfo)
        
    }
}

struct MiddleSchool_Previews: PreviewProvider {
    static var previews: some View {
        MSSView()
    }
}
