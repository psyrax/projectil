//
//  SATMProject.swift
//  Simple Agile Task Manager
//
//  Created by Espinoza Cuevas Jose Luis on 5/22/19.
//  Copyright © 2019 Jose Espinoza Cuevas. All rights reserved.
//

import Cocoa
import RealmSwift

class PTProject: Object {
    @objc  dynamic var name = ""
    @objc dynamic var color = ""
    @objc dynamic var id:String = UUID().uuidString
    let created: Date = Date()
    override static func primaryKey() -> String? {
        return "id"
    }
    let tasks = List<PTTask>()
}

