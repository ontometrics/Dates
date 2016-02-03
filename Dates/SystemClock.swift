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
    static var specificDay:Dictionary<String, Int> = ["day": 3, "month": 2, "year": 2016, "hour": 12, "minute": 02 ]
    
    static func now() -> NSDate {
        #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS))
        
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
}
