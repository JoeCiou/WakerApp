//
//  AlarmMockRepository.swift
//  Waker
//
//  Created by Joe Ciou on 2021/5/30.
//

import Foundation
import Combine

class AlarmMockRepository: AlarmRepository {
    let alarmsPublisher: AnyPublisher<[Alarm], Never>
    let regularAlarmsPublisher: AnyPublisher<[RegularAlarm], Never>
    
    private var alarms = [
        Alarm(hour: 10, minute: 0, remark: ""),
        Alarm(hour: 10, minute: 30, remark: ""),
        Alarm(hour: 08, minute: 0, remark: ""),
        Alarm(hour: 11, minute: 0, remark: ""),
    ]
    
    private var regularAlarms = [
        RegularAlarm(hour: 8, minute: 30, repeatSettings: RepeatSettings(weeks: [1,2,3,4,5]), remark: ""),
        RegularAlarm(hour: 10, minute: 00, repeatSettings: RepeatSettings(weeks: [6,7]), remark: ""),
    ]
    
    init() {
        alarmsPublisher = alarms.publisher.collect().eraseToAnyPublisher()
        regularAlarmsPublisher = regularAlarms.publisher.collect().eraseToAnyPublisher()
    }
    
    func addAlarm(_ alarm: Alarm) {
        alarms.append(alarm)
    }
    
    func updateAlarm(_ alarm: Alarm, hour: Int?, minute: Int?, remark: String?) {
        if let index = alarms.firstIndex(of: alarm) {
            if let hour = hour { alarms[index].hour = hour }
            if let minute = minute { alarms[index].minute = minute }
            if let remark = remark { alarms[index].remark = remark }
        }
    }
    
    func deleteAlarm(_ alarm: Alarm) {
        if let index = alarms.firstIndex(of: alarm) {
            alarms.remove(at: index)
        }
    }
    
    func addRegularAlarm(_ regularAlarm: RegularAlarm) {
        regularAlarms.append(regularAlarm)
    }
    
    func updateRegularAlarm(_ regularAlarm: RegularAlarm) {
        if let index = regularAlarms.firstIndex(of: regularAlarm) {
            regularAlarms[index] = regularAlarm
        }
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
