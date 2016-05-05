//
//  ViewController.swift
//  CustomCoreDataStack
//
//  Created by maqj on 5/4/16.
//  Copyright © 2016 maqj. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    var managedContext: NSManagedObjectContext!
    
    var currentDog: Dog!
    
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.clearsSelectionOnViewWillAppear = true
        
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .MediumStyle

        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        insertDogEntity()
    }
    
    func insertDogEntity() -> Void {
        let dogEntity = NSEntityDescription.entityForName("Dog", inManagedObjectContext: managedContext)
        
        _ =  Dog(entity: dogEntity!, insertIntoManagedObjectContext: managedContext)
        
        let dogName = "Fido"
        let dogFetch = NSFetchRequest(entityName: "Dog")
        dogFetch.predicate = NSPredicate(format: "name == %@", dogName)
        
        do{
            let result = try managedContext.executeFetchRequest(dogFetch)
            
            if let dogs: [AnyObject] = result {
                if dogs.count == 0 {
                    currentDog = Dog(entity: dogEntity!, insertIntoManagedObjectContext: managedContext)
                    currentDog.name = dogName
                    
                    try managedContext.save()
                }else{
                    currentDog = dogs[0] as! Dog
                }
            }
            
        }catch{
            print("Error: \(error)")
        }
    }
    
    /*
      UITableViewDataSource implementations.
     */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows = 0
        
        if let dog: Dog = currentDog {
            numRows = (dog.walks?.count)!
        }
        
        return numRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let walk = currentDog.walks![indexPath.row] as! Walk
        
        cell.textLabel!.text = dateFormatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: walk.date))
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let walkToRemove = currentDog.walks![indexPath.row] as! Walk
            
            let walks = currentDog.walks!.mutableCopy() as! NSMutableOrderedSet
            walks.removeObjectAtIndex(indexPath.row)
            currentDog.walks = walks.copy() as? NSOrderedSet
            
            managedContext.deleteObject(walkToRemove)
            
            try! managedContext.save()
          
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
    }
    
    @IBAction func add(sender: AnyObject){
        let walkEntity = NSEntityDescription.entityForName("Walk", inManagedObjectContext: managedContext)
        let walk = Walk(entity: walkEntity!, insertIntoManagedObjectContext: managedContext)
        
        walk.date = NSDate().timeIntervalSince1970
        
        let walks = currentDog.walks?.mutableCopy() as! NSMutableOrderedSet
        
        walks.addObject(walk)
        
        currentDog.walks = walks.copy() as? NSOrderedSet
        
        do{
            try managedContext.save()
            
            tableView.reloadData()
        }catch{
            print("Save error: \(error)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

