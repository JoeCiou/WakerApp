//
//  AlarmsViewModel.swift
//  Waker
//
//  Created by Joe Ciou on 2021/5/27.
//

import Foundation
import Combine
import RealmSwift

class AlarmsViewModel: ObservableObject {
    let repository: AlarmRepository
    @Published var alarms: [Alarm] = []
    var cancellable: AnyCancellable?
    
    init(repository: AlarmRepository = AlarmStorageRepository.shared) {
        self.repository = repository
        self.cancellable = repository.alarmsPublisher.sink { alarms in
            self.alarms = alarms
        }
    }
    
    func deleteAlarm(at indexSet: IndexSet) {
        let alarmsToDelete = indexSet.map { alarms[$0] }
        alarmsToDelete.forEach { alarm in
            repository.deleteAlarm(alarm)
        }
    }
}
