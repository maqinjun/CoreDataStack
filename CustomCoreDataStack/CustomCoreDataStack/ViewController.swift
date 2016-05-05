//
//  ViewController.swift
//  CustomCoreDataStack
//
//  Created by maqj on 5/4/16.
//  Copyright © 2016 maqj. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate{

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
                    currentDog.note = "This's my dog"
                    
                    try managedContext.save()
                }else{
                    currentDog = dogs[0] as! Dog
                    
                    print("Dog note: \(currentDog.note!)")
                    
                    print("Dog attachment image: \(currentDog.attachment?.image)")
                    
                    guard (currentDog.note) != nil else {
                        currentDog.note = "This's my dog"
                        try managedContext.save()
                        
                        return
                    }

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
        let cell = tableView.dequeueReusableCellWithIdentifier("DogCell", forIndexPath: indexPath)
        
        let walk = currentDog.walks![indexPath.row] as! Walk
        
        cell.textLabel!.text = dateFormatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: walk.date))
        cell.detailTextLabel?.text = currentDog.note
        cell.imageView?.image = currentDog.attachment?.image
        
        print("Image: \(currentDog.attachment?.image)")
        
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
    
    /*
     UITableViewDelegate implementations.
     */
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let attachMents = attachments()
        
        if let atts: [Attachment] = attachMents{
            if atts.count == 0 {
                let attEntity = NSEntityDescription.entityForName("Attachment", inManagedObjectContext: managedContext)
                let attachment = Attachment(entity: attEntity!, insertIntoManagedObjectContext: managedContext)
                attachment.image = image
                currentDog.attachment = attachment
            }
        }
        
        currentDog.attachment?.image = image
        try! managedContext.save()

        print("Info: \(info)")
        print("Image: \(currentDog.attachment?.image)")

        picker.dismissViewControllerAnimated(true, completion: nil)
        
        tableView.reloadData()
    }
    
    func attachments() -> [Attachment] {
//        let attEntity = NSEntityDescription.entityForName("Attachment", inManagedObjectContext: managedContext)
        let fetch = NSFetchRequest(entityName: "Attachment")
        
        do{
            let result = try managedContext.executeFetchRequest(fetch) as! [Attachment]
            return result;
            
        }catch{
            print("Fetch attachment error: \(error)")
        }
        
        return []
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

