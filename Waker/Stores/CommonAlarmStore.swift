//
//  CommonAlarmStore.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/4.
//

import Foundation
import Combine
import RealmSwift

class CommonAlarmStore: AnyDataSubscriptable<CommonAlarm> {
    static let shared = CommonAlarmStore()
    
    private let realm = try! Realm()
    private var commonAlarms: Results<CommonAlarm>
    
    private init() {
        commonAlarms = realm.objects(CommonAlarm.self)
        let publisher = commonAlarms.collectionPublisher
            .map { input in
                return input.sorted { commonAlarm1, commonAlarm2 in
                    let date1 = DateComponents(calendar: Calendar.current, hour: commonAlarm1.hour, minute: commonAlarm1.minute).date!
                    let date2 = DateComponents(calendar: Calendar.current, hour: commonAlarm2.hour, minute: commonAlarm2.minute).date!
                    return date1 != date2 ? date1 < date2: commonAlarm1._id < commonAlarm2._id
                }
            }
            .replaceError(with: [CommonAlarm]())
            .eraseToAnyPublisher()
        
        super.init(publisher)
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
