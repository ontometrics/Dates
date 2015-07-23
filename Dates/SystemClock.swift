//
//  SystemClock.swift
//  d-minder
//
//  Created by Noura on 5/13/15.
//  Copyright (c) 2015 Ontometrics. All rights reserved.
//

import Foundation

@objc
class SystemClock : NSObject {
    
    static var shift:Double = 0
    static var useSpecificDate = false //turn this to true to use the date in specificDay property
    static var specificDay:Dictionary<String, Int> = ["day": 2, "month": 12, "year": 2015, "hour": 12, "minute": 30]
    
    static func now() -> NSDate {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            
            if let date = dateForSimulationTime() where useSpecificDate == false {
                return date
            }
            
            if (useSpecificDate){
                return dateForSpecificDay()
            }else{
                
                return NSDate(timeIntervalSinceNow: shift * 3600)
                
            }
        #else
            return NSDate()
        #endif
    }
    
    private static func dateForSpecificDay() -> NSDate {
        let parts:NSDateComponents = NSDateComponents()
        parts.day = specificDay["day"]!
        parts.month = specificDay["month"]!
        parts.year = specificDay["year"]!
        parts.hour = specificDay["hour"]!
        parts.minute = specificDay["minute"]!
        parts.second = 0
        parts.timeZone = NSTimeZone.localTimeZone()
        let calendar = NSCalendar.currentCalendar()
        return calendar.dateFromComponents(parts)!
    }
    
    /**
    * Date by adding timeInterval from run arguments
    */
    private static func dateForSimulationTime() -> NSDate? {
        let args = NSArray(array:NSProcessInfo.processInfo().arguments)
        let filteredArgs = args.filteredArrayUsingPredicate(NSPredicate(format: "SELF contains[cd] %@", "simulationTimeInterval"))
        if(filteredArgs.count > 0){
            if let arg = filteredArgs[0] as? NSString {
                let value : NSString = arg.componentsSeparatedByString("=")[1] as NSString
                let shift = value.doubleValue * 60 * 60
                return NSDate(timeIntervalSinceNow: shift)
            }
        }
        return nil
    }

}
