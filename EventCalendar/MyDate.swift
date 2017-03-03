//
//  MyDate.swift
//  CalenderTesting
//
//  Created by Thomas Martin on 2/15/17.
//  Copyright © 2017 Thomas Martin. All rights reserved.
//

import Foundation

class MyDate {
    var date: Date?
    var events: [Event]?
    
    
    func hasEvent() -> Bool {
        if events != nil && events?.count != 0 {
            return true
        }
        
        return false
    }
}
