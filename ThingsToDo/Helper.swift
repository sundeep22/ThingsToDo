//
//  Helper.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/7/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import UIKit

struct MyUIHelper {
    
    static func ShowError(sender: UIViewController, userMessage: String?)
    {
        let alertController = UIAlertController(title: "Error", message:
            userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        sender.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    static func getWeekDaysInEnglish() -> [String] {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        calendar.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarOptions: NSCalendarOptions {
            switch self {
            case .Next:
                return .MatchNextTime
            case .Previous:
                return [.SearchBackwards, .MatchNextTime]
            }
        }
    }
    
    static func get(direction: SearchDirection, _ dayName: String, considerToday consider: Bool = false) -> NSDate {
        let weekdaysName = getWeekDaysInEnglish()
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let nextWeekDayIndex = weekdaysName.indexOf(dayName)! + 1 // weekday is in form 1 ... 7 where as index is 0 ... 6
        
        let today = NSDate()
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        if consider && calendar.component(.Weekday, fromDate: today) == nextWeekDayIndex {
            return today
        }
        
        let nextDateComponent = NSDateComponents()
        nextDateComponent.weekday = nextWeekDayIndex
        
        
        let date = calendar.nextDateAfterDate(today, matchingComponents: nextDateComponent, options: direction.calendarOptions)
        return date!
    }

}