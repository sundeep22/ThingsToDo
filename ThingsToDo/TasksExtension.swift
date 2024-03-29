//
//  TaskVM.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/6/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import Foundation


import UIKit
import CoreData

//
extension Tasks  {
    
    @NSManaged var taskTitle: String?;
    @NSManaged var taskDescription: String?;
    @NSManaged var taskDeadline: NSDate?;
    @NSManaged var taskStatusId: Int32;
    @NSManaged var taskCreatedOn: NSDate?;
    @NSManaged var uniqueIdentifier: String?;
    @NSManaged var isStarred: Int32;
    @NSManaged var taskGroup: TaskGroups?
    
    
}