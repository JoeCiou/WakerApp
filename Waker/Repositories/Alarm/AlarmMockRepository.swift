//
//  AlarmMockRepository.swift
//  Waker
//
//  Created by Joe Ciou on 2021/5/30.
//

import Foundation
import Combine

class AlarmMockRepository: AlarmRepository {
    let commonAlarmsPublisher: AnyPublisher<[CommonAlarm], Never>
    let regularAlarmsPublisher: AnyPublisher<[RegularAlarm], Never>
    
    private var commonAlarms = [
        CommonAlarm(hour: 10, minute: 0, remark: ""),
        CommonAlarm(hour: 10, minute: 30, remark: ""),
        CommonAlarm(hour: 08, minute: 0, remark: ""),
        CommonAlarm(hour: 11, minute: 0, remark: ""),
    ]
    
    private var regularAlarms = [
        RegularAlarm(hour: 8, minute: 30, repeatSettings: RepeatSettings(weeks: [0,1,2,3,4]), remark: ""),
        RegularAlarm(hour: 10, minute: 00, repeatSettings: RepeatSettings(weeks: [5,6]), remark: ""),
    ]
    
    init() {
        commonAlarmsPublisher = commonAlarms.publisher.collect().eraseToAnyPublisher()
        regularAlarmsPublisher = regularAlarms.publisher.collect().eraseToAnyPublisher()
    }
    
    func addCommonAlarm(_ commonAlarm: CommonAlarm) {
        commonAlarms.append(commonAlarm)
    }
    
    func updateCommonAlarm(_ commonAlarm: CommonAlarm, hour: Int?, minute: Int?, remark: String?) {
        if let index = commonAlarms.firstIndex(of: commonAlarm) {
            if let hour = hour { commonAlarms[index].hour = hour }
            if let minute = minute { commonAlarms[index].minute = minute }
            if let remark = remark { commonAlarms[index].remark = remark }
        }
    }
    
    func deleteCommonAlarm(_ commonAlarm: CommonAlarm) {
        if let index = commonAlarms.firstIndex(of: commonAlarm) {
            commonAlarms.remove(at: index)
        }
    }
    
    func addRegularAlarm(_ regularAlarm: RegularAlarm) {
        regularAlarms.append(regularAlarm)
    }
    
    func updateRegularAlarm(_ regularAlarm: RegularAlarm, hour: Int?, minute: Int?, repeatSettings: RepeatSettings?, remark: String?, isOn: Bool?) {
        if let index = regularAlarms.firstIndex(of: regularAlarm) {
            if let hour = hour { regularAlarms[index].hour = hour }
            if let minute = minute { regularAlarms[index].minute = minute }
            if let repeatSettings = repeatSettings { regularAlarms[index].repeatSettings = repeatSettings }
            if let remark = remark { regularAlarms[index].remark = remark }
            if let isOn = isOn { regularAlarms[index].isOn = isOn }
        }
    }
    
    func deleteRegularAlarm(_ regularAlarm: RegularAlarm) {
        if let index = regularAlarms.firstIndex(of: regularAlarm) {
            regularAlarms.remove(at: index)
        }
    }
}
