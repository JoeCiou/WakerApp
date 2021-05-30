//
//  AlertStore.swift
//  Waker
//
//  Created by Joe Ciou on 2021/5/27.
//

import Foundation
import RealmSwift

class AlertStore: AlertProvider {
    static let shared = AlertStore()
    
    let realm = try! Realm()
    var alerts: Results<Alert>
    
    private init() {
        alerts = realm.objects(Alert.self)
    }
    
    func fetchAlerts() -> [Alert] {
        return alerts.sorted { alert1, alert2 in
            let date1 = DateComponents(calendar: Calendar.current, hour: alert1.hour, minute: alert1.minute).date!
            let date2 = DateComponents(calendar: Calendar.current, hour: alert2.hour, minute: alert2.minute).date!
            return date1 != date2 ? date1 < date2: alert1._id < alert2._id
        }
    }
    
    func addAlert(_ alert: Alert) {
        try! realm.write {
            realm.add(alert)
        }
    }
    
    func deleteAlert(_ alert: Alert) {
        try! realm.write({
            realm.delete(alert)
        })
    }
}
