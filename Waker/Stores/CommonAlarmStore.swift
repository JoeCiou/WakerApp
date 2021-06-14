//
//  CommonAlarmStore.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/4.
//

import Foundation
import Combine
import RealmSwift

class CommonAlarmStore: DataSubscriptable {
    typealias Model = CommonAlarm
    
    static let shared = CommonAlarmStore()
    
    private let realm = try! Realm()
    private var commonAlarms: Results<CommonAlarm>?
    private var dataSubject: PassthroughSubject<[CommonAlarm], Never>?
    private var canceller: AnyCancellable?
    
    var isConnected: Bool {
        canceller != nil
    }
    
    private init() {
        
    }
    
    deinit {
        disconnect()
    }
    
    func connect() -> AnyPublisher<[CommonAlarm], Never> {
        dataSubject = PassthroughSubject<[CommonAlarm], Never>()
        commonAlarms = realm.objects(CommonAlarm.self)
        canceller = commonAlarms!.collectionPublisher
            .map { input in
                return input.sorted { commonAlarm1, commonAlarm2 in
                    let date1 = DateComponents(calendar: Calendar.current, hour: commonAlarm1.hour, minute: commonAlarm1.minute).date!
                    let date2 = DateComponents(calendar: Calendar.current, hour: commonAlarm2.hour, minute: commonAlarm2.minute).date!
                    return date1 != date2 ? date1 < date2: commonAlarm1._id < commonAlarm2._id
                }
            }
            .replaceError(with: [CommonAlarm]())
            .sink { commonAlarms in
                self.dataSubject?.send(commonAlarms)
            }
        
        return dataSubject!.eraseToAnyPublisher()
    }
    
    func disconnect() {
        canceller?.cancel()
        commonAlarms = nil
        dataSubject = nil
    }
    
    func add(_ commonAlarm: CommonAlarm) {
        try! realm.write {
            realm.add(commonAlarm)
        }
    }
    
    func update(_ commonAlarm: CommonAlarm, hour: Int? = nil, minute: Int? = nil, remark: String? = nil) {
        try! realm.write {
            if let hour = hour { commonAlarm.hour = hour }
            if let minute = minute { commonAlarm.minute = minute }
            if let remark = remark { commonAlarm.remark = remark }
        }
    }
    
    func delete(_ commonAlarm: CommonAlarm) {
        try! realm.write {
            realm.delete(commonAlarm)
        }
    }
}
