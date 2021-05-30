//
//  AlertProvider.swift
//  Waker
//
//  Created by Joe Ciou on 2021/5/30.
//

import Foundation

protocol AlertProvider {
    func fetchAlerts() -> [Alert]
    func addAlert(_ alert: Alert)
    func deleteAlert(_ alert: Alert)
}
