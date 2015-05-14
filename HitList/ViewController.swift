//
//  ViewController.swift
//  HitList
//
//  Created by Kevin Kane on 5/12/15.
//  Copyright (c) 2015 KevinKane. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    

//Global variables
    @IBOutlet weak var tableView: UITableView!
    var people = [Person]()
    var managedContext: NSManagedObjectContext?
    
    // The view has loaded in memory, not displayed
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        managedContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        title = "Bathtub"
         loadPeopleFromManagedObject()
    }
    
    // MARK:UIACTIONS

//Action: push "Add" button
//Creates alert with text box
//user hit save -> create new Person with text as name, add to people array, display with animation on list
//user hits cancel -> return to list, nothing happens
    @IBAction func addName(sender: AnyObject) {
        
        presentViewController(
            alertController("New Name", message: "Add a new name!"),
            animated: true,
            completion: nil)
        
    }
    
    func alertController (title: String, message: String) -> UIAlertController {
        
        var alert = UIAlertController(title: "New Name",
            message: "Add a new name!",
            preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        alert.addAction(saveAction(alert.textFields![0] as! UITextField))
        alert.addAction(cancelAction())
        return alert
    }
    
    func saveAction(textField: UITextField) -> UIAlertAction {
        return UIAlertAction(title: "Save",
            style: .Default) { (action: UIAlertAction!) -> Void in
                let indexPathOfNewEntry = NSIndexPath(forRow: self.people.count, inSection: 0)
                self.saveNewPersonInPeople(textField.text)
                self.tableView.insertRowsAtIndexPaths([indexPathOfNewEntry], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func cancelAction() -> UIAlertAction{
        return UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
    }

    
    //Creates new Entity from passed in name and current datetime, appends to person array
    func saveNewPersonInPeople(name: String) {
        let entity =  NSEntityDescription.entityForName("Person",
            inManagedObjectContext:
            managedContext!)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext) as! Person
        
        person.name = name
        person.date = NSDate()
        
        var error: NSError?
        if !managedContext!.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        people.append(person)
    }
        
    func loadPeopleFromManagedObject(){
        let fetchRequest = NSFetchRequest(entityName:"Person")
        
        var error: NSError?
        
        let fetchedPeople =
        managedContext!.executeFetchRequest(fetchRequest,
            error: &error)
        
        
        if let unsortedPeople = fetchedPeople as? [Person]{
            people = sortPeopleEarliestToLatest(unsortedPeople)
            
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    func sortPeopleEarliestToLatest(unsortedPeople: [Person]) -> [Person] {
        var sortedPeople =  sorted(unsortedPeople, {                $0.date.compare($1.date) == NSComparisonResult.OrderedAscending
        })
        return sortedPeople
    }
    
}

extension ViewController {
    
    //MARK:TABLEVIEW DELEGATE
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return people.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
                as! UITableViewCell
            
            let person = people[indexPath.row]
            cell.textLabel!.text = person.fullName()
            
            return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        return [
            UITableViewRowAction(style: .Default, title: "Delete") { _ in
                self.managedContext!.deleteObject(self.people[indexPath.row])
                self.loadPeopleFromManagedObject()
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        ]
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
                // Intentionally blank. Required to use UITableViewRowActions
    }
}

