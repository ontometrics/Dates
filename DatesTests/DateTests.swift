//
//  DateTests.swift
//  dminder-ios
//
//  Created by Rob Williams on 8/2/14.
//  Copyright (c) 2014 ontometrics. All rights reserved.
//

import XCTest
import Dates

class DateTests: XCTestCase {

    let today = Date(year: 2014, month: 7, day: 2)
    let tomorrow = Date(year: 2014, month: 7, day: 3)

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatDefaultDateIsNow() {
        let now = Date()

        NSLog("now: \(now.date().description)")
    }

    func testCanCompareTwoDates() {
        
        XCTAssert(tomorrow > today, "tomorrow should be greater than today")
        
    }
    
    func testCanGetComponents() {

        NSLog("day: %d of month: %d", today.day(), today.month())
        
        
        XCTAssert(today.day()==2)
        XCTAssert(today.month()==7)
        
        NSLog("year is: %d", today.year())
        XCTAssert(today.year()==2014)
        
        //XCTAssert(tomorrow.day()==3)
    }
    
    func testCanSubtractTwoDatesAndGetInterval(){
        let distanceToTomorrow = tomorrow - today
        NSLog("tomorrow - today: %f", distanceToTomorrow.offset)
        
        let daysDifference = distanceToTomorrow.days()
        
        XCTAssertTrue(daysDifference==1, "should be one day difference")
        
    }
    
    func testCanSubtractTwoDatesAndGetElapsedTime(){
        let now = Date()
        let interval = TimeSpan(60 * 5)
        let later = now + interval
        
        let timeToThen = later - now
        
        XCTAssertEqual(timeToThen, interval, "Interval should be the different between then and now.")
        
        NSLog("now = \(now.date().description)")
        
    }
    
    func testCanFindSameDayOrNot() {
        let firstDate = Date(year: 2015, month: 5, day: 1)
        let secondDate = Date(year: 2015, month: 5, day: 2)
        
        let sameAsFirst = Date(year: 2015, month: 5, day: 1)
        
        XCTAssertTrue(firstDate.sameDayAs(sameAsFirst))
        XCTAssertFalse(firstDate.sameDayAs(secondDate))
        
    }
    
    func testCanSubtractDatesAndGetSeconds(){
        let newMoon = Date(year: 1970, month: 1, day: 20, hour: 20, minute: 35)
        let newMoonApril2015 = Date(year: 2015, month: 4, day: 18, hour: 13, minute: 57)

        let difference = newMoonApril2015 - newMoon
        let differenceSeconds = difference.seconds()

        //around a billion and a half seconds between 1970 and 2015..
        XCTAssertEqual(differenceSeconds, 1427646120)
        
    }

    func testCanSubtractTwoTimeSpans() {
        let totalTime = TimeSpan(minutes: 20)
        let elapsed = TimeSpan(minutes: 5)

        let remaining = totalTime - elapsed

        XCTAssertEqual(remaining.minutes(), 15, "Should be 15 minutes left.")
    }
    
    func testCanAddTwoTimespans() {
        let elapsedTime = TimeSpan(minutes: 5)
        let fiveMinutes = TimeSpan(minutes: 5)
        
        let totalFiveMinutesFromNow = elapsedTime + fiveMinutes
        
        XCTAssertEqual(totalFiveMinutesFromNow.minutes(), 10, "5 + 5 minutes should equal 10.")
    }
    
    func testCanConstructTimeSpan(){
        let targetSpan = TimeSpan(minutes: 10, seconds: 25)
        NSLog("target span: \(targetSpan.offset)")
    }
    
    func testCanComputeAgeFromBirthday() {
        let birthday = Date(year: 1980, month: 8, day: 2)
        let today = Date(year: 2014, month: 8, day: 2)
        
        let timeSinceBirth = today - birthday
        let age = timeSinceBirth.years()
        
        NSLog("age: %d", age)
        
        XCTAssertTrue(age==34)
        
        NSLog("age again: %d", (today - birthday).years())
        
    }
    
    func testCanOutputFormattedDates() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"

        let startTime = Date(year: 2015, month: 4, day: 5, hour: 9, minute: 15)
        
        let output = formatter.stringFromDate(startTime.date())
        
