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
    func thisFormatter() -> Date? {
        
        let df = DateFormatter()
        df.dateFormat = "eeee, MMMM d, yyyy"
        let pacificTimeZone = TimeZone(identifier: "America/Los_Angeles")!
        df.timeZone = pacificTimeZone
        let date = df.date(from: self)
            
        return date
    }
}

extension Bool {
    static func ^ (left: Bool, right: Bool) -> Bool {
        return left != right
    }
}

struct MiddleSchoolSchedule: View {
    
    
    
    @State private var tintColorPrior: Color = .white
    @State private var tintColorNext: Color = .white
    
    let Gold = Color(red: 0.4627, green: 0.8392, blue: 1.0)
    
    @State private var showingAlert = false
    @State private var showingForwardAlert = false
    @State private var PreviousDay = "Prior Day"
    @State private var NextDay = "Next Day"
    @EnvironmentObject var xmlinfo: XMLInfo
    
    static var thisFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "eeee, MMMM d, yyyy"
        return df
    }
    
    func GetDiffDays() -> Int {
        
        return Calendar.current.dateComponents([.day], from: Date(), to: xmlinfo.lookingDate).day! + 1

    }
    
    
    func CanChangeDayCheck(check: Int) -> Bool {
        return xmlinfo.allDayDateLongs.contains(MiddleSchoolSchedule.thisFormatter.string(from: Calendar.current.date(byAdding: .day, value: 0, to: xmlinfo.lookingDate)!)) || ((xmlinfo.allDayDateLongs.contains(MiddleSchoolSchedule.thisFormatter.string(from: Calendar.current.date(byAdding: .day, value: check, to: xmlinfo.lookingDate)!)) && !xmlinfo.allDayDateLongs.contains(MiddleSchoolSchedule.thisFormatter.string(from: xmlinfo.lookingDate))) && (MiddleSchoolSchedule.thisFormatter.string(from: Calendar.current.date(byAdding: .day, value: check, to: xmlinfo.lookingDate)!) != xmlinfo.DayDateLong))
    }
    
    private func longPressPrior() {
        if xmlinfo.MScounter != 0 {
            xmlinfo.MScounter = 0
            xmlinfo.lookingDate = Date()

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
                    xmlinfo.isSentforWifi = false
                    print("Failed to parse XML data.")
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
    }
    private func tapPressPrior() {
        if xmlinfo.MScounter >= 1 {
            if CanChangeDayCheck(check: -1) {

            
            xmlinfo.MScounter -= 1
                xmlinfo.MSgetInfo(futuredays: xmlinfo.MScounter) { success, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        xmlinfo.isSentforWifi = false
                        return
                    }
                    
                    if success {
                        // Do something with the parsed XML data
                        print("XML data parsed successfully!")
                        xmlinfo.lookingDate = Calendar.current.date(byAdding: .day, value: -1, to: xmlinfo.lookingDate)!

                    } else {
                        xmlinfo.isSentforWifi = false
                        print("Failed to parse XML data.")
                    }
                }
            } else {
                xmlinfo.lookingDate = Calendar.current.date(byAdding: .day, value: -1, to: xmlinfo.lookingDate)!
            }
        } else {
            if MiddleSchoolSchedule.thisFormatter.string(from: Date()) != MiddleSchoolSchedule.thisFormatter.string(from: xmlinfo.lookingDate) {
                xmlinfo.lookingDate = Calendar.current.date(byAdding: .day, value: -1, to: xmlinfo.lookingDate)!
            } else {
                PreviousDay = "Error"
                showingAlert = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    PreviousDay = "Prior Day"
                }
            }
            
        }
    }
    private func longPressFuture() {
        guard xmlinfo.schoolEndDay[0] != MiddleSchoolSchedule.thisFormatter.string(from: xmlinfo.lookingDate) else {
            
            tintColorNext = .orange
            NextDay = "Error"
            showingForwardAlert = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                
                NextDay = "Next Day"
                tintColorNext = .white
                
            }
            
            return
        }
            xmlinfo.MScounter = xmlinfo.CalendarID.count - 1
            
                xmlinfo.MSgetInfo(futuredays: xmlinfo.CalendarID.count - 1) { success, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        xmlinfo.isSentforWifi = false
                        return
                    }
                    
                    if success {
                        // Do something with the parsed XML data
                        print("XML data parsed successfully!")
                        xmlinfo.lookingDate = xmlinfo.schoolEndDately

                    } else {
                        xmlinfo.isSentforWifi = false
                        print("Failed to parse XML data.")
                    }
                }
            
                withAnimation {
                    tintColorNext = .red
                }
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    tintColorNext = .white
                }
    }
    private func tapPressFuture() {
        guard xmlinfo.schoolEndDay[0] != MiddleSchoolSchedule.thisFormatter.string(from: xmlinfo.lookingDate) else {
            NextDay = "Error"
            showingForwardAlert = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            NextDay = "Next Day"
            }
            return
        }
        
        if CanChangeDayCheck(check: 1) {

        
        xmlinfo.MScounter += 1
            xmlinfo.MSgetInfo(futuredays: xmlinfo.MScounter) { success, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    xmlinfo.isSentforWifi = false
                    return
                }
                
                if success {
                    // Do something with the parsed XML data
                    xmlinfo.lookingDate = Calendar.current.date(byAdding: .day, value: 1, to: xmlinfo.lookingDate)!
                    
                    print("XML data parsed successfully!")
                } else {
                    print("Failed to parse XML data.")
                    xmlinfo.isSentforWifi = false
                }
            }
        } else {
            xmlinfo.lookingDate = Calendar.current.date(byAdding: .day, value: 1, to: xmlinfo.lookingDate)!
        }
        
    }
    
    var body: some View {
        
        VStack {
            Text("Today is \(MiddleSchoolSchedule.thisFormatter.string(from: Date()))")
                .font(.system(size: 8))
            Text("Displayed: \(MiddleSchoolSchedule.thisFormatter.string(from: xmlinfo.lookingDate))")
                .font(.system(size: 8))
                
            
            
            HStack {
                Button {
                    
                    
                    
                } label: {
                    Text(PreviousDay)
                        .font(.system(size: 13))
                    
                    
                }
                .tint(tintColorPrior)
                
                
                
                .simultaneousGesture(LongPressGesture().onEnded { _ in
                    longPressPrior()
                })
                
                
                .simultaneousGesture(TapGesture().onEnded { _ in
                    tapPressPrior()
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
                    longPressFuture()
                        
                    
                })
                
                .simultaneousGesture(TapGesture().onEnded { _ in
                   tapPressFuture()
                    
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
                        if !xmlinfo.isSentforWifi {
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
                            
                        }
                    } label: {
                        
                        if !xmlinfo.isSentforWifi {
                            VStack(spacing: -7) {
                                
                                Text("                                                                                             ")
                                    .font(.system(size: 10))
                                PeriodUntilTextFinished()
                            }
                        } else {
                            ZStack {
                                HStack {
                                    VStack(spacing: -7) {
                                        Text("\(xmlinfo.allDayDateLongs.contains(MiddleSchoolSchedule.thisFormatter.string(from: xmlinfo.lookingDate)) ? xmlinfo.SchoolDayDescription : xmlinfo.lookingDate.dayOfWeek()!)")
                                            .font(.system(size: RelativeWidth(CurrentWidth: 12)))
                                            .multilineTextAlignment(.center)
                                            .ignoresSafeArea()
                                        Spacer()
                                            .frame(height: 17)
                                        Divider().frame(width: RelativeWidth(CurrentWidth: 120))
                                        if xmlinfo.MScounter == 0 && MiddleSchoolSchedule.thisFormatter.string(from: Date()) != xmlinfo.DayDateLong && GetDiffDays() <= 0 {
                                            Text("                                                    ")
                                                .font(.system(size: 15))
                                            Text("Waiting for the information to update.\nSystem normally updates around 8:00 AM, please check back later")
                                                .font(.system(size: 15, weight: .bold))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.yellow)
                                                .onTapGesture {
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
                                                }
                                                .onAppear() {
                                                    xmlinfo.updatedXML = false
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
                                                }
                                        } else if xmlinfo.MScounter == 0 && MiddleSchoolSchedule.thisFormatter.string(from: Date()) != xmlinfo.DayDateLong && GetDiffDays() == 1 {
                                            Text("                                                    ")
                                                .font(.system(size: 15))
                                            Text("The next school day is tomorrow")
                                                .font(.system(size: 15, weight: .bold))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.orange)
                                                .onAppear {
                                                    xmlinfo.updatedXML = true
                                                }
                                        } else
                                            if xmlinfo.MScounter == 0 && MiddleSchoolSchedule.thisFormatter.string(from: Date()) != MiddleSchoolSchedule.thisFormatter.string(from: xmlinfo.lookingDate) {
                                            
                                            Text("                                                    ")
                                                .font(.system(size: 15))
                                            Text("The next school day is in \(GetDiffDays()) days")
                                                .font(.system(size: 15, weight: .bold))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.orange)
                                                .onAppear {
                                                    xmlinfo.updatedXML = true
                                                }
                                            
                                        } else if xmlinfo.MScounter == 0 {
                                            Text("                                                    ")
                                                .font(.system(size: 15))
                                            PeriodUntilTextFinished()
                                                .onAppear {
                                                    xmlinfo.updatedXML = true
                                                }
                                        }
                                        
                                        else if xmlinfo.MScounter > 0 {
                                            Text("                                                    ")
                                                .font(.system(size: 15))
                                                .onAppear {
                                                    xmlinfo.updatedXML = true
                                                }
                                            
                                            if xmlinfo.schoolEndDay[0] == xmlinfo.DayDateLong {
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
                        }
                        
                        
                    }
                    .listRowBackground(Color.clear)
                    
                    if xmlinfo.isSentforWifi && xmlinfo.updatedXML {
                        
                        if !xmlinfo.allDayDateLongs.contains(MiddleSchoolSchedule.thisFormatter.string(from: xmlinfo.lookingDate)) {

                            if xmlinfo.lookingDate.dayOfWeek() == "Sunday" || xmlinfo.lookingDate.dayOfWeek() == "Saturday" {
                                Text("This day is a weekend! No school")
                                   
                                
                            } else {
                                
                                Text("No school during \(MiddleSchoolSchedule.thisFormatter.string(from: xmlinfo.lookingDate))")
                            }
                        } else {
                            Group {
                                
                                PeriodView(perName: xmlinfo.Per1_Per, perStart: xmlinfo.Per1_StartTime, perEnd: xmlinfo.Per1_EndTime, ClassName: xmlinfo.ClassesArray[Int(xmlinfo.CycleDay)! - 1][0])
                                    .listItemTint(xmlinfo.currentPeriodText == xmlinfo.Per1_Per ? (xmlinfo.lessThanFiveMinTrue ? Color.red : Color.purp) : nil)
                                PeriodView(perName: xmlinfo.Per2_Per, perStart: xmlinfo.Per2_StartTime, perEnd: xmlinfo.Per2_EndTime, ClassName: xmlinfo.ClassesArray[Int(xmlinfo.CycleDay)! - 1][1])
                                    .listItemTint(xmlinfo.currentPeriodText == xmlinfo.Per2_Per ? (xmlinfo.lessThanFiveMinTrue ? Color.red : Color.purp) : nil)
                                PeriodView(perName: xmlinfo.Break_Per, perStart: xmlinfo.Break_StartTime, perEnd: xmlinfo.Break_EndTime, ClassName: "Free")
                                    .listItemTint(xmlinfo.currentPeriodText == xmlinfo.Break_Per ? (xmlinfo.lessThanFiveMinTrue ? Color.red : Color.purp) : nil)
                                PeriodView(perName: xmlinfo.Per3_Per, perStart: xmlinfo.Per3_StartTime, perEnd: xmlinfo.Per3_EndTime, ClassName: xmlinfo.ClassesArray[Int(xmlinfo.CycleDay)! - 1][2])
                                    .listItemTint(xmlinfo.currentPeriodText == xmlinfo.Per3_Per ? (xmlinfo.lessThanFiveMinTrue ? Color.red : Color.purp) : nil)
                                PeriodView(perName: xmlinfo.Per4_Per, perStart: xmlinfo.Per4_StartTime, perEnd: xmlinfo.Per4_EndTime, ClassName: xmlinfo.ClassesArray[Int(xmlinfo.CycleDay)! - 1][3])
                                    .listItemTint(xmlinfo.currentPeriodText == xmlinfo.Per4_Per ? (xmlinfo.lessThanFiveMinTrue ? Color.red : Color.purp) : nil)
                                PeriodView(perName: xmlinfo.Per5_Per, perStart: xmlinfo.Per5_StartTime, perEnd: xmlinfo.Per5_EndTime, ClassName: xmlinfo.ClassesArray[Int(xmlinfo.CycleDay)! - 1][4])
                                    .listItemTint(xmlinfo.currentPeriodText == xmlinfo.Per5_Per ? (xmlinfo.lessThanFiveMinTrue ? Color.red : Color.purp) : nil)
                                PeriodView(perName: xmlinfo.Per6_Per, perStart: xmlinfo.Per6_StartTime, perEnd: xmlinfo.Per6_EndTime, ClassName: xmlinfo.ClassesArray[Int(xmlinfo.CycleDay)! - 1][5])
                                    .listItemTint(xmlinfo.currentPeriodText == xmlinfo.Per6_Per ? (xmlinfo.lessThanFiveMinTrue ? Color.red : Color.purp) : nil)
                                PeriodView(perName: xmlinfo.Per7_Per, perStart: xmlinfo.Per7_StartTime, perEnd: xmlinfo.Per7_EndTime, ClassName: xmlinfo.ClassesArray[Int(xmlinfo.CycleDay)! - 1][6])
                                    .listItemTint(xmlinfo.currentPeriodText == xmlinfo.Per7_Per ? (xmlinfo.lessThanFiveMinTrue ? Color.red : Color.purp) : nil)
                                PeriodView(perName: xmlinfo.Per8_Per, perStart: xmlinfo.Per8_StartTime, perEnd: xmlinfo.Per8_EndTime, ClassName: xmlinfo.ClassesArray[Int(xmlinfo.CycleDay)! - 1][7])
                                    .listItemTint(xmlinfo.currentPeriodText == xmlinfo.Per8_Per ? (xmlinfo.lessThanFiveMinTrue ? Color.red : Color.purp) : nil)
                                PeriodView(perName: xmlinfo.Per9_Per, perStart: xmlinfo.Per9_StartTime, perEnd: xmlinfo.Per9_EndTime, ClassName: xmlinfo.ClassesArray[Int(xmlinfo.CycleDay)! - 1][8])
                                    .listItemTint(xmlinfo.currentPeriodText == xmlinfo.Per9_Per ? (xmlinfo.lessThanFiveMinTrue ? Color.red : Color.purp) : nil)
                                
                            }
                        }
                    }
                    
                }
                
            }
                
                
            }
            
        }
    
        
    
    
}

struct PeriodView: View {
    var perName: String
    var perStart: String
    var perEnd: String
    var ClassName: String
    
    var body: some View {
        
        VStack {
            if ClassName == "Free" {
                
                Text("\(perName)\n").bold() + Text("\(perStart) to \(perEnd)").font(.system(.footnote))
                
            } else {
                Text("\(perName)\n").bold() + Text("\(perStart) to \(perEnd)").font(.system(.footnote)) + Text("\n\(ClassName)").foregroundColor(.brown).bold()
                
            }
            
            
        }
        
        
        
    }
}

//    @State private var hasTwoPeriods = false
    
    
    //    @AppStorage("ClassName") var ClassName = ""
    
//    @State private var ClassSequence: String = ""
//    @State private var ClassSequence2: String = ""
    
    //    @AppStorage private var ClassName: String
    //    @AppStorage private var ClassName2: String
    //    init(perName: String, perStart: String, perEnd: String) {
    //        self.perName = perName
    //        self.perStart = perStart
    //        self.perEnd = perEnd
    //        self._ClassName = AppStorage(wrappedValue: "", "Class\(perName)")
    //        self._ClassName2 = AppStorage(wrappedValue: "", "Class\(perName)2")
    //
    //    }

    

enum addingErrors: Error {
    case TooManyEntries
    case TooLittleEntries
    case AddedZerothClass
    case WrongCharacter
    case DoubleBlockWC
    case MissingTerm
    case UndefinedError
}
 
struct addMSClasses: View {
    @State private var isTappedButton = false
    func addToSchedule(classSequence: String, className: String) throws {
        let classSequenceArray = classSequence.components(separatedBy: ".")
        
        for i in 0..<classSequenceArray.count {
            
            // schedule day is what day of cycle
            // classSequenceArray[i] is the current period
            guard classSequenceArray.count == 6 else {
                if classSequenceArray.count > 6 {
                    
                    
                    throw addingErrors.TooManyEntries
                } else {
                    throw addingErrors.TooLittleEntries
                }
            }
            guard !classSequenceArray[i].contains("0") else {
                throw addingErrors.AddedZerothClass
                
            }
            
            guard classSequenceArray[i] != "" else {
                throw addingErrors.MissingTerm
            }
            if classSequenceArray[i] == "x" {
                
                
            } else if classSequenceArray[i].count == 1 {
                guard let _ = Int(classSequenceArray[i]) else {
                    throw addingErrors.WrongCharacter
                    
                }
                
                xmlinfo.ClassesArray[i][Int(classSequenceArray[i])! - 1] = className
            } else if classSequenceArray[i].count == 2 {
                
                guard let _ = Int(classSequenceArray[i]) else {
                    throw addingErrors.DoubleBlockWC
                    
                }
                let doubleBlock = classSequenceArray[i].map(String.init)
                if let oneB = Int(doubleBlock[0]), let twoB = Int(doubleBlock[1]) {
                    xmlinfo.ClassesArray[i][oneB - 1] = className
                    xmlinfo.ClassesArray[i][twoB - 1] = className
                    
                    
                    
                    
                    
                    
                    
                } else {
                    throw addingErrors.UndefinedError
                    
                }
            }
        }
    }
    
    @EnvironmentObject var xmlinfo: XMLInfo
    @State private var ClassName = ""
    @State private var ClassSequence = ""
    @State private var ErrorText = "Undefined Error"
    @State private var showingError = false
    @State private var showingResetClasses = false
    var body: some View {
        List {
            
            
            VStack {
                Text("Add your own classes to the schedule")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 13, weight: .semibold))
                    .padding(.bottom)
                
                
                Text("You will need your schedule sheet for this")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 12, weight: .semibold))
            }
            .listRowBackground(Color.clear)
            
            Text("Enter your class' name")
            TextField(text: $ClassName) {
                Text("e.g. \"Math\"")
            }
            Text("Enter your class's sequence")
            TextField(text: $ClassSequence) {
                Text("e.g. \"2.2.2.2.2.x\"")
            }
            
            Button {
                
                do {
                    try addToSchedule(classSequence: ClassSequence, className: ClassName)
                    
                    ClassName = ""
                    ClassSequence = ""
                    
                } catch addingErrors.MissingTerm {
                    ErrorText = "Missing a term in Class Sequence"
                    showingError = true
                } catch addingErrors.TooManyEntries {
                    ErrorText = "You added too many entries to Class Sequence"
                    showingError = true
                } catch addingErrors.TooLittleEntries {
                    ErrorText = "You added too little entries to Class Sequence"
                    showingError = true
                } catch addingErrors.DoubleBlockWC {
                    ErrorText = "The only characters allowed are \".\"'s, numbers 1-9 and \"x\"'s"
                    showingError = true
                } catch addingErrors.AddedZerothClass {
                    ErrorText = "There is no 0'th class"
                    showingError = true
                } catch addingErrors.WrongCharacter {
                    ErrorText = "The only characters allowed are \".\"'s, numbers 1-9 and \"x\"'s"
                    showingError = true
                } catch addingErrors.UndefinedError {
                    ErrorText = "Undefined Error"
                    showingError = true
                } catch {
                    ErrorText = "-Undefined Error-"
                    showingError = true
                }
                
                
                
                
            } label: {
                Text("Add to schedule")
                    .bold()
            }
            
            .listRowBackground(Color.clear)
            .alert(ErrorText, isPresented: $showingError) {
                Button("Retry", role: .cancel) { }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity) // how to make a button fill all the space available horizontaly
            .background(
                (ClassSequence == "" || ClassName == "") ?
                LinearGradient(colors: [.gray], startPoint: .topLeading, endPoint: .bottomTrailing) :
                    LinearGradient(colors: [Color.darkPink, .red, Color.darkPink], startPoint: .bottomLeading, endPoint: .topTrailing)
                
            )
            .cornerRadius(15)
            .disabled((ClassSequence == "" || ClassName == "")) // how to disable while some condition is applied
            .padding()
            .scaleEffect(!(ClassSequence == "" || ClassName == "") ? 1 : 0.8)
            .animation(.easeInOut(duration: 0.8), value: !(ClassSequence == "" || ClassName == ""))
            Button {
                showingResetClasses = true
                
            } label: {
                Text("Reset classes").font(.title3)
                Text("Click to reset").font(.footnote)
            }
            .disabled(false)
            .listItemTint(.red)
            .alert("Are you sure?", isPresented: $showingResetClasses) {
                Button("Yes", role: .destructive) {
                    xmlinfo.ClassesArray = [[String]](repeating: [String](repeating: "Free", count: 9), count: 6)
                }
            }
        }
        
    }
}
    



struct MSSView: View {
    @EnvironmentObject var xmlinfo: XMLInfo
    var body: some View {
        TabView {
            MiddleSchoolSchedule()
            addMSClasses()
                .environmentObject(xmlinfo)
                
        }
        
    }
}



struct MiddleSchool_Previews: PreviewProvider {
    static var previews: some View {
        MSSView().environmentObject(USINfo()).environmentObject(XMLInfo())
            
    }
}
