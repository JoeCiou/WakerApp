//
//  AlarmRepository.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/4.
//

import Foundation
import Combine

protocol AlarmRepository {
    // Common Alarm
    var commonAlarmsPublisher: AnyPublisher<[CommonAlarm], Never> { get }
    func addCommonAlarm(_ commonAlarm: CommonAlarm)
    func updateCommonAlarm(_ commonAlarm: CommonAlarm, hour: Int?, minute: Int?, remark: String?)
    func deleteCommonAlarm(_ commonAlarm: CommonAlarm)
    // Regular Alarm
    var regularAlarmsPublisher: AnyPublisher<[RegularAlarm], Never> { get }
    func addRegularAlarm(_ regularAlarm: RegularAlarm)
    func updateRegularAlarm(_ regularAlarm: RegularAlarm, hour: Int?, minute: Int?, repeatSettings: RepeatSettings?, remark: String?, isOn: Bool?)
    func deleteRegularAlarm(_ regularAlarm: RegularAlarm)
}

extension AlarmRepository {
    func updateCommonAlarm(_ commonAlarm: CommonAlarm, hour: Int? = nil, minute: Int? = nil, remark: String? = nil) {
        return updateCommonAlarm(commonAlarm, hour: hour, minute: minute, remark: remark)
    }
    func updateRegularAlarm(_ regularAlarm: RegularAlarm, hour: Int? = nil, minute: Int? = nil, repeatSettings: RepeatSettings? = nil, remark: String? = nil, isOn: Bool? = nil) {
        return updateRegularAlarm(regularAlarm, hour: hour, minute: minute, repeatSettings: repeatSettings, remark: remark, isOn: isOn)
    }
}
