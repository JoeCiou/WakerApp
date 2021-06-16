//
//  AlarmsViewModel.swift
//  Waker
//
//  Created by Joe Ciou on 2021/5/27.
//

import Foundation
import Combine

class AlarmsViewModel: ObservableObject {
    private let isMock: Bool
    
    private var commonAlarms = [CommonAlarm]()
    @Published var regularAlarms = [RegularAlarm]()
    @Published var upcomingAlarms = [Alarm]()
    
    private var commonAlarmsCanceller: AnyCancellable?
    private var regularAlarmsCanceller: AnyCancellable?
    
    init() {
        isMock = false
        connect()
    }
    
    #if DEBUG
    init(mockCommonAlarms: [CommonAlarm], mockRegularAlarms: [RegularAlarm]) {
        isMock = true
        commonAlarms = mockCommonAlarms
        regularAlarms = mockRegularAlarms
        updateUpcomingAlarms()
    }
    #endif
    
    deinit {
        if (!isMock) {
            disconnect()
        }
    }
    
    func connect() {
        if (commonAlarmsCanceller == nil) {
            let (dataPublisher, _) = CommonAlarmsRepository.shared.connect()
            commonAlarmsCanceller = dataPublisher.sink { [weak self] commonAlarms in
                self?.commonAlarms = commonAlarms
                self?.updateUpcomingAlarms()
            }
        }
        if (regularAlarmsCanceller == nil) {
            let (dataPublisher, _) = RegularAlarmsRepository.shared.connect()
            regularAlarmsCanceller = dataPublisher.sink { [weak self] regularAlarms in
                self?.regularAlarms = regularAlarms
                self?.updateUpcomingAlarms()
            }
        }
    }
    
    func disconnect() {
        commonAlarmsCanceller?.cancel()
        regularAlarmsCanceller?.cancel()
        CommonAlarmsRepository.shared.disconnect()
        RegularAlarmsRepository.shared.disconnect()
    }
    
    private func updateUpcomingAlarms() {
        let now = Date()
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: now)
        upcomingAlarms = (commonAlarms.map({ Alarm.common($0) }) + regularAlarms.filter({ $0.isOn }).map({ Alarm.regular($0) })).sorted(by: { alarm1, alarm2 in
            var alarmDate1 = DateComponents(calendar: Calendar.current, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: alarm1.hour, minute: alarm1.minute).date!
            var alarmDate2 = DateComponents(calendar: Calendar.current, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: alarm2.hour, minute: alarm2.minute).date!
            if alarmDate1 < now {
                alarmDate1 = Calendar.current.date(byAdding: .day, value: 1, to: alarmDate1)!
            }
            if alarmDate2 < now {
                alarmDate2 = Calendar.current.date(byAdding: .day, value: 1, to: alarmDate2)!
            }
            
            return alarmDate1 < alarmDate2
        })
    }
    
    func switchRegularAlarm(_ regularAlarm: RegularAlarm) {
        RegularAlarmsRepository.shared.update(regularAlarm, isOn: !regularAlarm.isOn)
    }
    
    func deleteAlarm(_ alarm: Alarm) {
        switch alarm {
        case .common(let commonAlarm):
            CommonAlarmsRepository.shared.delete(commonAlarm)
        case .regular(let regularAlarm):
            RegularAlarmsRepository.shared.delete(regularAlarm)
        }
    }
    
    func deleteUpcomingAlarms(at indexSet: IndexSet) {
        let alarmsToDelete = indexSet.map { upcomingAlarms[$0] }
        alarmsToDelete.forEach { alarm in
            deleteAlarm(alarm)
        }
    }
    
    func deleteRegularAlarms(at indexSet: IndexSet) {
        let regularAlarmsToDelete = indexSet.map { regularAlarms[$0] }
        regularAlarmsToDelete.forEach { regularAlarm in
            deleteAlarm(Alarm.regular(regularAlarm))
        }
    }
}