        XCTAssertEqual(output, "09:15 AM")
        
    }
    
    func testCanAddTimeIntervalsToDates() {
        let twoDays = TimeSpan(days: 2)
        
        let dayAfterTomorrow = today + twoDays
        
        XCTAssertTrue(dayAfterTomorrow.day()==4, "day after tomorrow should be 4")
    }
    
    func testCanMakeDatesInDifferentTimezones() {
        
        let laTimeZone:NSTimeZone = NSTimeZone(name: "US/Pacific")!

        let nowInLA = Date(year: 2014, month: 7, day: 3, hour: 11, minute: 27, timeZone: laTimeZone)
        let nowInNYC = Date(year: 2014, month: 7, day: 3, hour: 11, minute: 27, timeZone: NSTimeZone(name: "US/Eastern")!)
                
        let difference = nowInLA - nowInNYC
        
        XCTAssertTrue(difference.hours()==3, "time difference from west to east coast should be 3 hours: result: \(difference.hours())")
        
        
    }
    
    func testThatDateWithNoOffsetYieldsNow(){
        let now = Date()
        
        NSLog("now: \(now.year()) \(now.day()) \(now.month())")
        
    }
    
    func testThatSubtractionOfIntervalWorks() {
        
        let start = Date(year: 2014, month: 8, day: 26, hour: 17, minute: 20, second: 0, timeZone: NSTimeZone(abbreviation: "PDT")!)
        let twoHoursBefore = start - TimeSpan(hours: 2)
        
        NSLog("start: \(start.description) 2h before: \(twoHoursBefore.description)")
        
        XCTAssertGreaterThan(start.time.offset, twoHoursBefore.time.offset, "time should have descreased after subtraction of interval.")
        
    }
    
    func testCanGetStringForTimeInterval() {
        
        let start = Date(year: 2015, month: 4, day: 15, hour: 8, minute: 0, second: 0)
        let inAFewHours = Date(year: 2015, month: 4, day: 15, hour: 10, minute: 0, second: 0)
        
        print((inAFewHours - start).asReadableString(.Long))
        
    }
    
    func testCanGetIntervalFromNow() {
        let futureDate = Date() + TimeSpan(hours: 3)
        
        let spanFromNowAsString = futureDate.spanFromNow().asReadableString(.Long)
        
        print("span from now: \(spanFromNowAsString)")
        
        XCTAssert(spanFromNowAsString.contains("2 hours"))
        
    }
    
    func testCanGetShortStringForTimeInterval() {
        let now = Date()
        var testDate = now + TimeSpan(hours: 3, minutes: 30)
        
        XCTAssertEqual(testDate.spanFromNow().asReadableString(.Medium), "3h 29m")
        
        testDate = Date() + TimeSpan(minutes: 30)
        
        XCTAssertEqual(testDate.spanFromNow().asReadableString(.Short), "29m")

    }
    

    func testCanComputeLunarPhase() {
        let newMoonApril2015 = Date(year: 2015, month: 4, day: 18, hour: 20, minute: 35)
        let fullMoonApril2015 = newMoonApril2015 - TimeSpan(days: 14)
        
        print("new moon april 2015: \(newMoonApril2015)")
        
        let newMoonPhase = newMoonApril2015.moonPhase
        
        
        
        XCTAssertEqual(newMoonPhase, 0)
        
        let fullMoonPhase = fullMoonApril2015.moonPhase
        
        XCTAssertEqual(fullMoonPhase, 16)
        
        
        
    }
    
    func testCanComputeJulianDay() {
        
        let referenceDate = Date(year: 2000, month: 1, day: 1)
        
        let julianDay = referenceDate.julianDay
        
        XCTAssertEqual(julianDay, 2451545)
        
        let fullMoonApril = Date(year: 2015, month: 4, day: 4)
        
        let julianDayForAprilFullMoon = fullMoonApril.julianDay
        
        print("julian day for April 4, 2015: \(julianDayForAprilFullMoon)")
        
    }
    
    func testCanComputeDayOfTheYear(){
        let referenceDate = Date(year: 2015, month: 5, day: 10)
        
        let dayOfTheYear = referenceDate.dayOfTheYear
        
        print("day of the year for \(referenceDate): \(dayOfTheYear)")
        
        XCTAssertEqual(dayOfTheYear, 130)
        
    }
   
    

}

extension String {
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}


