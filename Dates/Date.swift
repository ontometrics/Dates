//
//  Date.swift
//  dminder-ios
//
//  Created by Rob Williams on 8/2/14.
//  Copyright (c) 2014 ontometrics. All rights reserved.
//

import Foundation
import Darwin

public protocol Time {
    var offset:Double {get}
    
    static func secondsPerHour() -> Int
    static func secondsPerDay() -> Int
    static func secondsPerYear() -> Int
}

public extension Time {
    
    static func hoursPerDay() -> Int {
        return 24
    }
    
    static func minutesPerHour() -> Int {
        return 60
    }
    
    static func secondsPerMinute() -> Int {
        return 60
    }
    
    static func daysPerYear() -> Int {
        return 365
    }
    
    static func secondsPerDay() -> Int {
        return hoursPerDay() * minutesPerHour() * secondsPerMinute()
    }
    
    static func secondsPerYear() -> Int {
        return secondsPerDay() * daysPerYear()
    }
    
    static func secondsPerHour() -> Int {
        return secondsPerMinute() * minutesPerHour()
    }
}

public struct TimeInterval : Time {
    
    public let offset:Double
    
    public init(_ offset:Double){
        self.offset = offset
    }
    
    public func span() -> TimeSpan {
        return TimeSpan(offset)
    }
}

public struct TimeSpan : Time {
    
    public let offset: Double
    
    public init(_ offset: Double){
        self.offset = offset
    }
    
    public init(days:Int = 0, hours:Int = 0, minutes:Int = 0, seconds:Int = 0){
        let totalSeconds = (days * TimeSpan.secondsPerDay()) + (hours * TimeSpan.secondsPerHour()) + (minutes * TimeSpan.minutesPerHour()) + seconds
        self.init(Double(totalSeconds))
    }
    
    public func seconds() -> Int {
        return Int(offset)
    }
    
    public func minutes() -> Int {
        return Int(offset / Double(TimeSpan.secondsPerMinute()))
    }
    
    public func hours() -> Int {
        return Int(offset / Double(TimeSpan.secondsPerHour()))
    }
    
    public func days() -> Int {
        return Int(offset / Double(TimeSpan.secondsPerDay()))
    }
    
    public func years() -> Int {
        return Int(offset / Double(TimeSpan.secondsPerYear()))
    }
    
}

public enum FormatType {
    case Long
    case Medium
    case Short
}

protocol ReadableString {
    func asReadableString(type: FormatType) -> String
}

extension TimeSpan: CustomStringConvertible, CustomDebugStringConvertible, ReadableString {
    public var description:String {
        get{
            return "\(minutes()):\(seconds() - (minutes() * 60))"
        }
    }
    
    public var debugDescription:String {
        get{
            return self.description
        }
    }
    
    public func asReadableString(type: FormatType) -> String {
        switch type{
        case .Long:
            return readableString()
        case .Medium:
            return shortReadableString()
        case .Short:
            return shortReadableString(false)
        }
    }
    
    private func readableString() -> String {
        let totalAsSeconds = seconds()
        var string = ""
        switch totalAsSeconds {
        case 0...60:
            string = "\(totalAsSeconds) seconds"
        case 60...TimeSpan.secondsPerHour():
            string = "\(minutes()) minutes"
        case TimeSpan.secondsPerHour()...TimeSpan.secondsPerDay():
            string = "\(hours()) hours"
        default:
            string = ""
        }
        return string
    }
    
    private func shortReadableString(showSeconds:Bool = true) -> String {
        let totalAsSeconds = seconds()
        var string = ""
        switch totalAsSeconds {
        case 0...60:
            string = "\(totalAsSeconds)s"
        case 60...TimeSpan.secondsPerHour():
            string = showSeconds ? "\(minutes())m \(seconds() - (minutes() * 60))s" : "\(minutes())m"
        case TimeSpan.secondsPerHour()...TimeSpan.secondsPerDay():
            string = "\(hours())h \(minutes() - (hours() * 60))m"
        default:
            string = "\(days())d"
        }
        return string
    }
}

public struct Date {
    public let time: TimeSpan
    
    
    public init(_ offset:Double){
        time = TimeSpan(offset)
    }

    public init(_ aTime: TimeSpan){
        time = aTime
    }

    public init(){
        let time:NSDate = SystemClock.now()
        self.init(time.timeIntervalSince1970)
    }
    
