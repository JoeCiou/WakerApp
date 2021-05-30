//
//  AlertsViewModel.swift
//  Waker
//
//  Created by Joe Ciou on 2021/5/27.
//

import Foundation
import RealmSwift

class AlertsViewModel: ObservableObject {
    let provider: AlertProvider
    @Published var alerts: [Alert]
    
    init(provider: AlertProvider) {
        self.provider = provider
        self.alerts = provider.fetchAlerts()
    }
    
    func fetchAlerts() {
        alerts = provider.fetchAlerts()
    }
    
    func addAlert(_ alert: Alert) {
        provider.addAlert(alert)
        alerts = provider.fetchAlerts()
    }
    
    func deleteAlert(at indexSet: IndexSet) {
        let alertsToDelete = indexSet.map { alerts[$0] }
        alertsToDelete.forEach { alert in
            provider.deleteAlert(alert)
        }
        alerts = provider.fetchAlerts()
    }
}
