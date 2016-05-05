//
//  Attachment+CoreDataProperties.swift
//  CustomCoreDataStack
//
//  Created by maqj on 5/5/16.
//  Copyright © 2016 maqj. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData
import UIKit

extension Attachment {

    @NSManaged var image: UIImage?
    @NSManaged var dog: Dog?

}
