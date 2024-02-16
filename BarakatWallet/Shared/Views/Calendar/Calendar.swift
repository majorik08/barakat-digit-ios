import Foundation

/// Main configuration file
public struct FastisConfig {

    /**
     The default configuration.

     Fastis can be customized global or local.

     Modify this variable to customize all Fastis controllers in your app:
     ```swift
     FastisConfig.default.monthHeader.labelColor = .red
     ```

     Or you can copy and modify this config for some special controller:
     ```swift
     let config: FastisConfig = .default
     config.monthHeader.labelColor = .red
     let controller = FastisController(mode: .single, config: config)
     ```
     Default configuration set showCurrentDate to false. In this case current day will not be indicate
     WithCurrentDate configuration set showCurrentDateto true. In this case current day will be indicate

     You can customized indication current day:
     ```swift
     let config = FastisConfig.withCurrentDate
     // date label
     config.todayCell.dateLabelColor = .red
     config.todayCell.selectedLabelColor = .orange
     config.todayCell.onRangeLabelColor = .green
     config.todayCell.dateLabelUnavailableColor = .cyan

     // circle view
     config.todayCell.circleSize = 4
     config.todayCell.circleVerticalInset = 5
     config.todayCell.circleViewColor = .red
     config.todayCell.circleViewSelectedColor = .orange
     config.todayCell.circleViewOnRangeColor = .green
     config.todayCell.circleViewUnavailableColor = .cyan
     ```
     */
    public static var `default` = FastisConfig()

    public init() { }

    /**
     Base calendar used to build a view

     Default value — `.current`
     */
    public var calendar: Calendar = .current

    /// Base view controller (`cancelButtonTitle`, `doneButtonTitle`, etc.)
    public var controller = FastisConfig.Controller()

    /// Month titles
    public var monthHeader = FastisConfig.MonthHeader()

    /// Day cells (selection parameters, font, etc.)
    public var dayCell = FastisConfig.DayCell()

    /// Today cell (selection parameters, font, etc.)
    public var todayCell: FastisConfig.TodayCell? = FastisConfig.TodayCell()

    /// Top header view with week day names
    public var weekView = FastisConfig.WeekView()

    /// Current value view appearance (clear button, date format, etc.)
    public var currentValueView = FastisConfig.CurrentValueView()

    /// Bottom view with shortcuts
    public var shortcutContainerView = FastisConfig.ShortcutContainerView()

    /// Shortcut item in the bottom view
    public var shortcutItemView = FastisConfig.ShortcutItemView()

}

/// Mode of ``FastisValue`` entity
public enum FastisMode {
    case single
    case range
}

/// Value of ``FastisController``
public protocol FastisValue {

    /// Mode of value for ``FastisController``
    static var mode: FastisMode { get }

    /// Helper function for ``FastisController``
    func outOfRange(minDate: Date?, maxDate: Date?) -> Bool
}

/// Range value for ``FastisController``
public struct FastisRange: FastisValue, Hashable {

    /// Start of the range
    public var fromDate: Date

    /// End of the range
    public var toDate: Date

    /// Mode of value for ``FastisController``. Always `.range`
    public static let mode: FastisMode = .range

    /// Creates a new FastisRange
    /// - Parameters:
    ///   - fromDate: Start of the range
    ///   - toDate: End of the range
    public init(from fromDate: Date, to toDate: Date) {
        self.fromDate = fromDate
        self.toDate = toDate
    }

    public static func from(_ fromDate: Date, to toDate: Date) -> FastisRange {
        FastisRange(from: fromDate, to: toDate)
    }

    public var onSameDay: Bool {
        self.fromDate.isInSameDay(date: self.toDate)
    }

    public func outOfRange(minDate: Date?, maxDate: Date?) -> Bool {
        self.fromDate < minDate ?? self.fromDate || self.toDate > maxDate ?? self.toDate
    }

}

public enum FastisModeSingle {
    case single
}

public enum FastisModeRange {
    case range
}

extension Date: FastisValue {

    /// Mode of value for ``FastisController``. Always `.single`
    public static var mode: FastisMode = .single

    public func outOfRange(minDate: Date?, maxDate: Date?) -> Bool {
        self < minDate ?? self || self > maxDate ?? self
    }

}

/**
 Using shortcuts allows you to quick select prepared dates or date ranges.
 By default `.shortcuts` is empty. If you don't provide any shortcuts the bottom container will be hidden.

 In Fastis available some prepared shortcuts for each mode:

 - For **`.single`**: `.today`, `.tomorrow`, `.yesterday`
 - For **`.range`**: `.today`, `.lastWeek`, `.lastMonth`

 Also you can create your own shortcut:

 ```swift
 var customShortcut = FastisShortcut(name: "Today") { calendar in
     let now = Date()
     return FastisRange(from: now.startOfDay(), to: now.endOfDay())
 }
 fastisController.shortcuts = [customShortcut, .lastWeek]
 ```
 */
public struct FastisShortcut<Value: FastisValue>: Hashable {

    private var id = UUID()

    /// Display name of shortcut
    public var name: String

    /// Tap handler
    public var action: (Calendar) -> Value

    /// Create a shortcut
    /// - Parameters:
    ///   - name: Display name of shortcut
    ///   - action: Tap handler
    public init(name: String, action: @escaping (Calendar) -> Value) {
        self.name = name
        self.action = action
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

    public static func == (lhs: FastisShortcut<Value>, rhs: FastisShortcut<Value>) -> Bool {
        lhs.id == rhs.id
    }

    internal func isEqual(to value: Value, calendar: Calendar) -> Bool {
        if let date1 = self.action(calendar) as? Date, let date2 = value as? Date {
            return date1.isInSameDay(date: date2)
        } else if let value1 = self.action(calendar) as? FastisRange, let value2 = value as? FastisRange {
            return value1 == value2
        }
        return false
    }

}

public extension FastisShortcut where Value == FastisRange {

    /// Range: from **`now.startOfDay`** to **`now.endOfDay`**
    static var today: FastisShortcut {
        FastisShortcut(name: "TODAY".localized) { _ in
            let now = Date()
            return FastisRange(from: now.startOfDay(), to: now.endOfDay())
        }
    }

    /// Range: from **`now.startOfDay - 7 days`** to **`now.endOfDay`**
    static var lastWeek: FastisShortcut {
        FastisShortcut(name: "LAST_WEEK".localized) { calendar in
            let now = Date()
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
            return FastisRange(from: weekAgo.startOfDay(), to: now.endOfDay())
        }
    }

    /// Range: from **`now.startOfDay - 1 month`** to **`now.endOfDay`**
    static var lastMonth: FastisShortcut {
        FastisShortcut(name: "LAST_MONTH".localized) { calendar in
            let now = Date()
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
            return FastisRange(from: monthAgo.startOfDay(), to: now.endOfDay())
        }
    }
}

public extension FastisShortcut where Value == Date {

    /// Date value: **`now`**
    static var today: FastisShortcut {
        FastisShortcut(name: "TODAY".localized) { _ in
            Date()
        }
    }

    /// Date value: **`now - .day(1)`**
    static var yesterday: FastisShortcut {
        FastisShortcut(name: "YESTERDAY".localized) { calendar in
            calendar.date(byAdding: .day, value: -1, to: Date())!
        }
    }

    /// Date value: **`now + .day(1)`**
    static var tomorrow: FastisShortcut {
        FastisShortcut(name: "TOMORROW".localized) { calendar in
            calendar.date(byAdding: .day, value: 1, to: Date())!
        }
    }
}
