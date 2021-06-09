//
//  CommonAlarm.swift
//  Waker
//
//  Created by Joe Ciou on 2021/5/27.
//

import Foundation
import RealmSwift

class CommonAlarm: Object, ObjectKeyIdentifiable {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var hour: Int = 0
    @objc dynamic var minute: Int = 0
    @objc dynamic var remark: String = ""
    
    override class func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(hour: Int, minute: Int, remark: String) {
        self.init()
        self.hour = hour
        self.minute = minute
        self.remark = remark
    }
}
