//
//  TaskViewController.swift
//  Proyectil
//
//  Created by Espinoza Cuevas Jose Luis on 6/11/19.
//  Copyright © 2019 Jose Espinoza Cuevas. All rights reserved.
//

import Cocoa
import RealmSwift
import EventKit

class TaskViewController: NSViewController {
    var projects:Results<PTProject>?
    @IBOutlet var nextStep: NSTextView!
    @IBOutlet weak var taskName: NSTextField!
    @IBOutlet weak var projectColorLabel: NSTextField!
    @IBOutlet weak var calendarPopup: NSPopUpButton!
    @IBOutlet weak var projectPopup: NSPopUpButton!
    @IBOutlet weak var dueDate: NSDatePicker!
    @IBOutlet weak var meetingHourPicker: NSDatePicker!
    @IBOutlet weak var reminderCheck: NSButton!
    @IBOutlet weak var calendarCheck: NSButton!
    @IBOutlet weak var meetingEndHourPicker: NSDatePicker!
    
    var availableCalendarTitles = NSMutableArray()
    var availableCalendars = [EKCalendar]()
    var availableReminders = [EKCalendar]()
    let eventStore : EKEventStore = EKEventStore()
    let reminderStore : EKEventStore = EKEventStore()
    var newTask: PTTask = PTTask()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.calendarPopup.removeAllItems()
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            if accessGranted == true {
                let calendars = self.eventStore.calendars(for: .event)
                self.availableCalendars = calendars
                for calendar in calendars {
                    self.availableCalendarTitles.add(calendar.title)
                }
                DispatchQueue.main.async {
                    self.calendarPopup.removeAllItems()
                    self.calendarPopup.addItems(withTitles: self.availableCalendarTitles as! [String])
                }
                
            } else {
                
            }
        })
        reminderStore.requestAccess(to: EKEntityType.reminder, completion: {
            (accessGranted: Bool, error: Error?) in
            if accessGranted == true {
                let reminderCalendars = self.eventStore.calendars(for: .reminder)
                 self.availableReminders = reminderCalendars
            } else {
            }
        })
        self.fillData()
        
        
    }
    func fillData() {
        var projectArray = [String]()
        for project in self.projects! {
            projectArray.append(project.name)
        }
        self.projectPopup.removeAllItems()
        self.projectPopup.addItems(withTitles: projectArray)
        self.projectColorLabel.stringValue = ""
        self.projectColorLabel.drawsBackground = true
        
        let currentDate = Date()
        self.dueDate.calendar = Calendar.current
        self.dueDate.locale = Calendar.current.locale
        self.meetingHourPicker.calendar = Calendar.current
        self.meetingHourPicker.locale = Calendar.current.locale
        self.meetingEndHourPicker.calendar = Calendar.current
        self.meetingEndHourPicker.locale = Calendar.current.locale
        
        
        if  self.newTask.name.isEmpty {
            
            self.setProjectColor(projectIndex: 0)
            
          
            self.dueDate.minDate = currentDate
            self.dueDate.dateValue = currentDate
            
           
            self.meetingHourPicker.dateValue = currentDate
            
            self.meetingEndHourPicker.dateValue = self.meetingHourPicker.calendar!.date(byAdding: .minute, value: 15, to: self.meetingHourPicker.dateValue)!
        } else {
            self.projectPopup.selectItem(withTitle: self.newTask.project!.name)
            self.setProjectColor(projectIndex: self.projectPopup.indexOfSelectedItem)
            self.taskName.stringValue = self.newTask.name
            self.nextStep.string = self.newTask.nextStep
            
            self.dueDate.minDate = self.newTask.dueDate
            self.dueDate.dateValue = self.newTask.dueDate
            
            self.meetingHourPicker.dateValue =  self.newTask.dueDate
            if self.newTask.eventId.isEmpty {
                print("no calendar")
                self.calendarCheck.state = .off
                self.meetingEndHourPicker.isEnabled = false
            } else {
                print("Calendar")
                self.calendarCheck.state = .on
                let taskEvent = eventStore.event(withIdentifier: self.newTask.eventId)
                self.meetingHourPicker.dateValue = taskEvent!.startDate
                self.meetingEndHourPicker.dateValue = taskEvent!.endDate
                print(taskEvent)
            }
            
            if self.newTask.reminderId.isEmpty{
                self.reminderCheck.state = .off
            }else {
                self.calendarCheck.state = .on
                let reminderEvent = reminderStore.event(withIdentifier: self.newTask.reminderId)
                print(reminderEvent)
            }
            
            
        }
        
      
    }
    
    @IBAction func cancelNewTask(_ sender: Any) {
          self.view.window!.close()
    }
    @IBAction func saveNewTask(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let uCalendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year =  uCalendar.component(.year, from: dueDate.dateValue)
        dateComponents.month =  uCalendar.component(.month, from: dueDate.dateValue)
        dateComponents.day = uCalendar.component(.day, from: dueDate.dateValue)
        dateComponents.hour = uCalendar.component(.hour, from: meetingHourPicker.dateValue)
        dateComponents.minute = uCalendar.component(.minute, from: meetingHourPicker.dateValue)
        
        let startDate = uCalendar.date(from: dateComponents)
        
        
        
        newTask.project = self.projects![self.projectPopup.indexOfSelectedItem]
        newTask.name = self.taskName!.stringValue
        newTask.nextStep = self.nextStep!.string
        if ( self.calendarCheck.state == .on ){
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            let event:EKEvent = EKEvent(eventStore: eventStore)
            
    
            dateComponents.hour = uCalendar.component(.hour, from: meetingEndHourPicker.dateValue)
            dateComponents.minute = uCalendar.component(.minute, from: meetingEndHourPicker.dateValue)
            
            let endDate = uCalendar.date(from: dateComponents)
            
            event.title = "\(newTask.project!.name) - \(self.taskName.stringValue)"
            event.startDate = startDate
            event.endDate = endDate
            event.notes = self.nextStep.string
            
            
            var selectedCalendar = EKCalendar()
            for calendar in availableCalendars {
                if (calendar.title == calendarPopup.selectedItem?.title ) {
                    selectedCalendar = calendar
                }
            }
            event.calendar = selectedCalendar
            
            do {
                try self.eventStore.save(event, span: .thisEvent, commit: true)
                newTask.eventId = event.eventIdentifier!
                
            } catch let error as NSError {
                print("failed to save event with error : \(error)")
            }
        }
        if ( self.reminderCheck.state == .on ){
            let reminder:EKReminder = EKReminder(eventStore: reminderStore)
            reminder.title = self.taskName.stringValue
            if let reminderList = availableReminders.first(where: {$0.title == newTask.project!.name}) {
                reminder.calendar = reminderList
            } else {
                let newReminder = EKCalendar(for: .reminder, eventStore: eventStore)
                newReminder.title = newTask.project!.name
                newReminder.source = eventStore.defaultCalendarForNewReminders()!.source
                do{
                    try self.eventStore.saveCalendar(newReminder, commit: true)
                    reminder.calendar = newReminder
                }
                catch let error as NSError {
                    print("failed to save new calendar with error : \(error)")
                }
            }
            reminder.dueDateComponents = dateComponents
            do {
                try self.reminderStore.save(reminder, commit: true)
                newTask.reminderId = reminder.calendarItemIdentifier
            } catch let error as NSError {
                print("failed to save reminder with error : \(error)")
            }
        }
        
        if ( self.reminderCheck.state == .on && !self.newTask.reminderId.isEmpty ){
            let reminderEvent = reminderStore.calendarItem(withIdentifier: self.newTask.reminderId)
            do {
                try self.reminderStore.remove(reminderEvent as! EKReminder, commit: true)
                self.newTask.reminderId = ""
            } catch let error as NSError {
                print("Failed to delete reminder, \(error)")
            }
            
            
        }
       
        newTask.dueDate = startDate!
        
        print(newTask)
        let realm = try! Realm()
        try! realm.write {
            realm.add(newTask)
            newTask.project!.tasks.append(newTask)
        }
        let parentViewController = self.presentingViewController as! ViewController
        parentViewController.getTasks()
        parentViewController.getProjects()
        self.view.window!.close()
    }
    func setProjectColor(projectIndex: Int){
        let backColor = self.projects![projectIndex]["color"]
        let backColorCI = CIColor(string: backColor as! String)
        let backColorNS = NSColor(ciColor: backColorCI)
        self.projectColorLabel.backgroundColor = backColorNS
    }
    @IBAction func changedProject(_ sender: Any) {
          self.setProjectColor(projectIndex: self.projectPopup.indexOfSelectedItem)
    }
    @IBAction func calendarAction(_ sender: Any) {
        if ( self.calendarCheck.state == .on ){
            self.meetingHourPicker.isEnabled = true
            self.meetingEndHourPicker.isEnabled = true
        } else {
            self.meetingHourPicker.isEnabled = false
            self.meetingEndHourPicker.isEnabled = true
        }
    }
    
    @IBAction func reminderAction(_ sender: Any) {
    }
    
    @IBAction func changedStartTime(_ sender: Any) {
        self.meetingEndHourPicker.minDate = self.meetingHourPicker.dateValue
        self.meetingEndHourPicker.dateValue = self.meetingHourPicker.calendar!.date(byAdding: .minute, value: 15, to: self.meetingHourPicker.dateValue)!
        
    }
}
