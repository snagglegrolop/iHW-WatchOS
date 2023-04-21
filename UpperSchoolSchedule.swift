//
//  UpperSchoolSchedule.swift
//  iHW-WatchOS Watch App
//
//  Created by Zachary Abrahamson  on 1/8/23.
//


import SwiftUI
import UserNotifications



struct UpperSchoolSchedule: View {
    
    @State private var tintColorPrior: Color = .white
    @State private var tintColorNext: Color = .white

    let Gold = Color(red: 0.4627, green: 0.8392, blue: 1.0)
    
    @State private var showingAlert = false
    @State private var isThereSchool = false
    @State private var PreviousDay = "Prior Day"
    @EnvironmentObject var usinfo: USINfo
    @State private var NextDay = "Next Day"
    @State private var showingForwardAlert = false
    static var thisFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "eeee, MMMM d, yyyy"
        return df
    }
    
    func CanChangeDayCheck(check: Int) -> Bool {
        return usinfo.allDayDateLongs.contains(UpperSchoolSchedule.thisFormatter.string(from: Calendar.current.date(byAdding: .day, value: 0, to: usinfo.lookingDate)!)) || ((usinfo.allDayDateLongs.contains(UpperSchoolSchedule.thisFormatter.string(from: Calendar.current.date(byAdding: .day, value: check, to: usinfo.lookingDate)!)) && !usinfo.allDayDateLongs.contains(UpperSchoolSchedule.thisFormatter.string(from: usinfo.lookingDate))) && (UpperSchoolSchedule.thisFormatter.string(from: Calendar.current.date(byAdding: .day, value: check, to: usinfo.lookingDate)!) != usinfo.DayDateLong))
    }
    @State private var lastCheckedSchool = ""
    
    func GetDiffDays() -> Int {
        
            return Calendar.current.dateComponents([.day], from: Date(), to: usinfo.lookingDate).day! + 1
        
    }
    var body: some View {
        withAnimation {
        VStack {
            
            
            Text("Today is \(UpperSchoolSchedule.thisFormatter.string(from: Date()))")
                .font(.system(size: 8))
            Text("Displayed: \(UpperSchoolSchedule.thisFormatter.string(from: usinfo.lookingDate))")
                .font(.system(size: 8))
                
            HStack {
                Button {
                    
                } label: {
                    Text(PreviousDay)
                        .font(.system(size: 13))
                    
                    
                }
                
                .tint(tintColorPrior)
                .simultaneousGesture(LongPressGesture().onEnded { _ in
                    if usinfo.USCounter != 0 {
                        lastCheckedSchool = ""
                        usinfo.USCounter = 0
                        usinfo.lookingDate = Date()
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
                        withAnimation {
                            tintColorPrior = .green
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            tintColorPrior = .white
                        }
                    } else {
                        tintColorPrior = .red
                        PreviousDay = "Error"
                        showingAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            PreviousDay = "Prior Day"
                            tintColorPrior = .white
                        }
                    }
                })
                
                
                .simultaneousGesture(TapGesture().onEnded { _ in
                    
                    if usinfo.USCounter >= 1 {
                        

                        
                            if CanChangeDayCheck(check: -1) {
                            
    
                                
                                
                                usinfo.USCounter -= 1
                        
                                usinfo.USgetInfo(futuredays: usinfo.USCounter) { success, error in
                                    if let error = error {
                                        print("Error: \(error.localizedDescription)")
                                        usinfo.isSentforWifi = false
                                        return
                                    }
                                    
                                    if success {
                                        // Do something with the parsed XML data
                                        print("XML data parsed successfully!")
                                        usinfo.lookingDate = Calendar.current.date(byAdding: .day, value: -1, to: usinfo.lookingDate)!

                                    } else {
                                        print("Failed to parse XML data.")
                                        usinfo.isSentforWifi = false
                                        
                                    }
                            }

                        } else {
                            usinfo.lookingDate = Calendar.current.date(byAdding: .day, value: -1, to: usinfo.lookingDate)!
                        }
                    } else {
                        if UpperSchoolSchedule.thisFormatter.string(from: Date()) != UpperSchoolSchedule.thisFormatter.string(from: usinfo.lookingDate) {
                            usinfo.lookingDate = Calendar.current.date(byAdding: .day, value: -1, to: usinfo.lookingDate)!
                        } else {
                            PreviousDay = "Error"
                            showingAlert = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                PreviousDay = "Prior Day"
                            }
                            
                        }
                    }
                })
                
                
                .alert("You can't go back further than today.", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                        
                    
                    
                }
                
                Divider().frame(height: RelativeWidth(CurrentWidth: 20))
                    
                
                Button {
                    
                } label: {
                    Text(NextDay)
                        .font(.system(size: 13))
                }
                .tint(tintColorNext)
                
                .simultaneousGesture(LongPressGesture().onEnded { _ in
                    guard usinfo.schoolEndDay[0] != usinfo.DayDateLong else {
                        
                        tintColorNext = .orange
                        NextDay = "Error"
                        showingForwardAlert = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            
                            NextDay = "Next Day"
                            tintColorNext = .white
                            
                        }
                        
                        return
                    }
                        usinfo.USCounter = usinfo.CalendarID.count - 1
                            usinfo.USgetInfo(futuredays: usinfo.CalendarID.count - 1) { success, error in
                                if let error = error {
                                    print("Error: \(error.localizedDescription)")
                                    usinfo.isSentforWifi = false
                                    return
                                }

                                if success {
                                    // Do something with the parsed XML data
                                    print("XML data parsed successfully!")
                                    usinfo.lookingDate = usinfo.schoolEndDately
                                } else {
                                    print("Failed to parse XML data.")
                                    usinfo.isSentforWifi = false
                                }
                            }
                        
                            withAnimation {
                                tintColorNext = .red
                            }
                        
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                tintColorNext = .white
                            }
                        
                    
                }
                )
                
                .simultaneousGesture(TapGesture().onEnded { _ in
                    guard usinfo.schoolEndDay[0] != UpperSchoolSchedule.thisFormatter.string(from: usinfo.lookingDate) else {
                        NextDay = "Error"
                        showingForwardAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        NextDay = "Next Day"
                        }
                        return
                    }
                        
                    if CanChangeDayCheck(check: 1) {

       
            usinfo.USCounter += 1
        
        
        usinfo.USgetInfo(futuredays: usinfo.USCounter) { success, error in
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                                usinfo.isSentforWifi = false
                                return
                            }
                            
                            if success {
                                // Do something with the parsed XML data
                                usinfo.lookingDate = Calendar.current.date(byAdding: .day, value: 1, to: usinfo.lookingDate)!
                                print("XML data parsed successfully!")
                            } else {
                                print("Failed to parse XML data.")
                                usinfo.isSentforWifi = false
                            }
                        }
                    } else {
                        usinfo.lookingDate = Calendar.current.date(byAdding: .day, value: 1, to: usinfo.lookingDate)!

                    }
                }
                )
                
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
                            
                        }
                    } label: {
                        
                        
                        if !usinfo.isSentforWifi {
                            USPeriodUntilTextFinished()
                                .padding(.horizontal, 20)
                        } else {
                            VStack(spacing: -7) {
                                Text("\(usinfo.allDayDateLongs.contains(UpperSchoolSchedule.thisFormatter.string(from: usinfo.lookingDate)) ? usinfo.SchoolDayDescription : usinfo.lookingDate.dayOfWeek()!)")
                                    .font(.system(size: RelativeWidth(CurrentWidth: 12)))
                                    .multilineTextAlignment(.center)
                                    .ignoresSafeArea()
                                Spacer()
                                    .frame(height: 17)
                                Divider().frame(width: RelativeWidth(CurrentWidth: 120))
                                if usinfo.USCounter == 0 && UpperSchoolSchedule.thisFormatter.string(from: Date()) != usinfo.DayDateLong && GetDiffDays() == 0 {
                                    Text("                                                    ")
                                        .font(.system(size: 15))
                                    Text("Waiting for the information to update.\nSystem normally updates around 8:00 AM, please check back later")
                                        .font(.system(size: 15, weight: .bold))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.yellow)
                                        .onTapGesture {
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
                                        }
                                        .onAppear() {
                                            usinfo.updatedXML = false
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
                                        }
                                } else if usinfo.USCounter == 0 && UpperSchoolSchedule.thisFormatter.string(from: Date()) != usinfo.DayDateLong && GetDiffDays() == 1 {
                                    Text("                                                    ")
                                        .font(.system(size: 15))
                                    Text("The next school day is tomorrow")
                                        .font(.system(size: 15, weight: .bold))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.orange)
                                        .onAppear() {
                                            usinfo.updatedXML = true
                                        }
                                } else if usinfo.USCounter == 0 && UpperSchoolSchedule.thisFormatter.string(from: Date()) != usinfo.DayDateLong {
                                    
                                    Text("                                                    ")
                                        .font(.system(size: 15))
                                    Text("The next school day is in \(GetDiffDays()) days")
                                        .font(.system(size: 15, weight: .bold))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.orange)
                                        .onAppear() {
                                            usinfo.updatedXML = true
                                        }
                                    
                                    
                                } else if usinfo.USCounter == 0 {
                                    Text("                                                    ")
                                        .font(.system(size: 15))
                                    USPeriodUntilTextFinished()
                                        .onAppear() {
                                            usinfo.updatedXML = true
                                        }
                                }
                                
                                else if usinfo.USCounter > 0 {
                                    Text("                                                    ")
                                        .font(.system(size: 15))
                                        .onAppear() {
                                            usinfo.updatedXML = true
                                        }
                                    
                                    if usinfo.schoolEndDay[0] == UpperSchoolSchedule.thisFormatter.string(from: usinfo.lookingDate) {
                                        Text("The last school day is in \(GetDiffDays()) days")
                                            .font(.system(size: 15, weight: .bold))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.orange)
                                        
                                    } else {
                                        Text("You are \(GetDiffDays()) days in the future")
                                            .font(.system(size: 15, weight: .bold))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.orange)
                                    }
                                }
                                
                                
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    
                    
                    if usinfo.isSentforWifi && usinfo.updatedXML {
                        if !usinfo.allDayDateLongs.contains(UpperSchoolSchedule.thisFormatter.string(from: usinfo.lookingDate)) {

                            if usinfo.lookingDate.dayOfWeek() == "Sunday" || usinfo.lookingDate.dayOfWeek() == "Saturday" {
                                Text("This day is a weekend! No school")
                                   
                                
                            } else {
                                
                                Text("No school during \(UpperSchoolSchedule.thisFormatter.string(from: usinfo.lookingDate))")
                            }
                        } else {
                            Group {
                                ForEach(0..<usinfo.startTimesShort.count, id: \.self) { j in
                                    USPeriodView(perName: usinfo.periodNames[j], perStart: usinfo.startTimesShort[j], perEnd: usinfo.endTimesShort[j])
                                        .listItemTint(usinfo.currentPeriod == usinfo.periodNames[j] ? (usinfo.lessThanFiveMinTrue ? Color.red : Color.purp) : nil)
                                }
                            }
                        }
                        
                        
                    }
                    
                }
                
                
                
                
                
            }
            }
        }
        
        
    }
    
}

