//
//  DateExtension.swift
//  SportCheck
//
//  Created by Alexey Meleshkevich on 14.09.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import Foundation

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

extension Date {
    
    var currentYear: Int {
        get {
            return get(.year)
        }
    }
    
    var currentMonth: Int {
        get {
            return get(.month)
        }
    }
    
    var currentDay: Int {
        get {
            return get(.day)
        }
    }
}
