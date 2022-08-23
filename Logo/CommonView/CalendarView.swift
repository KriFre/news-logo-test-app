//
//  CalendarView.swift
//  Logo
//
//  Created by Kristaps Freibergs on 19/08/2022.
//

import SwiftUI

struct CalendarView: View {
    var title: String
    @Binding var displayTitle: String?
    @Binding var date: Date
    
    @State var showCalendar = false
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text(title)
                    .foregroundColor(Color.accentColor)
                    .smallFont()
                Spacer()
            }
            Button {
                withAnimation() {
                    showCalendar.toggle()
                }
            } label: {
                HStack {
                    Text(displayTitle ?? kNoDateDisplay)
                        .foregroundColor(displayTitle != nil ? Color.textColor : Color.inactiveTint)
                        .subtitleFont()
                    Spacer()
                    Image("Calendar")
                }
            }
            if (showCalendar) {
                DatePicker("Enter a date",
                           selection: $date,
                           in: ...Date.now,
                           displayedComponents: [.date])
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .frame(maxHeight: 200)
            }
            Divider().frame(height: SizeUtils.dividerHeight).overlay(Color.accentColor)
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        let displayTitle: Binding<String?> = Binding(get: {"1992-12-01"}, set: {_ in })
        let date: Binding<Date> = Binding(get: {Date.now}, set: {_ in })
        CalendarView(title: "From", displayTitle: displayTitle, date: date)
    }
}
