//
//  RegularAlarmsRepository.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/16.
//

import Foundation
import Combine

enum RegularAlarmsRepositorySource {
    case store(RegularAlarmsStore)
}

class RegularAlarmsRepository: Repository {
    typealias Model = [RegularAlarm]
    
    static let shared = RegularAlarmsRepository()
    
    private let source: RegularAlarmsRepositorySource
    private var dataSubject: PassthroughSubject<[RegularAlarm], Never>?
    private var refreshResultSubject: PassthroughSubject<RepositoryRefreshResult, Never>?
    private var storeCanceller: AnyCancellable?
    
    var isConnected: Bool {
        dataSubject != nil
    }
    
    init(source: RegularAlarmsRepositorySource = .store(RegularAlarmsRealmStore.shared)) {
        self.source = source
    }
    
    func connect() -> (AnyPublisher<[RegularAlarm], Never>, AnyPublisher<RepositoryRefreshResult, Never>) {
        dataSubject = PassthroughSubject<[RegularAlarm], Never>()
        refreshResultSubject = PassthroughSubject<RepositoryRefreshResult, Never>()
        
        switch source {
        case .store(let store):
            storeCanceller = store.connect().sink { [unowned self] regularAlarms in
                self.dataSubject?.send(regularAlarms)
            }
        }
        
        return (dataSubject!.eraseToAnyPublisher(), refreshResultSubject!.eraseToAnyPublisher())
    }
    
    func disconnect() {
        storeCanceller?.cancel()
        dataSubject = nil
    }
    
    func refresh() {
        return // Realm store will update immediately if there are any changes
    }
    
    func add(_ regularAlarm: RegularAlarm) {
        switch source {
        case .store(let store):
            store.add(regularAlarm)
        }
    }
    
    func update(_ regularAlarm: RegularAlarm, hour: Int? = nil, minute: Int? = nil, repeatSettings: RepeatSettings? = nil, remark: String? = nil, isOn: Bool? = nil) {
        switch source {
        case .store(let store):
            store.update(regularAlarm, hour: hour, minute: minute, repeatSettings: repeatSettings, remark: remark, isOn: isOn)
        }
    }
    
    func delete(_ regularAlarm: RegularAlarm) {
        switch source {
        case .store(let store):
            store.delete(regularAlarm)
        }
    }
}


