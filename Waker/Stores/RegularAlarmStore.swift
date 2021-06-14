//
//  RegularAlarmStore.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/11.
//

import Foundation
import Combine
import RealmSwift

class RegularAlarmStore: DataSubscriptable {
    typealias Model = RegularAlarm
    
    static let shared = RegularAlarmStore()
    
    private let realm = try! Realm()
    private var regularAlarms: Results<RegularAlarm>?
    private var dataSubject: PassthroughSubject<[RegularAlarm], Never>?
    private var canceller: AnyCancellable?
    
    var isConnected: Bool {
        canceller != nil
    }
    
    private init() {
        
    }
    
    deinit {
        disconnect()
    }
    
    func connect() -> AnyPublisher<[RegularAlarm], Never> {
        dataSubject = PassthroughSubject<[RegularAlarm], Never>()
        regularAlarms = realm.objects(RegularAlarm.self)
        canceller = regularAlarms!.collectionPublisher
            .map { input in
                return input.sorted { regularAlarm1, regularAlarm2 in
                    let date1 = DateComponents(calendar: Calendar.current, hour: regularAlarm1.hour, minute: regularAlarm1.minute).date!
                    let date2 = DateComponents(calendar: Calendar.current, hour: regularAlarm2.hour, minute: regularAlarm2.minute).date!
                    return date1 != date2 ? date1 < date2: regularAlarm1._id < regularAlarm2._id
                }
            }
            .replaceError(with: [RegularAlarm]())
            .sink { regularAlarms in
                self.dataSubject?.send(regularAlarms)
            }
        
        return dataSubject!.eraseToAnyPublisher()
    }
    
    func disconnect() {
        canceller?.cancel()
        regularAlarms = nil
        dataSubject = nil
    }
    
    func add(_ regularAlarm: RegularAlarm) {
        try! realm.write {
            realm.add(regularAlarm)
        }
    }
    
    func update(_ regularAlarm: RegularAlarm, hour: Int? = nil, minute: Int? = nil, repeatSettings: RepeatSettings? = nil, remark: String? = nil, isOn: Bool? = nil) {
        try! realm.write {
            if let hour = hour { regularAlarm.hour = hour }
            if let minute = minute { regularAlarm.minute = minute }
            if let repeatSettings = repeatSettings { regularAlarm.repeatSettings = repeatSettings }
            if let remark = remark { regularAlarm.remark = remark }
            if let isOn = isOn { regularAlarm.isOn = isOn }
        }
    }
    
    func delete(_ regularAlarm: RegularAlarm) {
        try! realm.write {
            realm.delete(regularAlarm)
        }
    }
}
