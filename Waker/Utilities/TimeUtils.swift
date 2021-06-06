//
//  TimeUtils.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/5.
//

import Foundation

struct TimeUtils {
    static func getTimeString(hour: Int, minute: Int) -> String {
        let dateFormat = DateFormatter.dateFormat (fromTemplate: "jm",options:0, locale: Locale.current)
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
        return formatter.string(from: DateComponents(calendar: Calendar.current, hour: hour, minute: minute).date!)
    }
}
