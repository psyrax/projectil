//
//  ViewController.swift
//  Proyectil
//
//  Created by Jose Espinoza Cuevas on 6/8/19.
//  Copyright © 2019 Jose Espinoza Cuevas. All rights reserved.
//

import Cocoa
import RealmSwift

class ViewController: NSViewController {

    var projectData = [[String:AnyObject]]()
    var projects:Results<PTProject>?
    var tasks:Results<PTTask>?
    @IBOutlet weak var addTask: NSButton!
    let realm = try! Realm()
    
    @IBOutlet weak var proyectTableView: NSTableView!
    
    @IBOutlet weak var taskTableView: NSTableView!
    
    
    override func viewDidLoad() {
        print("VC loaded")
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getProjects()
        self.getTasks()
    }
    @IBAction func addProject(_ sender: Any) {
        let proyectSB = NSStoryboard(name: "ProyectSB", bundle: nil) as NSStoryboard
        let proyectVC =  proyectSB.instantiateController(withIdentifier: "proyectVC") as! ProyectViewController
        self.presentAsSheet(proyectVC)
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func getProjects(){
        self.projects = realm.objects(PTProject.self)
        if( projects!.count < 1 ) {
            self.addTask.isEnabled = false
        } else {
            self.addTask.isEnabled = true
            proyectTableView.reloadData()
        }
    }

    func getTasks(){
        
        self.tasks = realm.objects(PTTask.self)
         if( tasks!.count > 0 ) {
            taskTableView.reloadData()
         }
    }

    @IBAction func addTaskShow(_ sender: Any) {
        let taskAddSB = NSStoryboard(name: "TasksSB", bundle: nil) as NSStoryboard
        let taskVC =  taskAddSB.instantiateController(withIdentifier: "taskAdd") as! TaskViewController
        taskVC.projects = self.projects
        self.presentAsSheet(taskVC)
    }
    
    @IBAction func projectSelector(_ sender: NSTableView) {
    }
    
    @IBAction func taskSelector(_ sender: NSTableView) {
        if ( self.tasks!.count > 0 && taskTableView.selectedRow > -1 ){
            let taskAddSB = NSStoryboard(name: "TasksSB", bundle: nil) as NSStoryboard
            let taskVC =  taskAddSB.instantiateController(withIdentifier: "taskAdd") as! TaskViewController
            taskVC.projects = self.projects
            taskVC.newTask = self.tasks![taskTableView.selectedRow]
            self.presentAsSheet(taskVC)
        }
    }
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        var rowCount = 0
        if ( tableView == self.proyectTableView ){
            rowCount = self.projects?.count ?? 0
        }
        if ( tableView == self.taskTableView ){
            rowCount = self.tasks?.count ?? 0
        }
        return rowCount
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
        let cell_id = "\(cell.identifier!.rawValue )"
        var cellContent = String()
        if ( tableView == self.proyectTableView ){
            switch cell_id{
                case "projectName":
                    cellContent = projects?[row].name ?? ""
                break
                case "taskCount":
                    cellContent = "\(projects?[row].tasks.count ?? 0) tareas"
                break
                default:
                    cellContent=""
                break
                
            }
            cell.wantsLayer = true
            let backColorCI = CIColor(string: projects?[row].color ?? "")
            let backColorNS = NSColor(ciColor: backColorCI)
            cell.layer?.backgroundColor = backColorNS.cgColor
            
        }
        
        if ( tableView == self.taskTableView ){
            cell.textField!.stringValue = "task"
            switch cell_id{
            case "taskName":
                cellContent =  tasks?[row].name ?? ""
                break
            case "taskStep":
                cellContent =  tasks?[row].nextStep ?? ""
                break
            case "projectName":
                cell.wantsLayer = true
                let backColorCI = CIColor(string: tasks?[row].project?.color ?? "")
                let backColorNS = NSColor(ciColor: backColorCI)
                cell.layer?.backgroundColor = backColorNS.cgColor
                cellContent = tasks?[row].project?.name ?? ""
                break
            default:
                cellContent = ""
                break
            }
        }
        
       cell.textField!.stringValue = cellContent
        return cell
        }
        
}
