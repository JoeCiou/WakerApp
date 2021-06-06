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
        RegularAlarm(hour: 8, minute: 30, repeatSettings: RepeatSettings(weeks: [1,2,3,4,5])),
        RegularAlarm(hour: 10, minute: 00, repeatSettings: RepeatSettings(weeks: [6,7])),
    ]
    
    init() {
        alarmsPublisher = alarms.publisher.collect().eraseToAnyPublisher()
        regularAlarmsPublisher = regularAlarms.publisher.collect().eraseToAnyPublisher()
    }
    
    func addAlarm(_ alarm: Alarm) {
        alarms.append(alarm)
    }
    
    func updateAlarm(_ alarm: Alarm) {
        // TODO
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
        // TODO
    }
    
    func deleteRegularAlarm(_ regularAlarm: RegularAlarm) {
        if let index = regularAlarms.firstIndex(of: regularAlarm) {
            regularAlarms.remove(at: index)
        }
    }
}
