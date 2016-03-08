//
//  SystemsClockTests.swift
//  Dates
//
//  Created by Rob Williams on 3/8/16.
//  Copyright © 2016 ontometrics. All rights reserved.
//

import XCTest
@testable import Dates

class SystemsClockTests : XCTestCase {

    func testCanSetupFixedDateClock(){
        let noonToday = Date()
        let systemClock = SystemsClock(specificDate: noonToday)
        
        XCTAssertEqual(systemClock.currentTime, noonToday)
        
    }
    
    func testCanUseOffset() {
        
        let systemClock = SystemsClock(offset: TimeSpan(hours: -1))
        
        XCTAssertTrue(systemClock.currentTime < Date())
        
        
        
    }
}