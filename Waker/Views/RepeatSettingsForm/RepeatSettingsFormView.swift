//
//  RepeatSettingsFormView.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/7.
//

import SwiftUI
import RealmSwift

struct RepeatSettingsFormView: View {
    let weeks = Array(0...6)
    @Binding var repeatSettings: RepeatSettings
    let selections: Binding<Set<Int>>
    
    init(repeatSettings: Binding<RepeatSettings>) {
        self._repeatSettings = repeatSettings
        self.selections = Binding<Set<Int>> {
            return Set(repeatSettings.wrappedValue.weeks)
        } set: { selections in
            repeatSettings.weeks.wrappedValue = selections.sorted()
        }
    }
    
    var body: some View {
        List(weeks, id: \.self, selection: selections) { week in
            let isSelected = Binding<Bool>(
                get: {
                    return repeatSettings.weeks.contains(week)
                },
                set: { isSelected in
                    if isSelected {
                        selections.wrappedValue.insert(week)
                    } else {
                        selections.wrappedValue.remove(week)
                    }
                }
            )
            
            WeekRow(week: week, isSelected: isSelected)
        }
        .listStyle(GroupedListStyle())
    }
}

struct WeekRow: View {
    let week: Int
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            Text(Calendar.current.weekdaySymbols[week])
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isSelected = !isSelected
        }
    }
}

struct RepeatSettingsFormView_Previews: PreviewProvider {
    static var previews: some View {
        RepeatSettingsFormView(repeatSettings: Binding<RepeatSettings>(get: { RepeatSettings(weeks: Array(0...4)) }, set: { _ in }))
    }
}
