//
//  TaskGroupsVM.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/11/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import Foundation


struct TaskGroupsVM
{
    
    var taskGroupName: String?
    var dateCreated: NSDate?
    var uniqueIdentifier: String?;
    var isStarred: NSNumber?;
    var objectID: AnyObject?
    
    init()
    {
        self.uniqueIdentifier = NSUUID().UUIDString
        self.taskGroupName = ""
    }
    
    init(taskGroupName: String?)
    {
        self.taskGroupName = taskGroupName
        self.uniqueIdentifier = NSUUID().UUIDString
    }
    
    func CreateTaskGroupEntityForTaskGroupVM() -> TaskGroups
    {
        let da = TaskGroupsDA();
        
        let entityTask = da.GetEmptyTaskGroup();
        
        entityTask.taskGroupName = self.taskGroupName
        entityTask.dateCreated = self.dateCreated
        entityTask.uniqueIdentifier = self.uniqueIdentifier
        return entityTask;
    }
    
    func CreateTaskGroupEntityForTaskGroupVM(taskGroupVM: TaskGroupsVM) -> TaskGroups
    {
        let da = TaskGroupsDA();
        
        let entityTask = da.GetEmptyTaskGroup();
        
        entityTask.taskGroupName = taskGroupVM.taskGroupName
        entityTask.dateCreated = taskGroupVM.dateCreated
        entityTask.uniqueIdentifier = taskGroupVM.uniqueIdentifier
        return entityTask;
    }
    
    static func CreateTaskGroupsVMForTaskGruopsEntity(taskGroupsEntity: TaskGroups) -> TaskGroupsVM
    {
        var taskGroupVM = TaskGroupsVM()
        
        taskGroupVM.taskGroupName = taskGroupsEntity.taskGroupName
        taskGroupVM.dateCreated = taskGroupsEntity.dateCreated
        taskGroupVM.uniqueIdentifier = taskGroupsEntity.uniqueIdentifier
        taskGroupVM.objectID = taskGroupsEntity.objectID
        
        return taskGroupVM
    }

    
}