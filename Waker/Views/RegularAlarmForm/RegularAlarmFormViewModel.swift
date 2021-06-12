//
//  RegularAlarmFormViewModel.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/7.
//

import Foundation
import RealmSwift

class RegularAlarmFormViewModel: ObservableObject {
    let editTarget: RegularAlarm?
    @Published var hour: Int
    @Published var minute: Int
    @Published var repeatSettings: RepeatSettings
    @Published var remark: String
    @Published var isOn: Bool
    
    init(editTarget: RegularAlarm? = nil) {
        self.editTarget = editTarget
        if let editTarget = editTarget {
            hour = editTarget.hour
            minute = editTarget.minute
            repeatSettings = editTarget.repeatSettings
            remark = editTarget.remark
            isOn = editTarget.isOn
        } else {
            let now = Date()
            hour = Calendar.current.component(.hour, from: now)
            minute = Calendar.current.component(.minute, from: now)
            repeatSettings = RepeatSettings(weeks: Array(0...6))
            remark = ""
            isOn = true
        }
    }
    
    func submit() {
        if let editTarget = editTarget {
            RegularAlarmStore.shared.update(editTarget, hour: hour, minute: minute, repeatSettings: repeatSettings, remark: remark, isOn: isOn)
        } else {
            let regularAlarm = RegularAlarm(hour: hour, minute: minute, repeatSettings: repeatSettings, remark: remark, isOn: isOn)
            RegularAlarmStore.shared.add(regularAlarm)
        }
    }
}
