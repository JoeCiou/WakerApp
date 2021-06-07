//
//  AlarmRepository.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/4.
//

import Foundation
import Combine

protocol AlarmRepository {
    // Alarm
    var alarmsPublisher: AnyPublisher<[Alarm], Never> { get }
    func addAlarm(_ alarm: Alarm)
    func updateAlarm(_ alarm: Alarm, hour: Int?, minute: Int?, remark: String?)
    func deleteAlarm(_ alarm: Alarm)
    // Regular Alarm
    var regularAlarmsPublisher: AnyPublisher<[RegularAlarm], Never> { get }
    func addRegularAlarm(_ regularAlarm: RegularAlarm)
    func updateRegularAlarm(_ regularAlarm: RegularAlarm, hour: Int?, minute: Int?, repeatSettings: RepeatSettings?, remark: String?, isOn: Bool?)
    func deleteRegularAlarm(_ regularAlarm: RegularAlarm)
}
