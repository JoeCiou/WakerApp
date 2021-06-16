//
//  CommonAlarmsRepository.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/16.
//

import Foundation
import Combine

enum CommonAlarmsRepositorySource {
    case store(CommonAlarmsStore)
}

class CommonAlarmsRepository: Repository {
    typealias Model = [CommonAlarm]
    
    static let shared = CommonAlarmsRepository()
    
    private let source: CommonAlarmsRepositorySource
    private var dataSubject: PassthroughSubject<[CommonAlarm], Never>?
    private var refreshResultSubject: PassthroughSubject<RepositoryRefreshResult, Never>?
    private var storeCanceller: AnyCancellable?
    
    var isConnected: Bool {
        dataSubject != nil
    }
    
    init(source: CommonAlarmsRepositorySource = .store(CommonAlarmsRealmStore.shared)) {
        self.source = source
    }
    
    func connect() -> (AnyPublisher<[CommonAlarm], Never>, AnyPublisher<RepositoryRefreshResult, Never>) {
        dataSubject = PassthroughSubject<[CommonAlarm], Never>()
        refreshResultSubject = PassthroughSubject<RepositoryRefreshResult, Never>()
        
        switch source {
        case .store(let store):
            storeCanceller = store.connect().sink { [unowned self] commonAlarms in
                self.dataSubject?.send(commonAlarms)
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
    
    func add(_ commonAlarm: CommonAlarm) {
        switch source {
        case .store(let store):
            store.add(commonAlarm)
        }
    }
    
    func update(_ commonAlarm: CommonAlarm, hour: Int? = nil, minute: Int? = nil, remark: String? = nil) {
        switch source {
        case .store(let store):
            store.update(commonAlarm, hour: hour, minute: minute, remark: remark)
        }
    }
    
    func delete(_ commonAlarm: CommonAlarm) {
        switch source {
        case .store(let store):
            store.delete(commonAlarm)
        }
    }
}


