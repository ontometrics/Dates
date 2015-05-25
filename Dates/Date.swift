//
//  Date.swift
//  dminder-ios
//
//  Created by Rob Williams on 8/2/14.
//  Copyright (c) 2014 ontometrics. All rights reserved.
//

import Foundation
import Darwin

public class TimeInterval : NSObject {
    
    public var offset:Double
    
    public init(offset:Double){
        self.offset = offset
    }
    
    public func span() -> TimeSpan {
        return TimeSpan(offset: self.offset)
    }
    
}

func convertToRadians(degrees:Double) -> Double {
    return (degrees / 180.0 * M_PI)
}

public class Date : TimeInterval, NSCoding, Equatable, Printable, DebugPrintable {
    
    public var moonPhase:Int {
        get {
            let yearsSince1900 = year() - 1900
            let monthValue = 1.0 * Double(month()) - 0.5
            
            let n = floor(12.37 * (Double(yearsSince1900) + ((monthValue)/12.0)))
            let t = n / 1236.85
            let t2 = t * t
            let asin = 359.2242 + 29.105356 * n
            let am = 306.0253 + 385.816918 * n + 0.010730 * t2
            let xtra = 0.75933 + 1.53058868 * n + ((1.178e-4) - (1.55e-7) * t) * t2;
            let radiansOfAsin = convertToRadians(asin)
            let radiansOfAm = convertToRadians(am)
            let firstSetValue = 0.1734 - 3.93e-4 * t
            let additionalValue = firstSetValue * sin(radiansOfAsin) - 0.4068 * sin(radiansOfAm)
            let xtra2 = xtra + additionalValue
            let i = (xtra2 > 0.0 ? floor(xtra2) :  ceil(xtra2 - 1.0))
            
            let julianDay = self.julianDay
            let j1 = Int((2415020 + 28 * n) + i)
            
            return (julianDay - j1 + 30) % 30
        }
    }
    
    public var julianDay:Int {
        get {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "g"
            return formatter.stringFromDate(self.date()).toInt()!
        }
    }
    
    public var dayOfTheYear:Int {
        get {
            let calendar = NSCalendar.currentCalendar()
            return calendar.ordinalityOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitYear, forDate: self.date())
        }
    }
    
    override public var description:String {
        get{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd MMM yyyy, HH:mm:ss a "
            return formatter.stringFromDate(date())
        }
    }
    
    public override var debugDescription:String {
        get{
            return self.description
        }
    }

    public override init(offset:Double){
        super.init(offset: offset)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(offset: aDecoder.decodeDoubleForKey("offset"))
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(self.offset, forKey: "offset")
    }
    
    public convenience init(){
        let time:NSDate = SystemClock.now()
        self.init(offset: time.timeIntervalSince1970)
    }
    
    public convenience init(year:Int, month:Int, day:Int, hour:Int = 0, minute:Int = 0, second:Int = 0,
        timeZone:NSTimeZone = NSTimeZone.localTimeZone()){
        var parts:NSDateComponents = NSDateComponents()
        parts.day = day
        parts.month = month
        parts.year = year
        parts.hour = hour
        parts.minute = minute
        parts.second = second
        parts.timeZone = timeZone
        let calendar = NSCalendar.currentCalendar()
        let date:NSDate! = calendar.dateFromComponents(parts)
        self.init(offset: Double(date.timeIntervalSince1970))
    }
    
    public convenience init(oldDate:NSDate){
        self.init(offset: oldDate.timeIntervalSince1970)
    }
    
    func add(interval:TimeInterval){
        offset += interval.offset;
    }
    
    func subtract(interval:TimeInterval){
        offset -= interval.offset
    }
    
    func dateBySettingTime(hour:Int, minute: Int) -> Date{
        var parts:NSDateComponents = NSDateComponents()
        parts.day = day()
        parts.month = month()
        parts.year = year()
        parts.hour = hour
        parts.minute = minute
        parts.second = 0
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let date:NSDate! = calendar.dateFromComponents(parts)
        return Date(offset: Double(date.timeIntervalSince1970))
    }
    
    public func date() -> NSDate {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        return NSDate(timeIntervalSince1970: offset)
    }
    
    public func minute() -> Int {
        return Adapter().component(self, calendarUnit: .CalendarUnitMinute)
    }

    public func hour() -> Int {
        return Adapter().component(self, calendarUnit: .CalendarUnitHour)
    }

    public func day() -> Int {
        return Adapter().component(self, calendarUnit: .CalendarUnitDay)
    }
    
    public func month() -> Int {
        return Adapter().component(self, calendarUnit: .CalendarUnitMonth)
    }
    
    public func year() -> Int {
        return Adapter().component(self, calendarUnit: .CalendarUnitYear)
    }
    
    public func spanFromNow() -> TimeSpan {
        return self - Date()
    }

}

private class Adapter {
    
    func component(date:Date, calendarUnit:NSCalendarUnit) -> Int {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        return calendar.component(calendarUnit, fromDate: convert(date))
    }
    
    func convert(date:Date) -> NSDate {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        return NSDate(timeIntervalSince1970: date.offset)
    }
    
}

