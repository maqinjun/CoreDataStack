//
//  Walk+CoreDataProperties.swift
//  CustomCoreDataStack
//
//  Created by maqj on 5/4/16.
//  Copyright © 2016 maqj. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Walk {

    @NSManaged var date: NSTimeInterval
    @NSManaged var dog: Dog?

}
