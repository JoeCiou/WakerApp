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
            .sorted(by: [
                SortDescriptor(keyPath: #keyPath(CommonAlarm.hour), ascending: true),
                SortDescriptor(keyPath: #keyPath(CommonAlarm.minute), ascending: true),
                SortDescriptor(keyPath: #keyPath(CommonAlarm._id), ascending: true)
            ])
        canceller = commonAlarms!.collectionPublisher
            .map { Array($0) }
            .replaceError(with: [CommonAlarm]())
            .sink { [unowned self] commonAlarms in
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
