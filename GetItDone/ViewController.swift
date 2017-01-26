//
//  ViewController.swift
//  GetItDone
//
//  Created by ANI on 1/25/17.
//  Copyright © 2017 Shane Empie. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var taskArray = [Task]()
    
    var managedContext  :NSManagedObjectContext!
    
    @IBOutlet var tasksTableView  : UITableView!
    
    //MARK: - Interavtivity Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEditTask" {
            let indexPath = tasksTableView.indexPathForSelectedRow!
            let currentTask = taskArray[indexPath.row]
            let destVC = segue.destination as! DetailViewController
            destVC.currentTask = currentTask
            tasksTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let currentTask = taskArray[indexPath.row]
        let taskComplete : String!
        if currentTask.taskCompleted {
            taskComplete = "Completed"
        } else {
            taskComplete = "Not completed"
        }
        cell.textLabel!.text = currentTask.taskName! + ", " + taskComplete
        cell.detailTextLabel!.text = currentTask.priorityZone
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contactToDelete = taskArray[indexPath.row]
            managedContext.delete(contactToDelete)
            appDelegate.saveContext()
            taskArray = appDelegate.fetchAllContacts()
            tasksTableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.isEditing = false
        }
    }
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskArray = appDelegate.fetchAllContacts()
        print("Count \(taskArray.count)")
        tasksTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

