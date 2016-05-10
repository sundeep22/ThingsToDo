//
//  PreloadData.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/9/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct PreloadData {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    

    
    func ReadSettings() -> [AppSettingsVM]
    {
        var appSettingsResult = [AppSettingsVM]()
        
        if let path = NSBundle.mainBundle().pathForResource("AppSettings", ofType: "json")
        {
            
            if let jsonData = NSData(contentsOfFile: path)
            {
                
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options:.AllowFragments)
                    
                    if let appSettings = json["AppSettings"] as? [[String: AnyObject]] {
                        
                        for appSetting in appSettings {
                            
                            var localAppSetting = AppSettingsVM()
                            
                            localAppSetting.settingName = appSetting["settingName"] as? String;
                            localAppSetting.settingValue = appSetting["settingValue"] as? String;
                            
                            appSettingsResult.append(localAppSetting)

                        }
                        
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        return appSettingsResult;
    }
    
    func preloadData () {
            // Remove all the menu items before preloading
            removeData()
        
        let appSettings = self.ReadSettings()
        let managedObjectContext = self.appDelegate.managedObjectContext
        
        
        for appSetting in appSettings {
            
            
            let entity =  NSEntityDescription.entityForName("AppSettings", inManagedObjectContext:managedObjectContext)
            
            let dbAppSetting = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext) as! AppSettings

            dbAppSetting.settingName = appSetting.settingName
            dbAppSetting.settingValue = appSetting.settingValue
            
            do {
                try managedObjectContext.save()
                print("<-------- Created new app setting \(dbAppSetting.settingName)!! -------->")
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        
        }
        }
    
    
    func removeData () {
        // Remove the existing items
        let managedObjectContext = self.appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "AppSettings")
        
        do {
            let appSettings =
                try managedObjectContext.executeFetchRequest(fetchRequest) as! [AppSettings]
            
            for appSetting in appSettings as [NSManagedObject]
            {
                managedObjectContext.deleteObject(appSetting)
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    
        }
    
    
}