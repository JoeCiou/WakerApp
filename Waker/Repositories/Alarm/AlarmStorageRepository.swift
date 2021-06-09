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
    
    let commonAlarmsPublisher: AnyPublisher<[CommonAlarm], Never>
    let regularAlarmsPublisher: AnyPublisher<[RegularAlarm], Never>
    
    private let realm = try! Realm()
    private var commonAlarms: Results<CommonAlarm>
    private var regularAlarms: Results<RegularAlarm>
    
    private init() {
        commonAlarms = realm.objects(CommonAlarm.self)
        regularAlarms = realm.objects(RegularAlarm.self)
        
        commonAlarmsPublisher = commonAlarms.collectionPublisher
            .map { input in
                return input.sorted { commonAlarm1, commonAlarm2 in
                    let date1 = DateComponents(calendar: Calendar.current, hour: commonAlarm1.hour, minute: commonAlarm1.minute).date!
                    let date2 = DateComponents(calendar: Calendar.current, hour: commonAlarm2.hour, minute: commonAlarm2.minute).date!
                    return date1 != date2 ? date1 < date2: commonAlarm1._id < commonAlarm2._id
                }
            }
            .replaceError(with: [CommonAlarm]())
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
    
    func addCommonAlarm(_ commonAlarm: CommonAlarm) {
        try! realm.write {
            realm.add(commonAlarm)
        }
    }
    
    func updateCommonAlarm(_ commonAlarm: CommonAlarm, hour: Int?, minute: Int?, remark: String?) {
        try! realm.write {
            if let hour = hour { commonAlarm.hour = hour }
            if let minute = minute { commonAlarm.minute = minute }
            if let remark = remark { commonAlarm.remark = remark }
        }
    }
    
    func deleteCommonAlarm(_ commonAlarm: CommonAlarm) {
        try! realm.write {
            realm.delete(commonAlarm)
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
