//
//  TaskVM.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/9/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import Foundation

struct TaskVM
{
    
    var taskTitle: String?;
    var taskDescription: String?;
    var taskDeadline: NSDate?;
    var taskStatusId: Int32;
    var taskCreatedOn: NSDate?;
    var objectID: AnyObject?
    var uniqueIdentifier: String?;
    var isStarred: Int32;
    var taskGroup: TaskGroupsVM?
    
    init(taskId: Int32, taskGroupId: Int32, taskTitle: String?, taskDescription: String?, taskDeadline: NSDate?, taskStatusId: Int32, taskCreatedOn: NSDate?)
    {
        self.taskStatusId = taskStatusId;
        self.taskTitle = taskTitle;
        self.taskDescription = taskDescription;
        self.taskDeadline = taskDeadline;
        self.taskCreatedOn = taskCreatedOn;
        self.isStarred = 0
        self.uniqueIdentifier = NSUUID().UUIDString
        self.objectID = nil;
    }
    
    init()
    {
        self.uniqueIdentifier = NSUUID().UUIDString
        self.taskStatusId = TaskStatusEnum.Pending.rawValue;
        self.objectID = nil;
        self.isStarred = 0
    }
    
    
    func validateTaskVM() -> (valid: Bool, ErrorMessage: String?)
    {
        if self.taskTitle == ""
        {
            return (false, "Title is required.");
        }
        else if self.taskDeadline!.isLessThanDate(NSDate())
        {
            return(false, "Completion date cannot be before current time.");
        }
        else
        {
            return (true, nil);
        }
        
    }
    
    func CreateTaskEntityForTaskVM() -> Tasks
    {
        let da = TasksDA();
        
        let entityTask = da.GetEmptyTask();
        
        entityTask.taskTitle = self.taskTitle
        entityTask.taskDescription = self.taskDescription
        entityTask.taskStatusId = self.taskStatusId
        entityTask.taskDeadline = self.taskDeadline
        entityTask.taskCreatedOn = self.taskCreatedOn
        entityTask.uniqueIdentifier = self.uniqueIdentifier
        entityTask.isStarred = self.isStarred
        
        if(self.taskGroup != nil)
        {
            entityTask.taskGroup = TaskGroupsDA.GetTaskGroupByTaskGroupVM(self.taskGroup!)
        }
        return entityTask;
    }
    
    func CreateTaskEntityForTaskVM(taskVM: TaskVM) -> Tasks
    {
        let da = TasksDA();
        
        let entityTask = da.GetEmptyTask();
        
        entityTask.taskTitle = taskVM.taskTitle
        entityTask.taskDescription = taskVM.taskDescription
        entityTask.taskStatusId = taskVM.taskStatusId
        entityTask.taskDeadline = taskVM.taskDeadline
        entityTask.taskCreatedOn = taskVM.taskCreatedOn
        entityTask.uniqueIdentifier = taskVM.uniqueIdentifier
        entityTask.isStarred = taskVM.isStarred
        
        if(self.taskGroup != nil)
        {
            entityTask.taskGroup = TaskGroupsDA.GetTaskGroupByTaskGroupVM(self.taskGroup!)
        }
        
        return entityTask;
    }
    
    
    static func CreateTaskVMForTaskEntity(taskEntity: Tasks) -> TaskVM
    {
        var taskVM = TaskVM()
        
        taskVM.taskTitle = taskEntity.taskTitle
        taskVM.taskDescription = taskEntity.taskDescription
        taskVM.taskStatusId = taskEntity.taskStatusId
        taskVM.taskDeadline = taskEntity.taskDeadline
        taskVM.taskCreatedOn = taskEntity.taskCreatedOn
        taskVM.uniqueIdentifier = taskEntity.uniqueIdentifier
        taskVM.isStarred = taskEntity.isStarred
        taskVM.objectID = taskEntity.objectID
       
        return taskVM
    }
    
    
    
    
    
    
    
    
    
}