//
//  AppSettingsDA.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/9/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import UIKit
import CoreData


struct AppSettingsDA
{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    
    func GetEmptyAppSetting() -> AppSettings
    {
        
        let managedContext = self.appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("AppSettings", inManagedObjectContext:managedContext)
        
        return NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! AppSettings
    }
    
    
    func UpdateAppSetting(key: String, value: String)
    {
        let managedContext = self.appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "AppSettings")
        
        fetchRequest.predicate = NSPredicate(format: "settingName = %@", key)

        do {
            let results = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            if results.count > 0
            {
                let dbRecord = results[0] as! AppSettings;
                dbRecord.settingValue = value;
                try managedContext.save()
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    

    
    
    func GetAppSettingByKey(key: String) -> String
    {
        var settingValue = ""
        
        let managedContext = self.appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "AppSettings")
        
        fetchRequest.predicate = NSPredicate(format: "settingName = %@", key)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            if results.count > 0
            {
                let dbRecord = results[0] as! AppSettings;
                settingValue = dbRecord.settingValue!;
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return settingValue;
    }
    
}