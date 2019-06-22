//
//  AppDelegate.swift
//  Proyectil
//
//  Created by Jose Espinoza Cuevas on 6/8/19.
//  Copyright © 2019 Jose Espinoza Cuevas. All rights reserved.
//

import Cocoa
import RealmSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    override init() {
        super.init()
        print("realm file")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    migration.renameProperty(onType: PTTask.className(), from: "story", to: "name")
                }
                if (oldSchemaVersion < 2) {
                    
                }
              
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        _  = try! Realm()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        

        
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        //print("will launch")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

