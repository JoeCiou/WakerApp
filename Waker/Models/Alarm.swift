//
//  Alarm.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/8.
//

import Foundation

enum Alarm {
    case common(CommonAlarm)
    case regular(RegularAlarm)
}

extension Alarm: Identifiable {
    var id: String {
        switch self {
        case .common(let commonAlarm):
            return commonAlarm._id.stringValue
        case .regular(let regularAlarm):
            return regularAlarm._id.stringValue
        }
    }
    
    var hour: Int {
        switch self {
        case .common(let commonAlarm):
            return commonAlarm.hour
        case .regular(let regularAlarm):
            return regularAlarm.hour
        }
    }
    
    var minute: Int {
        switch self {
        case .common(let commonAlarm):
            return commonAlarm.minute
        case .regular(let regularAlarm):
            return regularAlarm.minute
        }
    }
    
    var remark: String {
        switch self {
        case .common(let commonAlarm):
            return commonAlarm.remark
        case .regular(let regularAlarm):
            return regularAlarm.remark
        }
    }
    
    var isInvalidated: Bool {
        switch self {
        case .common(let commonAlarm):
            return commonAlarm.isInvalidated
        case .regular(let regularAlarm):
            return regularAlarm.isInvalidated
        }
    }
}
