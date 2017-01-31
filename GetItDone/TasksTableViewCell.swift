//
//  TasksTableViewCell.swift
//  GetItDone
//
//  Created by Valerie Greer on 1/31/17.
//  Copyright © 2017 Shane Empie. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewCell: UITableViewCell {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var cellTask                        :Task!

    @IBOutlet var taskLabel             :UILabel!
    @IBOutlet var priorityLabel         :UILabel!
    @IBOutlet var statusLabel           :UILabel!
    @IBOutlet var completedCellSwitch   :UISwitch!
    
    @IBAction func valueChanged(cSwitch: UISwitch) {
        if cSwitch.isOn {
            statusLabel.text = "Completed"
            cellTask.taskCompleted = true
        } else {
            statusLabel.text = "Not completed"
            cellTask.taskCompleted = false
        }
        appDelegate.saveContext()
    }
    
    func setCellTask(task: Task) {
        cellTask = task
    }


}
