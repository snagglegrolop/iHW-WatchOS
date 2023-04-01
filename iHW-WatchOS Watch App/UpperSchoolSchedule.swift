//
//  UpperSchoolSchedule.swift
//  iHW-WatchOS Watch App
//
//  Created by Zachary Abrahamson  on 1/8/23.
//


import SwiftUI
import UserNotifications











struct UpperSchoolSchedule: View {
    
    
    
    let Gold = Color(red: 0.4627, green: 0.8392, blue: 1.0)
    
    @State private var showingAlert = false
    
    @State var PreviousDay = "Prior Day"
    @ObservedObject var usinfo: USINfo
    @State var NextDay = "Next Day"
    @State var showingForwardAlert = false
    let thisDate = Date()
    static var thisFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "eeee, MMM dd, yyyy"
        return df
    }
    
    
    var body: some View {
        VStack {
            Text("\(usinfo.USCounter == 0 ? "\(MiddleSchoolSchedule.thisFormatter.string(from: Date()))" : usinfo.DayDateLong)")
                .font(.system(size: 10))
            HStack {
                Button {
                    if usinfo.USCounter >= 1 {
                        usinfo.USCounter -= 1
                        usinfo.USgetInfo(futuredays: usinfo.USCounter) { success, error in
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
                    
                    usinfo.USgetInfo(futuredays: usinfo.USCounter) { success, error in
                        
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
                    print(usinfo.schoolEndDay[0], " = ", usinfo.DayDateLong)
                    guard usinfo.schoolEndDay[0] != usinfo.DayDateLong else {
                        NextDay = "Error"
                        showingForwardAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        NextDay = "Next Day"
                        }
                        return
                    }
                    usinfo.USCounter += 1
                    usinfo.USgetInfo(futuredays: usinfo.USCounter) { success, error in
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
                    Text(NextDay)
                        .font(.system(size: 15))
                }
                .alert("You've reached the last day of school!", isPresented: $showingForwardAlert) {
                    Button("OK", role: .cancel) { }
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
                        if !usinfo.isSentforWifi {
                            usinfo.USgetInfo(futuredays: usinfo.USCounter) { success, error in
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
                        
                        
                        if !usinfo.isSentforWifi {
                            USPeriodUntilTextFinished(usinfo: usinfo)
                                .padding(.horizontal, 20)
                        } else {
                            VStack(alignment: .center, spacing: -7) {
                                Text("\(usinfo.SchoolDayDescription)")
                                    .font(.system(size: RelativeWidth(CurrentWidth: 12)))
                                    .multilineTextAlignment(.center)
                                    .ignoresSafeArea()
                                    .padding(.horizontal)
                                Spacer()
                                    .frame(height: 17)
                                Divider().frame(width: RelativeWidth(CurrentWidth: 120))
                                
                                
                                if usinfo.USCounter == 0 {
                                    USPeriodUntilTextFinished(usinfo: usinfo)
                                } else if usinfo.USCounter > 0 {
                                    Spacer().frame(height: 15)
                                    Text("You are \(usinfo.USCounter) school days in the future")
                                        .font(.system(size: 15, weight: .bold))
                                        .padding(.horizontal, 1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.orange)
                                }
                                
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    
                    if usinfo.isSentforWifi {
                        Group {
                            ForEach(0..<usinfo.startTimesShort.count, id: \.self) { j in
                                USPeriodView(perName: usinfo.periodNames[j], perStart: usinfo.startTimesShort[j], perEnd: usinfo.endTimesShort[j])
                            }
                        }
                        
                    }
                    
                }
                
                .padding(.horizontal)
                
                
                
                
                
            }
        }
        
    }
    
}

struct USPeriodView: View {
    var perName: String
    var perStart: String
    var perEnd: String
    var body: some View {
        Text("\(perName)\n").bold() + Text("\(perStart) to \(perEnd)").font(.system(.footnote))
    }
}
struct USSView: View {
    @ObservedObject var usinfo = USINfo()
    var body: some View {
        UpperSchoolSchedule(usinfo: usinfo)
        
    }
}

struct UpperSchool_Previews: PreviewProvider {
    static var previews: some View {
        USSView()
    }
}
