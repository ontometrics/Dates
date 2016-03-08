//
//  TimeKeeping.swift
//  Dates
//
//  Created by Rob Williams on 3/8/16.
//  Copyright © 2016 ontometrics. All rights reserved.
//

import Foundation

protocol Clock {
    var currentTime:Date { get }
}

class DefaultTimeKeeper : Clock {
    var currentTime:Date {
        get {
            return Date()
        }
    }
}

class OffsetTimeKeeper : Clock {
    
    let offset:TimeSpan
    
    init(offset:TimeSpan){
        self.offset = offset
    }
    
    var currentTime:Date {
        get {
            return Date() + offset
        }
    }
    
}

class FixedTimeKeeper : Clock {
    let date:Date
    
    init(specificDate:Date){
        self.date = specificDate
    }
    
    var currentTime:Date {
        get {
            return self.date
        }
    }
    
}

class SystemsClock : Clock {

    var timeKeeper:Clock
    
    init(){
        self.timeKeeper = DefaultTimeKeeper()
    }
    
    init(specificDate:Date){
        self.timeKeeper = FixedTimeKeeper(specificDate: specificDate)
    }
    
    init(offset:TimeSpan){
        self.timeKeeper = OffsetTimeKeeper(offset: offset)
    }
    
    var currentTime:Date {
        get {
            return timeKeeper.currentTime
        }
    }
    
}