//
//  DetailViewController.swift
//  GetItDone
//
//  Created by ANI on 1/25/17.
//  Copyright © 2017 Shane Empie. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet var saveButton                :UIBarButtonItem!
    @IBOutlet var taskNameTextField         :UITextField!
    @IBOutlet var taskCompletedSwitch       :UISwitch!
    @IBOutlet var priorityZoneSegControl    :UISegmentedControl!
    @IBOutlet var completedLabel            :UILabel!
    
    var currentTask     :Task?
    var managedContext  :NSManagedObjectContext!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - Core Methods
    
    func display(task: Task) {
        taskNameTextField.text = task.taskName
        taskCompletedSwitch.isOn = task.taskCompleted
        valueChanged(tSwitch: taskCompletedSwitch)
        priorityZoneSegControl.selectedSegmentIndex = getPriorityZoneIndex(task: task)
    }
    
    func checkForChanges(task: Task) -> Bool {
        if task.taskName! == taskNameTextField.text && taskCompletedSwitch.isOn == task.taskCompleted && priorityZoneSegControl.selectedSegmentIndex == Int(task.priorityZone!){
            return false
        } else {
            return true
        }
    }
    
    func setTaskValues(task: Task) {
        task.taskName = taskNameTextField.text
        task.taskCompleted = taskCompletedSwitch.isOn
        task.priorityZone = priorityZoneSegControl.titleForSegment(at: priorityZoneSegControl.selectedSegmentIndex)
        if let _ = currentTask {
            task.dateUpdated = NSDate()
        } else {
            task.dateCreated = NSDate()
        }
    }
    
    func createTask() {
        let newTask = NSEntityDescription.insertNewObject(forEntityName: "Task", into: managedContext) as! Task
        setTaskValues(task: newTask)
        appDelegate.saveContext()
    }
    
    func editTask(task: Task) {
        if checkForChanges(task: task) {
            setTaskValues(task: task)
            appDelegate.saveContext()
        }
    }
    
    //MARK: - Interactivity Methods
    
    @IBAction func savedPressed(button: UIBarButtonItem) {
        if let task = currentTask {
            editTask(task: task)
        } else {
            createTask()
        }
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func valueChanged(tSwitch: UISwitch) {
        if tSwitch.isOn{
            completedLabel.text = "Completed"
        } else {
            completedLabel.text = "Not Completed"
        }
    }
    
    //MARK: - Internal Methods
    
    func getPriorityZoneIndex(task: Task) -> Int {
        var priorityZoneIndex : Int
        switch(task.priorityZone!) {
            case "A1": priorityZoneIndex = 0
            break
            case "A2": priorityZoneIndex = 1
            break
            case "B1": priorityZoneIndex = 2
            break
            case "B2": priorityZoneIndex = 3
            break
            default: priorityZoneIndex = 0
            break
        }
        return priorityZoneIndex
    }
    
    //MARK: - Life Cycle Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = appDelegate.persistentContainer.viewContext
        if let task = currentTask {
            display(task: task)
        } else {
            taskCompletedSwitch.isOn = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
