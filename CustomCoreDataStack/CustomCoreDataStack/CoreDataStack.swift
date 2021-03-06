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
    var psc: NSPersistentStoreCoordinator?
    let model: NSManagedObjectModel
    var store: NSPersistentStore? = nil
    
//    var options: NSDictionary?
//    let modelName: String
//    let storeName: String
    
    func applicationDocumentDirectory() -> NSURL {
        let fileMgr = NSFileManager.defaultManager()
        let urls = fileMgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        
        return urls[0]
    }
    
//    init(modelName: String, storeName: String, options: NSDictionary? = nil){
//        self.modelName = modelName
//        self.storeName = storeName
//        self.options = options
//        
//    }
    
    init(){
        let bundle = NSBundle.mainBundle()
        let modelURL = bundle.URLForResource("Dog Walk", withExtension: "momd")
        model = NSManagedObjectModel(contentsOfURL: modelURL!)!
        psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        
        let documentsURL = applicationDocumentDirectory()
        let storeURL = documentsURL.URLByAppendingPathComponent("Dog Walk")
        let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                       NSInferMappingModelAutomaticallyOption: false]
        
        do{
            store = try psc!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
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