    public init(year:Int, month:Int, day:Int, hour:Int = 0, minute:Int = 0, second:Int = 0,
        timeZone:NSTimeZone = NSTimeZone.localTimeZone()){
            let parts:NSDateComponents = NSDateComponents()
            parts.day = day
            parts.month = month
            parts.year = year
            parts.hour = hour
            parts.minute = minute
            parts.second = second
            parts.timeZone = timeZone
            
            let calendar = NSCalendar.currentCalendar()
            let date:NSDate! = calendar.dateFromComponents(parts)
            self.init(Double(date.timeIntervalSince1970))
    }
    
    public init(oldDate:NSDate){
        self.init(oldDate.timeIntervalSince1970)
    }
    
    public func date() -> NSDate {
        return NSDate(timeIntervalSince1970: time.offset)
    }
    
    private func component(date:Date, calendarUnit:NSCalendarUnit) -> Int {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        return calendar.component(calendarUnit, fromDate: date.date())
    }
    
    public func minute() -> Int {
        return component(self, calendarUnit: .Minute)
    }
    
    public func hour() -> Int {
        return component(self, calendarUnit: .Hour)
    }
    
    public func day() -> Int {
        return component(self, calendarUnit: .Day)
    }
    
    public func month() -> Int {
        return component(self, calendarUnit: .Month)
    }
    
    public func year() -> Int {
        return component(self, calendarUnit: .Year)
    }
    
    public func spanFromNow() -> TimeSpan {
        return self - Date()
    }
    
    public func sameDayAs(otherDate:Date) -> Bool {
        return self.year()==otherDate.year() && self.month()==otherDate.month() && self.day()==otherDate.day()
    }
    
    func dateBySettingTime(hour:Int, minute: Int) -> Date{
        let parts:NSDateComponents = NSDateComponents()
        parts.day = day()
        parts.month = month()
        parts.year = year()
        parts.hour = hour
        parts.minute = minute
        parts.second = 0
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let date:NSDate! = calendar.dateFromComponents(parts)
        return Date(Double(date.timeIntervalSince1970))
    }


}

extension Date : CustomStringConvertible, CustomDebugStringConvertible{
    public var description:String {
        get{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd MMM yyyy, HH:mm:ss a "
            return formatter.stringFromDate(date())
        }
    }
    
    public var debugDescription:String {
        get{
            return self.description
        }
    }
}

extension Double {
    var toRadian: Double {
        get{ return (self / 180.0 * M_PI) }
    }
}
protocol MoonPhase {
    var julianDay: Int {get}
    var dayOfTheYear: Int { get }
    var moonPhase: Int {get}
    
}

extension Date : MoonPhase {
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
            let radiansOfAsin = asin.toRadian
            let radiansOfAm = am.toRadian
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
            return Int(formatter.stringFromDate(self.date()))!
        }
    }
    
    public var dayOfTheYear:Int {
        get {
            let calendar = NSCalendar.currentCalendar()
            return calendar.ordinalityOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Year, forDate: self.date())
        }
    }
}

extension TimeInterval : Equatable {}
public func == (lhs:TimeInterval, rhs:TimeInterval) -> Bool {
    return lhs.offset == rhs.offset
}

extension TimeSpan : Equatable {}
public func == (lhs:TimeSpan, rhs:TimeSpan) -> Bool {
    return lhs.offset==rhs.offset
}

extension Date: Equatable {}
public func == (lhs:Date, rhs:Date) -> Bool {
    return lhs.time==rhs.time
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
    return TimeSpan(left.date().timeIntervalSinceDate(right.date()))
}

public func + (left:Date, right:Time) -> Date {
    return Date(left.time.offset + right.offset)
}

public func += (left:Date, right:Time) -> Date {
    return left + right
}

public func - (left:Date, right:Time) -> Date {
    return Date(left.time.offset - right.offset)
}

public func + (left:TimeSpan, right:TimeSpan) -> TimeSpan {
    return TimeSpan(left.offset + right.offset)
}

public func - (left:TimeSpan, right:TimeSpan) -> TimeSpan {
    return TimeSpan(left.offset - right.offset)
}


public func / (left:TimeSpan, right:TimeSpan) -> Double {
    return left.offset / right.offset
}

public func > (left:TimeSpan, right:Int) -> Bool {
    return left.offset > 0
}


