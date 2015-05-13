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

    @IBOutlet weak var tableView: UITableView!
    var people = [Person]()
    var managedContext: NSManagedObjectContext?
    @IBAction func addName(sender: AnyObject) {
        
        var alert = UIAlertController(title: "New Name",
            message: "Add a new name!",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default) { (action: UIAlertAction!) -> Void in
                
                let textField = alert.textFields![0] as! UITextField
                self.saveName(textField.text)
                let indexPath = NSIndexPath(forRow: self.people.count-1, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
    }
    
    func saveName(name: String) {
        //1
        
        
        //2
        let entity =  NSEntityDescription.entityForName("Person",
            inManagedObjectContext:
            managedContext!)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext) as! Person
        
        
        person.name = name
        person.date = NSDate()
        
        //3
        //person.setValue(name, forKey: "name")
        
        //4
        var error: NSError?
        if !managedContext!.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }  
        //5
        people.append(person)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        managedContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        title = "\"The List\""
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadPeopleFromManagedObject()
    }
    
    func loadPeopleFromManagedObject(){
        let fetchRequest = NSFetchRequest(entityName:"Person")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext!.executeFetchRequest(fetchRequest,
            error: &error)
        
        // Create a sort descriptor object that sorts on the "title"
        // property of the Core Data object
        // let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        // fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        if let results = fetchedResults as? [Person]{
            var sortedResults = sorted(results, {
                $0.date.compare($1.date) == NSComparisonResult.OrderedAscending
            })
            
            people = sortedResults
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        println("Could fetch \(error),")


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
            
           // cell.textLabel!.text = person.valueForKey("name") as? String
            
            return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        
        return [
            UITableViewRowAction(style: .Normal, title: "More") { _ in println("More") },
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

