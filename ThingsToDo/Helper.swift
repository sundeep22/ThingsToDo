//
//  Helper.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/7/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import UIKit

struct MyUIHelper {
    
    static func CreateUIColorFromCodes(red: Float, green: Float, blue: Float, alpha: Float) -> UIColor
    {
        
        return UIColor(colorLiteralRed: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
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
    
    static func GetDayOrMonth(date: NSDate) -> String
    {
        var returnValue = ""
        let startDate = MyUIHelper.get(.Previous, "Sunday", considerToday: true)
        let endDate = MyUIHelper.get(.Next, "Saturday", considerToday: true)
        
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        
        
        let startTime = cal.startOfDayForDate(startDate)
        let endTime = cal.dateBySettingHour(23, minute: 59, second: 59, ofDate: endDate, options: NSCalendarOptions.MatchNextTime)
        
        if(date > startTime && date < endTime)
        {
            //get 3 char week here
            
       
            let dayTimePeriodFormatter = NSDateFormatter()
            dayTimePeriodFormatter.dateFormat = "EEE"
            
            returnValue = dayTimePeriodFormatter.stringFromDate(date)

        }
        else
        {
            let dayTimePeriodFormatter = NSDateFormatter()
            dayTimePeriodFormatter.dateFormat = "MMM dd"
            
            returnValue = dayTimePeriodFormatter.stringFromDate(date)
        }
        return returnValue
    }
    
    static func GetTimeOrDay(date: NSDate) -> String
    {
        var returnValue = ""
        let startDate = MyUIHelper.get(.Previous, "Sunday", considerToday: true)
        let endDate = MyUIHelper.get(.Next, "Saturday", considerToday: true)
        
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        
        
        let startTime = cal.startOfDayForDate(startDate)
        let endTime = cal.dateBySettingHour(23, minute: 59, second: 59, ofDate: endDate, options: NSCalendarOptions.MatchNextTime)
        
        if(date > startTime && date < endTime)
        {
            //get 3 char week here
            
            
            let dayTimePeriodFormatter = NSDateFormatter()
            dayTimePeriodFormatter.dateFormat = "h:mm a"
            
            returnValue = dayTimePeriodFormatter.stringFromDate(date)
            
        }
        else
        {
            let dayTimePeriodFormatter = NSDateFormatter()
            dayTimePeriodFormatter.dateFormat = "yyyy"
            
            returnValue = dayTimePeriodFormatter.stringFromDate(date)
        }
        return returnValue
    }
    
    static func GetHeaderBlue2() -> UIColor
    {
        return CreateUIColorFromCodes(27, green: 73, blue: 101, alpha: 1.0)
    }
    
    
    static func GetHeaderBlue1() -> UIColor
    {
        return CreateUIColorFromCodes(2, green: 100, blue: 154, alpha: 1.0)
    }
    
    
        static func GetThemeRed() -> UIColor
    {
        return MyUIHelper.CreateUIColorFromCodes(
            193, green: 73, blue: 58, alpha: 1)

    }
    
    static func GetThemeGreen() -> UIColor
    {
        return MyUIHelper.CreateUIColorFromCodes(2, green: 195, blue: 154, alpha: 1)
    }


}