//
//  AlarmFormViewModel.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/4.
//

import Foundation

class AlarmFormViewModel: ObservableObject {
    let repository: AlarmRepository
    let editTarget: Alarm?
    @Published var hour: Int
    @Published var minute: Int
    @Published var remark: String
    
    init(repository: AlarmRepository = AlarmStorageRepository.shared, editTarget: Alarm? = nil) {
        self.repository = repository
        self.editTarget = editTarget
        if let editTarget = editTarget {
            hour = editTarget.hour
            minute = editTarget.minute
            remark = editTarget.remark
        } else {
            let now = Date()
            hour = Calendar.current.component(.hour, from: now)
            minute = Calendar.current.component(.minute, from: now)
            remark = ""
        }
    }
    
    func submit() {
        if let editTarget = editTarget {
            repository.updateAlarm(editTarget, hour: hour, minute: minute, remark: remark)
        } else {
            let alarm = Alarm(hour: hour, minute: minute, remark: remark)
            repository.addAlarm(alarm)
        }
    }
}
