//
//  DateExt.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation

extension Date {

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

    var isInThisYear:  Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(as: Date()) }

    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
    
    
    func startOfMonth(in calendar: Calendar = .current) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self)))!.startOfDay(in: calendar)
    }

    func endOfMonth(in calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(in: calendar))!.endOfDay(in: calendar)
    }

    func isInSameDay(in calendar: Calendar = .current, date: Date) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: .day)
    }

    func isInSameMonth(in calendar: Calendar = .current, date: Date) -> Bool {
        calendar.component(.month, from: self) == calendar.component(.month, from: date)
    }

    func startOfDay(in calendar: Calendar = .current) -> Date {
        calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }

    func endOfDay(in calendar: Calendar = .current) -> Date {
        calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
}

extension Calendar {
    var lastWeekday: Int {
        let numDays = self.weekdaySymbols.count
        let res = (self.firstWeekday + numDays - 1) % numDays
        return res != 0 ? res : self.weekdaySymbols.count
    }
}
