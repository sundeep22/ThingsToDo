//
//  TaskGroupsDA.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/11/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import CoreData
import UIKit


struct TaskGroupsDA
{
    let tasksDA = TasksDA()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func GetEmptyTaskGroup() -> TaskGroups
    {
        
        let managedContext = self.appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("TaskGroups", inManagedObjectContext:managedContext)
        
        return NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! TaskGroups
    }
    
    func UpdateTaskGroupInDB(taskGroupVM: TaskGroupsVM) -> Bool
    {
        print("Update Task In DB Called..");
        let managedContext = self.appDelegate.managedObjectContext
        let taskGroup = managedContext.objectWithID(taskGroupVM.objectID as! NSManagedObjectID) as! TaskGroups
        
            taskGroup.taskGroupName = taskGroupVM.taskGroupName
            taskGroup.dateCreated = taskGroupVM.dateCreated
        
        do {
            try managedContext.save()
            print("Congratulations!!")
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return true;
    }
    
    func StoreTaskGroupInDB(taskGroupVM: TaskGroupsVM) -> Bool
    {
        print("Store Task Group In DB Called..");
        
        let dbTaskGroup = taskGroupVM.CreateTaskGroupEntityForTaskGroupVM(taskGroupVM)
        let managedContext = dbTaskGroup.managedObjectContext
        
        do {
            try managedContext!.save()
            print("Congratulations!!")
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return true;
        
    }
    
    func GetAllTaskGroups() -> [TaskGroupsVM]
    {
        print("Get all Task Groups got called");
        
        var allTaskGroups: [TaskGroupsVM] = [TaskGroupsVM]();
        
        let managedContext = self.appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "TaskGroups")
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
          
            
            for result in results as [NSManagedObject]
            {
                allTaskGroups.append(TaskGroupsVM.CreateTaskGroupsVMForTaskGruopsEntity(result as! TaskGroups));
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return allTaskGroups;
    }

    func GetAllTasksForTaskGroups(taskGroupVM: TaskGroupsVM) -> [TaskVM]
    {
        print("Get all Task Groups got called");
        
        var allTasks: [TaskVM] = [TaskVM]();
        
        print("Update Task In DB Called..");
        let managedContext = self.appDelegate.managedObjectContext
        let taskGroup = managedContext.objectWithID(taskGroupVM.objectID as! NSManagedObjectID) as! TaskGroups
    
        let results = taskGroup.tasks!.allObjects as! [NSManagedObject]
        
        
        for result in results as [NSManagedObject]
        {
            allTasks.append(TaskVM.CreateTaskVMForTaskEntity(result as! Tasks));
        }
            
        
        return allTasks;
    }
    
    static func GetTaskGroupByTaskGroupVM(taskGroupVM: TaskGroupsVM) -> TaskGroups
    {
        
        print("GetTaskGroupByTaskGroupVM In DB Called..");
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let taskGroup = managedContext.objectWithID(taskGroupVM.objectID as! NSManagedObjectID) as! TaskGroups

        return taskGroup;
    }
    
    func InsertTaskIntoTaskGroup(taskGroupVM: TaskGroupsVM, taskVM: TaskVM) -> Bool
    {
        let managedContext = self.appDelegate.managedObjectContext
        let taskGroup = managedContext.objectWithID(taskGroupVM.objectID as! NSManagedObjectID) as! TaskGroups
        
        var tasksInGroup = taskGroup.tasks!.allObjects as! [Tasks]
        tasksInGroup.append(taskVM.CreateTaskEntityForTaskVM())

        do {
            try managedContext.save()
            print("Congratulations!!")
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return true;
        

    }

    func DeleteATaskGroup(taskGroupToDelete: TaskGroupsVM)
    {
        let managedContext = self.appDelegate.managedObjectContext
        
        let taskGroup = managedContext.objectWithID(taskGroupToDelete.objectID as! NSManagedObjectID) as! TaskGroups
        
        for task in taskGroup.tasks!
        {
            tasksDA.DeleteATask(task as! Tasks)
        }
        
        managedContext.deleteObject(taskGroup)

        
        do {
            try managedContext.save()
            print("Deleted Successfully!")
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        
        
    }
    
    func DoesGroupHavePendingTasks(taskGroup: TaskGroupsVM) -> Bool
    {
        var containsPending = false
        
        let managedContext = self.appDelegate.managedObjectContext
        
        let taskGroup = managedContext.objectWithID(taskGroup.objectID as! NSManagedObjectID) as! TaskGroups
        
        for task in taskGroup.tasks!
        {
            if(task as! Tasks).taskStatusId == TaskStatusEnum.Pending.rawValue
            {
                containsPending = true
                break
            }
        }
        return containsPending
        
    }

    func MarkAllTasksInTaskGroup(taskGroupToDelete: TaskGroupsVM, status: TaskStatusEnum)
    {
        let managedContext = self.appDelegate.managedObjectContext
        
        let taskGroup = managedContext.objectWithID(taskGroupToDelete.objectID as! NSManagedObjectID) as! TaskGroups
        
        for task in taskGroup.tasks!
        {
            let localTask = task as! Tasks
            localTask.taskStatusId = status.rawValue
            
            tasksDA.UpdateTaskInDB(localTask)
        }
        
    }

}