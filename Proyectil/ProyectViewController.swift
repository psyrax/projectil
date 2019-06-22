//
//  ProyectViewController.swift
//  Proyectil
//
//  Created by Jose Espinoza Cuevas on 6/10/19.
//  Copyright © 2019 Jose Espinoza Cuevas. All rights reserved.
//

import Cocoa
import RealmSwift

class ProyectViewController: NSViewController {
    
    
    @IBOutlet weak var redRadio: NSButton!
    @IBOutlet weak var greenRadio: NSButton!
    @IBOutlet weak var blueRadio: NSButton!
    @IBOutlet weak var yellowRadio: NSButton!
    @IBOutlet weak var customRadio: NSButton!
    @IBOutlet weak var orangeRadio: NSButton!
    
    @IBOutlet weak var yellowColor: NSBox!
    @IBOutlet weak var orangeColor: NSBox!
    @IBOutlet weak var blueColor: NSBox!
    @IBOutlet weak var greenColor: NSBox!
    @IBOutlet weak var redColor: NSBox!
    
    @IBOutlet weak var projectName: NSTextField!
    @IBOutlet weak var projectColor: NSColorWell!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func cancelProjectAdd(_ sender: Any) {
        self.view.window!.close()
    }
    @IBAction func saveProject(_ sender: Any) {
        var selectedColor =  self.projectColor.color.cgColor
        if ( self.customRadio.state == .on){
            selectedColor = self.projectColor.color.cgColor
        }
        if ( self.redRadio.state == .on){
            selectedColor = self.redColor.fillColor.cgColor
        }
        if ( self.greenRadio.state == .on){
            selectedColor = self.greenColor.fillColor.cgColor
        }
        if ( self.blueRadio.state == .on){
            selectedColor = self.blueColor.fillColor.cgColor
        }
        if ( self.orangeRadio.state == .on){
            selectedColor = self.orangeColor.fillColor.cgColor
        }
        if ( self.yellowRadio.state == .on){
            selectedColor = self.yellowColor.fillColor.cgColor
        }
        
        
        let colorRef = CIColor(cgColor: selectedColor).stringRepresentation
        let newProject = PTProject()
        newProject.name = projectName!.stringValue
        newProject.color = colorRef
        let realm = try! Realm()
        try! realm.write {
            realm.add(newProject)
        }
        let parentViewController = self.presentingViewController as! ViewController
        parentViewController.getProjects()
        self.view.window!.close()
    }
    
    @IBAction func colorPickRadio(_ sender: NSButton) {
//        print(sender.identifier)
    }
    
    
}

