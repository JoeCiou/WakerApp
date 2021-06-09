//
//  RegularAlarm.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/5.
//

import Foundation
import RealmSwift

class RegularAlarm: Object, ObjectKeyIdentifiable {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var hour: Int = 0
    @objc dynamic var minute: Int = 0
    private let repeatWeeks = List<Int>()
    @objc dynamic var remark: String = ""
    @objc dynamic var isOn: Bool = false
    
    var repeatSettings: RepeatSettings {
        get {
            RepeatSettings(weeks: Array(repeatWeeks))
        }
        set {
            repeatWeeks.removeAll()
            repeatWeeks.append(objectsIn: newValue.weeks)
        }
    }
    
    override class func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(hour: Int, minute: Int, repeatSettings: RepeatSettings, remark: String, isOn: Bool = true) {
        self.init()
        self.hour = hour
        self.minute = minute
        self.repeatWeeks.append(objectsIn: repeatSettings.weeks)
        self.remark = remark
        self.isOn = isOn
    }
}
