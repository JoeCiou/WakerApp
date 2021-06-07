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
    @objc dynamic var repeatSettings: RepeatSettings?
    @objc dynamic var remark: String = ""
    @objc dynamic var isOn: Bool = false
    
    override class func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(hour: Int, minute: Int, repeatSettings: RepeatSettings, remark: String, isOn: Bool = true) {
        self.init()
        self.hour = hour
        self.minute = minute
        self.repeatSettings = repeatSettings
        self.remark = remark
        self.isOn = isOn
    }
}

class RepeatSettings: EmbeddedObject {
    let weeks = List<Int>()
    
    convenience init(weeks: [Int]? = nil) {
        self.init()
        if let weeks = weeks {
            self.weeks.append(objectsIn: weeks)
        }
    }
}
