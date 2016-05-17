//
//  TasksDA.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/6/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import UIKit
import CoreData


struct TasksDA
{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    

    
    func GetEmptyTask() -> Tasks
    {
        
        let managedContext = self.appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Tasks", inManagedObjectContext:managedContext)
    
        return NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Tasks
    }
    
    func UpdateTaskInDB(taskVM: TaskVM) -> Bool
    {
        print("Update Task In DB Called..");
        let managedContext = self.appDelegate.managedObjectContext
        let task = managedContext.objectWithID(taskVM.objectID as! NSManagedObjectID) as! Tasks
        
        task.taskTitle = taskVM.taskTitle
        task.taskDescription = taskVM.taskDescription
        task.taskDeadline = taskVM.taskDeadline
        task.taskStatusId = taskVM.taskStatusId
        do {
            try managedContext.save()
            print("Congratulations!!")
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return true;
    }

    func UpdateTaskInDB(task: Tasks) -> Bool
    {
       
        let managedContext = self.appDelegate.managedObjectContext
        
        do {
            try managedContext.save()
            print("Congratulations!!")
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return true;
    }


    func StoreTaskInDB(taskVM: TaskVM) -> NSManagedObjectID
    {
        print("Store Task In DB Called..");
        
        let task = taskVM.CreateTaskEntityForTaskVM()
        let managedContext = task.managedObjectContext// self.appDelegate.managedObjectContext
        
        do {
            try managedContext!.save()
            print("Congratulations!!")
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return task.objectID
    }
    
    func GetAllTasksOrderByDateCreated() -> [Tasks]
    {
        print("Get all Tasks Order By Date Created -- got called");
        
        var allTasks: [Tasks] = [Tasks]();
        
        let managedContext = self.appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Tasks")
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            let resss = results as! [NSManagedObject]
            
            
            for result in resss as [NSManagedObject]
            {
                allTasks.append(result as! Tasks)
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return allTasks.sort({ ($0.taskCreatedOn?.isLessThanDate($1.taskCreatedOn!))! });

    }
    
    func GetAllTasks() -> [TaskVM]
    {
        print("Get all Tasks got called");
    
        var allTasks: [TaskVM] = [TaskVM]();
        
        let managedContext = self.appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Tasks")
    
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            let resss = results as! [NSManagedObject]
            
            for result in resss as [NSManagedObject]
            {
                allTasks.append(TaskVM.CreateTaskVMForTaskEntity(result as! Tasks));
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return allTasks;
    }
    
    func GetTaskByUniqueID(uniqueID: String) -> Tasks
    {
        var task = Tasks?();
        
        let managedContext = self.appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Tasks")
        
        fetchRequest.predicate = NSPredicate(format: "uniqueIdentifier = %@", uniqueID)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            print(results)
            
            if(results.count > 0)
            {
                task = results[0] as? Tasks;
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return task!;
    }
    
    func SetStarValueToTask(uniqueID: String, starred: Int32)
    {
        let task = GetTaskByUniqueID(uniqueID)
        
        let managedContext = self.appDelegate.managedObjectContext
        
        task.isStarred = starred
        
        do {
            try managedContext.save()
            print("Congratulations!!")
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func DeleteATask(taskToDelete: TaskVM)
    {
        let managedContext = self.appDelegate.managedObjectContext
        
        let task = managedContext.objectWithID(taskToDelete.objectID as! NSManagedObjectID) as! Tasks
        
        managedContext.deleteObject(task)
        
        do {
            try managedContext.save()
            print("Deleted Successfully!")
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        
        
    }
    
    func DeleteATask(taskToDelete: Tasks)
    {
        let managedContext = self.appDelegate.managedObjectContext
        
        managedContext.deleteObject(taskToDelete)
        
        do {
            try managedContext.save()
            print("Deleted Successfully!")
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        
        
    }

}