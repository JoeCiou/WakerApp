//
//  AlarmsView.swift
//  Waker
//
//  Created by Joe Ciou on 2021/5/27.
//

import SwiftUI
import RealmSwift

private class AlarmSheetData: Identifiable {
    var editTarget: Alarm?
    
    init(editTarget: Alarm? = nil) {
        self.editTarget = editTarget
    }
}

private class RegularAlarmSheetData: Identifiable {
    var editTarget: RegularAlarm?
    
    init(editTarget: RegularAlarm? = nil) {
        self.editTarget = editTarget
    }
}

struct AlarmsView: View {
    @ObservedObject var viewModel: AlarmsViewModel
    @State private var alarmSheetData: AlarmSheetData? = nil
    
    @Environment(\.editMode) private var editMode: Binding<EditMode>?
    
    var body: some View {
        NavigationView {
            List {
                // Next alarms
                // Enabled regular alarms
                // Disabled regular alarms
                ForEach(viewModel.alarms) { alarm in
                    AlarmRow(alarm: alarm, action: {
                        if editMode!.wrappedValue == EditMode.active {
                            alarmSheetData = AlarmSheetData(editTarget: alarm)
                        }
                    })
                }.onDelete(perform: { indexSet in
                    viewModel.deleteAlarm(at: indexSet)
                })
            }
            .environment(\.editMode, editMode)
            .animation(.spring())
            .navigationTitle("鬧鐘")
            .navigationBarItems(
                leading: Button(action: {
                    editMode!.wrappedValue = editMode!.wrappedValue.isEditing ? EditMode.inactive: EditMode.active
                }) {
                    Text(editMode!.wrappedValue.isEditing ? "完成": "編輯")
                },
                trailing: Button(action: {
                    alarmSheetData = AlarmSheetData()
                }) {
                    Image(systemName: "plus")
                }
            )
        }
        .sheet(item: $alarmSheetData) { sheetData in
            AlarmFormView(viewModel: AlarmFormViewModel(editTarget: sheetData.editTarget))
        }
//        .sheet(isPresented: $isAlarmFormPresented) {
//            AlarmFormView(viewModel: AlarmFormViewModel())
//        }
    }
}

struct AlarmRow: View {
    var alarm: Alarm
    let action: () -> Void
    
    @Environment(\.editMode) private var editMode: Binding<EditMode>?
    
    var body: some View {
        if alarm.isInvalidated {
            EmptyView()
        } else {
            let content = VStack(alignment: .leading) {
                Text(TimeUtils.getTimeString(hour: alarm.hour, minute: alarm.minute))
                    .font(.largeTitle)
                Text(alarm.remark)
                    .font(.subheadline)
            }
            
            HStack {
                content
                Spacer()
                ZStack(alignment: .trailing) {
//                    Toggle("", isOn: $alarm.isOn)
//                        .opacity(editMode!.wrappedValue.isEditing ? 0: 1)
                    Image(systemName: "chevron.forward").opacity(0.2)
                        .opacity(editMode!.wrappedValue == EditMode.active ? 1: 0)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: action)
        }
    }
}

struct AlarmsView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmsView(viewModel: AlarmsViewModel(repository: AlarmMockRepository()))
            .environment(\.editMode, Binding.constant(EditMode.inactive))
    }
}
