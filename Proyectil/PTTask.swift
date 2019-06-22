//
//  SATMStory.swift
//  Simple Agile Task Manager
//
//  Created by Espinoza Cuevas Jose Luis on 5/23/19.
//  Copyright © 2019 Jose Espinoza Cuevas. All rights reserved.
//

import Cocoa
import RealmSwift

class PTTask: Object {
    @objc dynamic var name = ""
    @objc dynamic var nextStep = ""
    @objc dynamic var dueDate: Date = Date()
    @objc dynamic var project: PTProject?
    @objc dynamic var status: Int = 0
    @objc dynamic var id:String = UUID().uuidString
    @objc dynamic var eventId = ""
    @objc dynamic var reminderId = ""
    let projects = LinkingObjects(fromType: PTProject.self, property: "tasks")
    let created: Date = Date()
    override static func primaryKey() -> String? {
        return "id"
    }
}

