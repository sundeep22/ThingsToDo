//
//  MyNotificationCenter.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/12/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import Foundation
import UIKit

class MyNotificationCenter
{
    static func AddNotificationForTaskVM(taskVM: TaskVM)
    {
        let notification = UILocalNotification()
        
        notification.alertTitle = taskVM.taskTitle
        notification.alertBody = taskVM.taskDescription
        notification.alertAction =  "You've Got a Thing To Do!!"
        
        var userInfoDictionary = [String:String]()
        userInfoDictionary["notificationKey"] = taskVM.uniqueIdentifier
        
        notification.userInfo = userInfoDictionary;
        
        
        
        notification.fireDate = taskVM.taskDeadline!.dateByAddingTimeInterval(-100)
        notification.soundName = UILocalNotificationDefaultSoundName
        
        
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification);
        
        
    }
    
    static func DeleteNotificationsForTaskVM(taskVM: TaskVM)
    {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if (notification.userInfo != nil) {
                
                var userInfoKeyValues = notification.userInfo as! [String:String];
                
                if userInfoKeyValues["notificationKey"] == taskVM.uniqueIdentifier
                {
                    UIApplication.sharedApplication().cancelLocalNotification(notification)
                    break
                }
            }
        }
    }
    
//    static func UpdateNotificationsForTaskVM(taskVM: TaskVM)
//    {
//        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
//            if (notification.userInfo != nil) {
//                
//                var userInfoKeyValues = notification.userInfo as! [String:String];
//                
//                if userInfoKeyValues["notificationKey"] == taskVM.uniqueIdentifier
//                {
//                    UIApplication.sharedApplication().cancelLocalNotification(notification)
//                    break
//                }
//            }
//        }
//    }
    
    
    
}