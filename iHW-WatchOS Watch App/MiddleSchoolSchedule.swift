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
    
    
    
    @State var Per1_MS = false
    @State var Per2_MS = false
    @State var Break_MS = false
    @State var Per3_MS = false
    @State var Per4_MS = false
    @State var Per5_MS = false
    @State var Per6_MS = false
    @State var Per7_MS = false
    @State var Per8_MS = false
    @State var Per9_MS = false
    
    
    
    let Gold = Color(red: 0.4627, green: 0.8392, blue: 1.0)
    
    @State private var showingAlert = false
    
    @State var PreviousDay = "Prior Day"
    @ObservedObject var xmlinfo: XMLInfo
    
    var body: some View {
        NavigationView {
            
                TabView(selection: $xmlinfo.selectedTab) {
                    VStack {
                        WeekendView()
                    }
                    .tag("Weekend")
                    
                    VStack {
                        HolidayView()
                    }
                    .tag("Holiday")
                    VStack (spacing: -5) {
                        
                        if #available(watchOS 9.0, *) {
                            FluidStepper(xmlinfo: xmlinfo)
                        } else {
                            HStack {
                                 Button {
                                     if xmlinfo.MScounter >= 1 {
                                         xmlinfo.MScounter -= 1
                                     } else {
                                     PreviousDay = "Error"
                                         showingAlert = true
                                         DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                             PreviousDay = "Prior Day"
                                         }

                                     }
                                         
                                     xmlinfo.MSgetInfo(futuredays: xmlinfo.MScounter)
                                     
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
                                     xmlinfo.MSgetInfo(futuredays: xmlinfo.MScounter)

                                 } label: {
                                     Text("Next Day")
                                         .font(.system(size: 15))
                                 }
                                 
                                 
                                 
                             }
                            Spacer()
                               .frame(height: RelativeWidth(CurrentWidth: 15))
                        }
                        Divider().frame(width: RelativeWidth(CurrentWidth: 140))
                        
                        
                        Spacer()
                            .frame(height: RelativeWidth(CurrentWidth: 7))
                        List {
                            Group {
                                Button {
                                } label: {
                                    
                                    VStack(alignment: .center, spacing: -7) {
                                        Text("\(xmlinfo.DayDateLong), \(xmlinfo.SchoolDayDescription)")
                                            .font(.system(size: 15))
                                            .multilineTextAlignment(.center)
                                            .ignoresSafeArea()
                                        Spacer()
                                            .frame(height: 17)
                                        Divider().frame(width: RelativeWidth(CurrentWidth: 120))
                                            
                                        
                                        
                                        if xmlinfo.MScounter == 0 && !xmlinfo.SchoolDidEndVar {
                                            PeriodUntilTextFinished(xmlinfo: xmlinfo, onScreen: true)

                                        } else if xmlinfo.MScounter == 0 {
                                            PeriodUntilTextFinished(xmlinfo: xmlinfo, onScreen: true)

                                        }
                                        
                                        
                                        
                                    }
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listStyle(PlainListStyle())
                            Group {
//                                Group {
//                                NavigationLink(destination: Per1_Notes()) {
//                                    VStack {
//                                        Text("Period 1")
//                                        Text("\(xmlinfo.Per1_StartTime) to \(xmlinfo.Per1_EndTime)")
//                                            .font(.footnote)
//                                    }
//                                }
                                Button {
                                    Per1_MS = true
                                } label: {
                                    Text("Period 1")
                                    Text("\(xmlinfo.Per1_StartTime) to \(xmlinfo.Per1_EndTime)")
                                        .font(.footnote)
                                }
//                                }
                                Button {
                                    Per2_MS = true
                                } label: {
                                    Text("Period 2")
                                    Text("\(xmlinfo.Per2_StartTime) to \(xmlinfo.Per2_EndTime)")
                                        .font(.footnote)
                                }
                                Button {
                                    Break_MS = true
                                } label: {
                                    Text("Break")
                                    Text("\(xmlinfo.Break_StartTime) to \(xmlinfo.Break_EndTime)")
                                        .font(.footnote)
                                }
                                Button {
                                    Per3_MS = true
                                } label: {
                                    Text("Period 3")
                                    Text("\(xmlinfo.Per3_StartTime) to \(xmlinfo.Per3_EndTime)")
                                        .font(.footnote)
                                }
                                Button {
                                    Per4_MS = true
                                } label: {
                                    Text("Period 4")
                                    Text("\(xmlinfo.Per4_StartTime) to \(xmlinfo.Per4_EndTime)")
                                        .font(.footnote)
                                }
                                Button {
                                    Per5_MS = true
                                } label: {
                                    Text("Period 5")
                                    Text("\(xmlinfo.Per5_StartTime) to \(xmlinfo.Per5_EndTime)")
                                        .font(.footnote)
                                }
                                Button {
                                    Per6_MS = true
                                } label: {
                                    Text("Period 6")
                                    Text("\(xmlinfo.Per6_StartTime) to \(xmlinfo.Per6_EndTime)")
                                        .font(.footnote)
                                }
                                Button {
                                    Per7_MS = true
                                } label: {
                                    Text("Period 7")
                                    Text("\(xmlinfo.Per7_StartTime) to \(xmlinfo.Per7_EndTime)")
                                        .font(.footnote)
                                }
                                Button {
                                    Per8_MS = true
                                } label: {
                                    Text("Period 8")
                                    Text("\(xmlinfo.Per8_StartTime) to \(xmlinfo.Per8_EndTime)")
                                        .font(.footnote)
                                }
                                Button {
                                    Per9_MS = true
                                } label: {
                                    Text("Period 9")
                                    Text("\(xmlinfo.Per9_StartTime) to \(xmlinfo.Per9_EndTime)")
                                        .font(.footnote)
                                }
                            }
                            
                        }
                        
                    }
                    .tag("TodaySchoolDay")
                }
            }
            
        .onAppear { xmlinfo.MSgetInfo(futuredays: xmlinfo.MScounter) }
        
            
        }
        
    
}
struct Per1_Notes: View {
    @AppStorage("Per1Notes") private var Per1Notes = ""
    @State private var showingConfirmation = false

