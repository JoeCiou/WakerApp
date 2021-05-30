//
//  AlertMock.swift
//  Waker
//
//  Created by Joe Ciou on 2021/5/30.
//

import Foundation

class AlertMock: AlertProvider {
    private var alerts = [
        Alert(name: "測試鬧鐘", hour: 10, minute: 0),
        Alert(name: "測試鬧鐘", hour: 10, minute: 30),
        Alert(name: "測試鬧鐘", hour: 08, minute: 00, repeatWeeks: [0, 1, 2, 3, 4]),
        Alert(name: "測試鬧鐘", hour: 11, minute: 0),
    ]
    
    func fetchAlerts() -> [Alert] {
        return alerts
    }
    
    func addAlert(_ alert: Alert) {
        alerts.append(alert)
    }
    
    func deleteAlert(_ alert: Alert) {
        if let index = alerts.firstIndex(of: alert) {
            alerts.remove(at: index)
        }
    }
}
