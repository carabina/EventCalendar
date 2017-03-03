//
//  Event.swift
//  CalenderTesting
//
//  Created by Thomas Martin on 2/13/17.
//  Copyright © 2017 Thomas Martin. All rights reserved.
//

import Foundation

class Event {
    var date: Date?
    var eventType: Int?
    var title: String?
    var dateNoTime: Date?
    
    init(date: Date, title: String) {
        self.date = date
        self.title = title
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        dateNoTime = calendar.date(from: DateComponents(calendar: calendar, year: year, month: month, day: day))

    }
}
