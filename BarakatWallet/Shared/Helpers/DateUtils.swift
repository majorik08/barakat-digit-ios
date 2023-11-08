//
//  DateUtils.swift
//  BarakatWallet
//
//  Created by km1tj on 31/10/23.
//

import Foundation

public class DateUtils {
    
    private static var cachedDateFormatters = [String: DateFormatter]()
    
    /// Generates a cached formatter based on the specified format, timeZone and locale. Formatters are cached in a singleton array using hashkeys.
    private static func cachedFormatter(_ format:String = "EEE MMM dd HH:mm:ss Z yyyy", timeZone: Foundation.TimeZone = Foundation.TimeZone.current, locale: Locale = Locale.current) -> DateFormatter {
        let hashKey = "\(format.hashValue)\(timeZone.hashValue)\(locale.hashValue)"
        if DateUtils.cachedDateFormatters[hashKey] == nil {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = timeZone
            formatter.locale = locale
            formatter.isLenient = true
            DateUtils.cachedDateFormatters[hashKey] = formatter
        }
        return DateUtils.cachedDateFormatters[hashKey]!
    }
    
    /// Generates a cached formatter based on the provided date style, time style and relative date. Formatters are cached in a singleton array using hashkeys.
    private static func cachedFormatter(_ dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, doesRelativeDateFormatting: Bool, timeZone: Foundation.TimeZone = Foundation.NSTimeZone.local, locale: Locale = Locale.current) -> DateFormatter {
        let hashKey = "\(dateStyle.hashValue)\(timeStyle.hashValue)\(doesRelativeDateFormatting.hashValue)\(timeZone.hashValue)\(locale.hashValue)"
        if DateUtils.cachedDateFormatters[hashKey] == nil {
            let formatter = DateFormatter()
            formatter.dateStyle = dateStyle
            formatter.timeStyle = timeStyle
            formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
            formatter.timeZone = timeZone
            formatter.locale = locale
            formatter.isLenient = true
            DateUtils.cachedDateFormatters[hashKey] = formatter
        }
        return DateUtils.cachedDateFormatters[hashKey]!
    }
    
    public static func stringRecent(date: Date) -> String {
        //11:11
        //Sun,Mon...
        //11.11.11
        if Calendar.current.isDateInToday(date) {
            let formatter = DateUtils.cachedFormatter("HH:mm", timeZone: NSTimeZone.local, locale: Locale.current)
            return formatter.string(from: date)
        } else {
            let daysBetween = Calendar.current.dateComponents([.day], from: date, to: Date())
            if daysBetween.day! <= 7 {
                let formatter = DateUtils.cachedFormatter("E", timeZone: NSTimeZone.local, locale: Locale.current)
                return formatter.string(from: date)
            } else {
                let formatter = DateUtils.cachedFormatter("dd.MM.yy", timeZone: NSTimeZone.local, locale: Locale.current)
                return formatter.string(from: date)
            }
        }
    }
    
    public static func stringFullDate(date: Date) -> String {
        let formatter = DateUtils.cachedFormatter("dd/MM/yy", timeZone: NSTimeZone.local, locale: Locale.current)
        return formatter.string(from: date)
    }
    
    public static func stringMessageStatus(date: Date) -> String {
        //11:11
        //11.11.11 11:11
        if Calendar.current.isDateInToday(date) {
            let formatter = DateUtils.cachedFormatter("HH:mm", timeZone: NSTimeZone.local, locale: Locale.current)
            return formatter.string(from: date)
        } else {
            let formatter = DateUtils.cachedFormatter("dd MMMM yyyy HH:mm", timeZone: NSTimeZone.local, locale: Locale.current)
            return formatter.string(from: date)
        }
    }
    
    public static func stringFullDateTime(date: Date) -> String {
        let formatter = DateUtils.cachedFormatter("dd MMMM yyyy HH:mm", timeZone: NSTimeZone.local, locale: Locale.current)
        return formatter.string(from: date)
    }
    
    public static func stringGetYear(date: Date) -> String {
        let formatter = DateUtils.cachedFormatter("yyyy", timeZone: NSTimeZone.local, locale: Locale.current)
        return formatter.string(from: date)
    }
    
    public static func stringRecentNumber(date: Date) -> String {
        //11:11
        //11.11.11
        if Calendar.current.isDateInToday(date) {
            let formatter = DateUtils.cachedFormatter("HH:mm", timeZone: NSTimeZone.local, locale: Locale.current)
            return formatter.string(from: date)
        } else {
            let formatter = DateUtils.cachedFormatter("dd.MM.yy", timeZone: NSTimeZone.local, locale: Locale.current)
            return formatter.string(from: date)
        }
    }
    
    public static func stringDateWithWeekName(date: Date) -> String {
        if date.isInThisWeek {
            let formatter = DateUtils.cachedFormatter("d MMMM, EEEE", timeZone: NSTimeZone.local, locale: Locale.current)
            return formatter.string(from: date)
        } else if date.isInThisYear {
            let formatter = DateUtils.cachedFormatter("d MMMM", timeZone: NSTimeZone.local, locale: Locale.current)
            return formatter.string(from: date)
        } else {
            let formatter = DateUtils.cachedFormatter("d MMMM yyyy", timeZone: NSTimeZone.local, locale: Locale.current)
            return formatter.string(from: date)
        }
    }
    
    public static func stringRecentTime(date: Date) -> String {
        //11:11
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone.local
        formatter.locale = Locale.current
        formatter.isLenient = true
        return formatter.string(from: date)
    }
    
    public static func stringFullDateBack(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        formatter.timeZone = NSTimeZone.local
        formatter.locale = Locale.current
        formatter.isLenient = true
        return formatter.string(from: date)
    }
    
    public static func stringDateByYear(date: Date) -> String {
        if Calendar.current.isDate(Date(), equalTo: date, toGranularity: .year) {
            let formatter = DateUtils.cachedFormatter("dd MMMM", timeZone: NSTimeZone.local, locale: Locale.current)
            return formatter.string(from: date)
        } else {
             let formatter = DateUtils.cachedFormatter("dd MMMM yyyy", timeZone: NSTimeZone.local, locale: Locale.current)
             return formatter.string(from: date)
        }
    }
    
    public static func stringRecentMonth(date: Date) -> String {
        //11 nov 2018
        let formatter = DateUtils.cachedFormatter("dd MMMM yyyy", timeZone: NSTimeZone.local, locale: Locale.current)
        return formatter.string(from: date)
    }
    
    public static func stringRecentDate(date: Date) -> String {
        let formatter = DateUtils.cachedFormatter("MMMM d, yyyy", timeZone: NSTimeZone.local, locale: Locale.current)
        return formatter.string(from: date)
    }
    
    public static func stringDetailDay(date: Date) -> String {
        let formatter = DateUtils.cachedFormatter("MMM d", timeZone: NSTimeZone.local, locale: Locale.current)
        return formatter.string(from: date)
    }
    
    public static func stringDuration(duration: Double, full: Bool = true) -> String? {
        // 2 hr, 46 min, 40 sec
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = full ? .full : .short
        dateFormatter.allowedUnits = [.hour, .minute, .second]
        //dateFormatter.zeroFormattingBehavior = .pad
        return dateFormatter.string(from: Double(duration))
    }
}
