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
    

//Action: push "Add" button
//Creates alert with text box
//user hit save -> create new Person with text as name, add to people array, display with animation on list
//user hits cancel -> return to list, nothing happens
    @IBAction func addName(sender: AnyObject) {
        
        var alert = UIAlertController(title: "New Name",
            message: "Add a new name!",
            preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        let textField = alert.textFields![0] as! UITextField
        alert.addAction(saveAction(textField))
        alert.addAction(cancelAction())
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        managedContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        title = "Kevin's List"
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadPeopleFromManagedObject()
    }
    
    func loadPeopleFromManagedObject(){
        let fetchRequest = NSFetchRequest(entityName:"Person")
        
        var error: NSError?
        
        let fetchedResults =
        managedContext!.executeFetchRequest(fetchRequest,
            error: &error)
        
        
        if let results = fetchedResults as? [Person]{
            //sort results by earliest entry to latest entry
            var sortedResults = sorted(results, {
                $0.date.compare($1.date) == NSComparisonResult.OrderedAscending
            })
            
            people = sortedResults
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }

    }
    
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
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