    var body: some View {
        VStack {
            
            Text("Reset Note")
                .onTapGesture {
                    showingConfirmation = true
                        
                }
                .confirmationDialog("Are you sure you want to reset the notes?", isPresented: $showingConfirmation) {
                    Button("Please Delete!") { Per1Notes = "" }
                    Button("Oops! Take me back please.") { }
                    } message: {
                        Text("You can't get this back")
                    }
                
            TextField("Notes", text: $Per1Notes)
        }
    }
}

struct Per2_Notes: View {
    @AppStorage("Per2Notes") private var Per2Notes = ""
    @State private var showingConfirmation = false

    var body: some View {
        VStack {
            
            Text("Reset Note")
                .onTapGesture {
                    showingConfirmation = true
                        
                }
                .confirmationDialog("Are you sure you want to reset the notes?", isPresented: $showingConfirmation) {
                    Button("Please Delete!") { Per2Notes = "" }
                    Button("Oops! Take me back please.") { }
                    } message: {
                        Text("You can't get this back")
                    }
                
            TextField("Notes", text: $Per2Notes)
        }
    }
}

struct Break_Notes: View {
    @AppStorage("Break_Notes") private var Break_Notes = ""
    @State private var showingConfirmation = false

    var body: some View {
        VStack {
            
            Text("Reset Note")
                .onTapGesture {
                    showingConfirmation = true
                        
                }
                .confirmationDialog("Are you sure you want to reset the notes?", isPresented: $showingConfirmation) {
                    Button("Please Delete!") { Break_Notes = "" }
                    Button("Oops! Take me back please.") { }
                    } message: {
                        Text("You can't get this back")
                    }
                
            TextField("Notes", text: $Break_Notes)
        }
    }
}

struct Per3_Notes: View {
    @AppStorage("Per3Notes") private var Per3Notes = ""
    @State private var showingConfirmation = false

    var body: some View {
        VStack {
            
            Text("Reset Note")
                .onTapGesture {
                    showingConfirmation = true
                        
                }
                .confirmationDialog("Are you sure you want to reset the notes?", isPresented: $showingConfirmation) {
                    Button("Please Delete!") { Per3Notes = "" }
                    Button("Oops! Take me back please.") { }
                    } message: {
                        Text("You can't get this back")
                    }
                
            TextField("Notes", text: $Per3Notes)
        }
    }
}