struct USPeriodView: View {
    @EnvironmentObject var usinfo: USINfo
    var perName: String
    var perStart: String
    var perEnd: String
    var body: some View {
//        if ClassName == "" {
        if usinfo.ClassesDict[perName] == "Free" || usinfo.ClassesDict[perName] == nil {
            Text("\(perName)\n").bold() + Text("\(perStart) to \(perEnd)").font(.system(.footnote))
//            
        } else {
//            
            Text("\(perName)\n").bold() + Text("\(perStart) to \(perEnd)").font(.system(.footnote)) + Text("\n\(usinfo.ClassesDict[perName] ?? "")").foregroundColor(.brown).bold()
//            
        }
    }
}



struct enterSpecificClass: View {
    
    
    @EnvironmentObject var usinfo: USINfo
    @State var blockName: String
    @State var isShowingNextView: Bool = false
    @State var isShowingNextAnim: Bool = false
    @State var classNameInd = ""
    
    
    
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    isShowingNextView.toggle()
                    
                }
                
                withAnimation(.spring().speed(2)) {
                    isShowingNextAnim = isShowingNextView
                }
//                    usinfo.ClassesDict[blockName] = "Free"
                
            } label: {
                
                HStack {
                    Text("\(blockName)")
                    
                    if usinfo.ClassesDict[blockName] != "Free" && usinfo.ClassesDict[blockName] != nil {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        
                    }
                    Spacer()
                        Image(systemName: "chevron.down")
//                        .rotationEffect(Angle(degrees: isShowingNextView ? -90 : 90))
                        .rotation3DEffect(Angle(degrees: isShowingNextView ? 180 : 0), axis: (x: 1, y: 0, z: 0))
                }
                
            }
            if isShowingNextView {
                TextField("Enter Class", text: $classNameInd)
                    .onSubmit {
                        withAnimation(.spring().speed(2)) {
                            usinfo.ClassesDict[blockName] = classNameInd
                        }
                    }
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity).combined(with: .scale(scale: 0.1)))
            }
        }
        .onAppear {
            classNameInd = usinfo.ClassesDict[self.blockName] ?? ""
        }
    }
    
}

struct changeUSClassesView: View {
    @EnvironmentObject var usinfo: USINfo
    var body: some View {
        VStack {
            ScrollView {
                Text("Add your classes here")
                    .fontWeight(.semibold)
                Text("Set class name to \"Free\" to reset individual class period")
                    .multilineTextAlignment(.center)
                    Divider()
                ForEach(usinfo.ClassesDict.sorted(by: <), id: \.key) { blockName, className in
                    enterSpecificClass(blockName: blockName)
                }
                Divider()
                Spacer()
                Button("Reset all classes") {
                }
                .tint(.red)
                .simultaneousGesture(TapGesture().onEnded {
                    for i in usinfo.ClassesDict.keys {
                        usinfo.ClassesDict[i] = "Free"
                        print()
                    }
                })

            }
        }
    }
}

struct USSView: View {
    @EnvironmentObject var usinfo: USINfo
    var body: some View {
        TabView {
            
            UpperSchoolSchedule()
            changeUSClassesView()
        }
        
    }
}

struct UpperSchool_Previews: PreviewProvider {
    static var previews: some View {
        USSView().environmentObject(USINfo()).environmentObject(XMLInfo())
    }
}
