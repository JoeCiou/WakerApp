//
//  AlarmsView.swift
//  Waker
//
//  Created by Joe Ciou on 2021/5/27.
//

import SwiftUI
import RealmSwift

private class CommonAlarmSheetData: Identifiable {
    var editTarget: CommonAlarm?
    
    init(editTarget: CommonAlarm? = nil) {
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
    @State private var commonAlarmSheetData: CommonAlarmSheetData? = nil
    @State private var regularAlarmSheetData: RegularAlarmSheetData? = nil
    
    @Environment(\.editMode) private var editMode: Binding<EditMode>?
    
    var body: some View {
        NavigationView {
            List {
                // Next alarms
                Section(header: AlarmHeader(title: "即將到來")) {
                    ForEach(viewModel.upcomingAlarms) { alarm in
                        switch alarm {
                        case .common(let commonAlarm):
                            AlarmRow(alarm: alarm, isOn: Binding<Bool>(get: { !commonAlarm.isInvalidated }, set: { _ in viewModel.deleteAlarm(alarm) }), action: {
                                if editMode!.wrappedValue == EditMode.active {
                                    commonAlarmSheetData = CommonAlarmSheetData(editTarget: commonAlarm)
                                }
                            })
                        case .regular(let regularAlarm):
                            AlarmRow(alarm: alarm, isOn: Binding<Bool>(get: { regularAlarm.isOn }, set: { _ in viewModel.switchRegularAlarm(regularAlarm) }), action: {
                                if editMode!.wrappedValue == EditMode.active {
                                    regularAlarmSheetData = RegularAlarmSheetData(editTarget: regularAlarm)
                                }
                            })
                        }
                    }.onDelete(perform: { indexSet in
                        viewModel.deleteUpcomingAlarms(at: indexSet)
                    })
                }
                // Regular alarms
                Section(header: AlarmHeader(title: "固定鬧鐘")) {
                    ForEach(viewModel.regularAlarms) { regularAlarm in
                        AlarmRow(alarm: Alarm.regular(regularAlarm), isOn: Binding<Bool>(get: { regularAlarm.isOn }, set: { _ in viewModel.switchRegularAlarm(regularAlarm) }), action: {
                            if editMode!.wrappedValue == EditMode.active {
                                regularAlarmSheetData = RegularAlarmSheetData(editTarget: regularAlarm)
                            }
                        })
                    }.onDelete(perform: { indexSet in
                        viewModel.deleteRegularAlarms(at: indexSet)
                    })
                }
            }
            .environment(\.editMode, editMode)
            .animation(.spring())
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("鬧鐘")
            .navigationBarItems(
                leading: Button(action: {
                    editMode!.wrappedValue = editMode!.wrappedValue.isEditing ? EditMode.inactive: EditMode.active
                }) {
                    Text(editMode!.wrappedValue.isEditing ? "完成": "編輯")
                },
                trailing: Menu(content: {
                    Button("一次性鬧鐘") {
                        commonAlarmSheetData = CommonAlarmSheetData()
                    }
                    Button("固定鬧鐘") {
                        regularAlarmSheetData = RegularAlarmSheetData()
                    }
                }) {
                    Image(systemName: "plus")
                }
            )
        }
        .sheet(item: $commonAlarmSheetData) { sheetData in
            CommonAlarmFormView(viewModel: CommonAlarmFormViewModel(editTarget: sheetData.editTarget))
        }
        .sheet(item: $regularAlarmSheetData) { sheetData in
            RegularAlarmFormView(viewModel: RegularAlarmFormViewModel(editTarget: sheetData.editTarget))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            // It will still be called before the view hasn't appeared: https://developer.apple.com/forums/thread/656655
            viewModel.connectDatabase()
        }
    }
}

struct AlarmHeader: View {
    let title: String
    
    init(title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.medium)
            .foregroundColor(.black)
            .padding(.vertical, 4)
    }
}

struct AlarmRow: View {
    let alarm: Alarm
    @Binding var isOn: Bool
    let action: () -> Void

    @Environment(\.editMode) private var editMode: Binding<EditMode>?
    
    var body: some View {
        Text("鬧鐘")
        if alarm.isInvalidated {
            EmptyView()
        } else {
            HStack {
                VStack(alignment: .leading) {
                    Text(TimeUtils.getTimeString(hour: alarm.hour, minute: alarm.minute))
                        .font(.largeTitle)
                    if !alarm.remark.isEmpty {
                        Text(alarm.remark)
                            .font(.subheadline)
                    }
                    switch alarm {
                    case .common(_):
                        Text("一次性鬧鐘")
                            .font(.subheadline)
                    case .regular(let regularAlarm):
                        Text("固定鬧鐘，" + TimeUtils.getWeeksString(weeks: regularAlarm.repeatSettings.weeks))
                            .font(.subheadline)
                    }
                }
                Spacer()
                ZStack(alignment: .trailing) {
                    Toggle("", isOn: $isOn)
                        .opacity(editMode!.wrappedValue.isEditing ? 0: 1)
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
        let mockCommonAlarms = [
            CommonAlarm(hour: 08, minute: 40, remark: ""),
            CommonAlarm(hour: 14, minute: 20, remark: ""),
            CommonAlarm(hour: 17, minute: 00, remark: ""),
        ]
        let mockRegularAlarms = [
            RegularAlarm(hour: 08, minute: 30, repeatSettings: RepeatSettings(weeks: [0,1,2,3,4]), remark: "上班", isOn: true),
            RegularAlarm(hour: 10, minute: 30, repeatSettings: RepeatSettings(weeks: [5,6]), remark: "讀書", isOn: false),
        ]
        AlarmsView(viewModel: AlarmsViewModel(mockCommonAlarms: mockCommonAlarms, mockRegularAlarms: mockRegularAlarms))
            .environment(\.editMode, Binding.constant(EditMode.inactive))
    }
}
