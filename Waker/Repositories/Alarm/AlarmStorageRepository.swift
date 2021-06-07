//
//  AlarmStorageRepository.swift
//  Waker
//
//  Created by Joe Ciou on 2021/5/27.
//

import Foundation
import Combine
import RealmSwift

class AlarmStorageRepository: AlarmRepository {
    static let shared = AlarmStorageRepository()
    
    let alarmsPublisher: AnyPublisher<[Alarm], Never>
    let regularAlarmsPublisher: AnyPublisher<[RegularAlarm], Never>
    
    private let realm = try! Realm()
    private var alarms: Results<Alarm>
    private var regularAlarms: Results<RegularAlarm>
    
    private init() {
        alarms = realm.objects(Alarm.self)
        regularAlarms = realm.objects(RegularAlarm.self)
        
        alarmsPublisher = alarms.collectionPublisher
            .map { input in
                return input.sorted { alarm1, alarm2 in
                    let date1 = DateComponents(calendar: Calendar.current, hour: alarm1.hour, minute: alarm1.minute).date!
                    let date2 = DateComponents(calendar: Calendar.current, hour: alarm2.hour, minute: alarm2.minute).date!
                    return date1 != date2 ? date1 < date2: alarm1._id < alarm2._id
                }
            }
            .replaceError(with: [Alarm]())
            .eraseToAnyPublisher()
        
        regularAlarmsPublisher = regularAlarms.collectionPublisher
            .map { input in
                return input.sorted { regularAlarm1, regularAlarm2 in
                    let date1 = DateComponents(calendar: Calendar.current, hour: regularAlarm1.hour, minute: regularAlarm1.minute).date!
                    let date2 = DateComponents(calendar: Calendar.current, hour: regularAlarm2.hour, minute: regularAlarm2.minute).date!
                    return date1 != date2 ? date1 < date2: regularAlarm1._id < regularAlarm2._id
                }
            }
            .replaceError(with: [RegularAlarm]())
            .eraseToAnyPublisher()
    }
    
    func fetchAlarms() -> [Alarm] {
        return alarms.sorted { alarm1, alarm2 in
            let date1 = DateComponents(calendar: Calendar.current, hour: alarm1.hour, minute: alarm1.minute).date!
            let date2 = DateComponents(calendar: Calendar.current, hour: alarm2.hour, minute: alarm2.minute).date!
            return date1 != date2 ? date1 < date2: alarm1._id < alarm2._id
        }
    }
    
    func addAlarm(_ alarm: Alarm) {
        try! realm.write {
            realm.add(alarm)
        }
    }
    
    func updateAlarm(_ alarm: Alarm, hour: Int?, minute: Int?, remark: String?) {
        try! realm.write {
            if let hour = hour { alarm.hour = hour }
            if let minute = minute { alarm.minute = minute }
            if let remark = remark { alarm.remark = remark }
        }
    }
    
    func deleteAlarm(_ alarm: Alarm) {
        try! realm.write {
            realm.delete(alarm)
        }
    }
    
    func fetchRegularAlarms() -> [RegularAlarm] {
        return regularAlarms.sorted { alarm1, alarm2 in
            let date1 = DateComponents(calendar: Calendar.current, hour: alarm1.hour, minute: alarm1.minute).date!
            let date2 = DateComponents(calendar: Calendar.current, hour: alarm2.hour, minute: alarm2.minute).date!
            return date1 != date2 ? date1 < date2: alarm1._id < alarm2._id
        }
    }
    
    func addRegularAlarm(_ regularAlarm: RegularAlarm) {
        try! realm.write {
            realm.add(regularAlarm)
        }
    }
    
    func updateRegularAlarm(_ regularAlarm: RegularAlarm, hour: Int?, minute: Int?, repeatSettings: RepeatSettings?, remark: String?, isOn: Bool?) {
        try! realm.write {
            if let hour = hour { regularAlarm.hour = hour }
            if let minute = minute { regularAlarm.minute = minute }
            if let repeatSettings = repeatSettings { regularAlarm.repeatSettings = repeatSettings }
            if let remark = remark { regularAlarm.remark = remark }
            if let isOn = isOn { regularAlarm.isOn = isOn }
        }
    }
    
    func deleteRegularAlarm(_ regularAlarm: RegularAlarm) {
        try! realm.write {
            realm.delete(regularAlarm)
        }
    }
}
