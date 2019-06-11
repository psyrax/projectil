//
//  ViewController.swift
//  Proyectil
//
//  Created by Jose Espinoza Cuevas on 6/8/19.
//  Copyright © 2019 Jose Espinoza Cuevas. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var proyectTableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func addProject(_ sender: Any) {
        let proyectViewController = NSViewController.
        self.presentAsSheet(<#T##viewController: NSViewController##NSViewController#>)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

