//
//  AlarmFormViewModel.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/4.
//

import Foundation

class AlarmFormViewModel: ObservableObject {
    let repository: AlarmRepository
    let editAlarm: Alarm?
    @Published var hour: Int
    @Published var minute: Int
    @Published var remark: String
    
    init(repository: AlarmRepository = AlarmStorageRepository.shared, editAlarm: Alarm? = nil) {
        self.repository = repository
        self.editAlarm = editAlarm
        if let editAlarm = editAlarm {
            hour = editAlarm.hour
            minute = editAlarm.minute
            remark = editAlarm.remark
        } else {
            let now = Date()
            hour = Calendar.current.component(.hour, from: now)
            minute = Calendar.current.component(.minute, from: now)
            remark = ""
        }
    }
    
    func submit() {
        let alarm = Alarm(hour: hour, minute: minute, remark: remark)
        repository.addAlarm(alarm)
    }
}
