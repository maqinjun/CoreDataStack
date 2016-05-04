//
//  CoreDataStack.swift
//  CustomCoreDataStack
//
//  Created by maqj on 5/4/16.
//  Copyright © 2016 maqj. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack{
    let context: NSManagedObjectContext
    let psc: NSPersistentStoreCoordinator
    let model: NSManagedObjectModel
    var store: NSPersistentStore? = nil
    
    func applicationDocumentDirectory() -> NSURL {
        let fileMgr = NSFileManager.defaultManager()
        let urls = fileMgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        
        return urls[0]
    }
    
    init(){
        let bundle = NSBundle.mainBundle()
        let modelURL = bundle.URLForResource("Dog Walk", withExtension: "momd")
        model = NSManagedObjectModel(contentsOfURL: modelURL!)!
        psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        
        let documentsURL = applicationDocumentDirectory()
        let storeURL = documentsURL.URLByAppendingPathComponent("Dog Walk")
        let options = [NSMigratePersistentStoresAutomaticallyOption: true]
        
        do{
            store = try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
        }catch{
            print("Error adding persistent store: \(error)")
            abort()
        }
        
    }
    
    func saveContext() {
        if context.hasChanges {
            do{
                try context.save()
            }catch{
                print("Could not save: \(error)")
            }
        }
    }
    
}