//
//  TaskGroups.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/11/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import CoreData

@objc(TaskGroups)
class TaskGroups : NSManagedObject {
    
    @NSManaged var taskGroupName: String?
    @NSManaged var dateCreated: NSDate?
    @NSManaged var uniqueIdentifier: String?;
    @NSManaged var isStarred: NSNumber?;
    @NSManaged var tasks: NSSet?
}