//
//  Alert.swift
//  Waker
//
//  Created by Joe Ciou on 2021/5/27.
//

import Foundation
import RealmSwift

class Alert: Object, ObjectKeyIdentifiable {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var name: String = ""
    @objc dynamic var hour: Int = 0
    @objc dynamic var minute: Int = 0
    @objc dynamic var isOn: Bool = false
    let repeatWeeks = List<Int>()
    
    override class func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(name: String, hour: Int, minute: Int, isOn: Bool = true, repeatWeeks: [Int] = []) {
        self.init()
        self.name = name
        self.hour = hour
        self.minute = minute
        self.isOn = isOn
        self.repeatWeeks.append(objectsIn: repeatWeeks)
    }
}
