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
            .sorted(by: [
                SortDescriptor(keyPath: #keyPath(RegularAlarm.hour), ascending: true),
                SortDescriptor(keyPath: #keyPath(RegularAlarm.minute), ascending: true),
                SortDescriptor(keyPath: #keyPath(RegularAlarm._id), ascending: true)
            ])
        canceller = regularAlarms!.collectionPublisher
            .map { Array($0) }
            .replaceError(with: [RegularAlarm]())
            .sink { [unowned self] regularAlarms in
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
