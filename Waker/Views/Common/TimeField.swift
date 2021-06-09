//
//  TimeField.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/7.
//

import SwiftUI

struct TimeField: View {
    @Binding var hour: Int
    @Binding var minute: Int
    
    var body: some View {
        HStack() {
            Text("時間").font(.headline)
            Spacer()
            DatePicker("", selection: Binding<Date>(
                get: { DateComponents(calendar: Calendar.current, hour: hour, minute: minute).date! },
                set: {
                    hour = Calendar.current.component(.hour, from: $0)
                    minute = Calendar.current.component(.minute, from: $0)
                }
            ), displayedComponents: .hourAndMinute)
            .datePickerStyle(GraphicalDatePickerStyle())
        }
        .frame(minHeight: 100, alignment: .center)
    }
}

struct TimeField_Previews: PreviewProvider {
    static var previews: some View {
        TimeField(hour: Binding<Int>(get: { 10 }, set: { _ in }), minute: Binding<Int>(get: { 30 }, set: { _ in }))
    }
}