public struct CalendarQuantity {
    let amount:Int
    let units:NSCalendarUnit
    
    public init(amount:Int, units: NSCalendarUnit){
        self.amount = amount
        self.units = units
    }
    
}

/**
 * Treating time spans as just 
 */
class NewTimeSpan {

    let days:Int
    let hours:Int
    let minutes:Int
    let seconds:Int
    let weeks:Int
    let months:Int
    let years:Int
    
    init(years:Int = 0, months:Int = 0, weeks:Int = 0, days:Int = 0, hours:Int = 0, minutes:Int = 0, seconds:Int = 0){
        self.years = years
        self.months = months
        self.weeks = weeks
        self.days = days
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
    
}

public class TimeSpan : TimeInterval, Equatable, Printable, DebugPrintable {
    
    let hoursPerDay:Int = 24
    let minutesPerHour:Int = 60
    let secondsPerMinute:Int = 60
    let daysPerYear = 365
    
    public override var description:String {
        get{
            return "\(minutes()):\(seconds() - (minutes() * 60))"
        }
    }

    public override var debugDescription:String {
        get{
            return self.description
        }
    }
    
    public override init(offset: Double){
        super.init(offset: offset)
    }
    
    public convenience init(days:Int = 0, hours:Int = 0, minutes:Int = 0, seconds:Int = 0){
        self.init(offset: 0)
        let totalSeconds = (days * secondsPerDay()) + (hours * secondsPerHour()) + (minutes * minutesPerHour) + seconds
        self.offset = Double(totalSeconds)
    }
    
    func secondsPerDay() -> Int {
        return self.hoursPerDay * minutesPerHour * secondsPerMinute
    }
    
    func secondsPerYear() -> Int {
        return secondsPerDay() * daysPerYear
    }

    func secondsPerHour() -> Int {
        return secondsPerMinute * minutesPerHour
    }
    
    public func seconds() -> Int {
        return Int(offset)
    }
    
    public func minutes() -> Int {
        return Int(offset / Double(secondsPerMinute))
    }
    
    public func hours() -> Int {
        return Int(offset / Double(secondsPerHour()))
    }

    public func days() -> Int {
        return Int(offset / Double(secondsPerDay()))
    }
    
    public func years() -> Int {
        return Int(offset / Double(secondsPerYear()))
    }
    
    public func shortDescription(showSeconds:Bool = true) -> String {
        let totalAsSeconds = seconds()
        var string = ""
        switch totalAsSeconds {
        case 0...60:
            string = "\(totalAsSeconds)s"
        case 60...secondsPerHour():
            string = showSeconds ? "\(minutes())m \(seconds() - (minutes() * 60))s" : "\(minutes())m"            
        case secondsPerHour()...secondsPerDay():
            string = "\(hours())h \(minutes() - (hours() * 60))m"
        default:
            string = "\(days())d"
        }
        return string
    }
    
    public func asReadableString() -> String {
        let totalAsSeconds = seconds()
        var string = ""
        switch totalAsSeconds {
        case 0...60:
            string = "\(totalAsSeconds) seconds"
        case 60...secondsPerHour():
            string = "\(minutes()) minutes"
        case secondsPerHour()...secondsPerDay():
            string = "\(hours()) hours"
        default:
            string = ""
        }
        return string
    }
    
}

public func == (lhs:Date, rhs:Date) -> Bool {
    return lhs.offset==rhs.offset
}

public func == (lhs:TimeSpan, rhs:TimeSpan) -> Bool {
    return lhs.offset==rhs.offset
}

public func < (left:Date, right:Date) -> Bool {
    return left.date().laterDate(right.date()) != left.date()
}

public func > (left:Date, right:Date) -> Bool {
    return left.date().earlierDate(right.date()) != left.date()
}

public func >= (left:Date, right:Date) -> Bool {
    return left.date().earlierDate(right.date()) != left.date() || left == right
}

public func - (left:Date, right:Date) -> TimeSpan {
    return TimeSpan(offset: left.date().timeIntervalSinceDate(right.date()))
}

public func + (left:Date, right:TimeInterval) -> Date {
    return Date(offset: left.offset + right.offset)
}

public func + (left:TimeSpan, right:TimeSpan) -> TimeSpan {
    return TimeSpan(offset: left.offset + right.offset)
}

public func + (left:Date, calendarAmount:CalendarQuantity) -> Date {
    return Date(oldDate: NSCalendar.currentCalendar().dateByAddingUnit(calendarAmount.units, value: calendarAmount.amount, toDate: NSDate(), options: nil)!)
}

public func += (left:Date, right:TimeInterval) -> Date {
    left.add(right)
    return left
}

public func - (left:Date, right:TimeInterval) -> Date {
    return Date(offset: left.offset - right.offset)
}

public func - (left:TimeSpan, right:TimeSpan) -> TimeSpan {
    return TimeSpan(offset: left.offset - right.offset)
}


public func / (left:TimeSpan, right:TimeSpan) -> Double {
    return left.offset / right.offset
}

public func > (left:TimeSpan, right:Int) -> Bool {
    return left.offset > 0
}