struct Per4_Notes: View {
    @AppStorage("Per4Notes") private var Per4Notes = ""
    @State private var showingConfirmation = false

    var body: some View {
        VStack {
            
            Text("Reset Note")
                .onTapGesture {
                    showingConfirmation = true
                        
                }
                .confirmationDialog("Are you sure you want to reset the notes?", isPresented: $showingConfirmation) {
                    Button("Please Delete!") { Per4Notes = "" }
                    Button("Oops! Take me back please.") { }
                    } message: {
                        Text("You can't get this back")
                    }
                
            TextField("Notes", text: $Per4Notes)
        }
    }
}

struct Per5_Notes: View {
    @AppStorage("Per5Notes") private var Per5Notes = ""
    @State private var showingConfirmation = false

    var body: some View {
        VStack {
            
            Text("Reset Note")
                .onTapGesture {
                    showingConfirmation = true
                        
                }
                .confirmationDialog("Are you sure you want to reset the notes?", isPresented: $showingConfirmation) {
                    Button("Please Delete!") { Per5Notes = "" }
                    Button("Oops! Take me back please.") { }
                    } message: {
                        Text("You can't get this back")
                    }
                
            TextField("Notes", text: $Per5Notes)
        }
    }
}

struct Per6_Notes: View {
    @AppStorage("Per6Notes") private var Per6Notes = ""
    @State private var showingConfirmation = false

    var body: some View {
        VStack {
            
            Text("Reset Note")
                .onTapGesture {
                    showingConfirmation = true
                        
                }
                .confirmationDialog("Are you sure you want to reset the notes?", isPresented: $showingConfirmation) {
                    Button("Please Delete!") { Per6Notes = "" }
                    Button("Oops! Take me back please.") { }
                    } message: {
                        Text("You can't get this back")
                    }
                
            TextField("Notes", text: $Per6Notes)
        }
    }
}

struct Per7_Notes: View {
    @AppStorage("Per7Notes") private var Per7Notes = ""
    @State private var showingConfirmation = false

    var body: some View {
        VStack {

            Text("Reset Note")
                .onTapGesture {
                    showingConfirmation = true
                        
                }
                .confirmationDialog("Are you sure you want to reset the notes?", isPresented: $showingConfirmation) {
                    Button("Please Delete!") { Per7Notes = "" }
                    Button("Oops! Take me back please.") { }
                    } message: {
                        Text("You can't get this back")
                    }
                
            TextField("Notes", text: $Per7Notes)
        }
    }
}

struct Per8_Notes: View {
    @AppStorage("Per8Notes") private var Per8Notes = ""
    @State private var showingConfirmation = false

    var body: some View {
        VStack {
            
            Text("Reset Note")
                .onTapGesture {
                    showingConfirmation = true
                        
                }
                .confirmationDialog("Are you sure you want to reset the notes?", isPresented: $showingConfirmation) {
                    Button("Please Delete!") { Per8Notes = "" }
                    Button("Oops! Take me back please.") { }
                    } message: {
                        Text("You can't get this back")
                    }
                
            TextField("Notes", text: $Per8Notes)
        }
    }
}

struct Per9_Notes: View {
    @AppStorage("Per9Notes") private var Per9Notes = ""
    @State private var showingConfirmation = false

    var body: some View {
        VStack {
            
            Text("Reset Note")
                .onTapGesture {
                    showingConfirmation = true
                        
                }
                .confirmationDialog("Are you sure you want to reset the notes?", isPresented: $showingConfirmation) {
                    Button("Please Delete!") { Per9Notes = "" }
                    Button("Oops! Take me back please.") { }
                    } message: {
                        Text("You can't get this back")
                    }
                
            TextField("Notes", text: $Per9Notes)
        }
    }
}

struct WeekendView: View {
    var body: some View {
        Text(Date.now, format: .dateTime.day().month().year())
            .font(.footnote)
        Text("Today is weekend. No regularly scheduled school!")
            .padding()
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
    }
}

struct HolidayView: View {
    var body: some View {
        Group {
            Text(Date.now, format: .dateTime.day().month().year())
                .font(.footnote)
            Text("It's a holiday. No regularly scheduled school!")
                .padding()
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
        }
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
