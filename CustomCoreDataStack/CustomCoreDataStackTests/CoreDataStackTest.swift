//
//  CoreDataStackTest.swift
//  CustomCoreDataStack
//
//  Created by maqj on 5/6/16.
//  Copyright © 2016 maqj. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStackTest: CoreDataStack {

    override var psc: NSPersistentStoreCoordinator? {
        
        get{
            let persc: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.model)
            
            do{
                _ = try persc!.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
            }catch{
                print("Add persistent store error: \(error)")
                abort()
            }
            
            return persc

        }
        
        set{
            print("Set psc...")
        }
    }
}
