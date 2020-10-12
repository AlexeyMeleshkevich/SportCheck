import Foundation

typealias YearMonthDay = (Int, Int, Int)

class DateComparer {
    
    public static let currentDate: YearMonthDay? = {
        let date = Date()
        let components = date.get(.day, .month, .year)
        
        if let day = components.day, let month = components.month, let year = components.year {
            return (year, month, day)
        }
        
        return nil
    }()
    
    private static func parseDate(_ dateString: String) -> YearMonthDay? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: dateString) else { return nil }
        
        formatter.dateFormat = "yyyy"
        guard let year = Int(formatter.string(from: date)) else { return nil }
        formatter.dateFormat = "MM"
        guard let month = Int(formatter.string(from: date)) else { return nil }
        formatter.dateFormat = "dd"
        guard let day = Int(formatter.string(from: date)) else { return nil }
        
        return (year, month, day)
    }
    
    /*
    private static func eventDidStarted(_ startDate: YearMonthDay, _ compareDate: YearMonthDay) -> Bool {
        switch startDate.2 > compareDate.2 {
        case true:
            return false
        case false:
            switch (startDate.1 > compareDate.1) {
            case true:
                return false
            case false:
                switch (startDate.0 > compareDate.0) {
                case true:
                    return false
                case false:
                    return true
                }
            }
        }
    }
    */
    
    public static func isActive(_ startDate: String, _ endDate: String) -> Bool? {
        guard let currentDate = currentDate else { return nil }
        guard let startDate = parseDate(startDate) else { return nil }
        guard dateIsPast(startDate, currentDate) else { return false }
        guard let compareDate = parseDate(endDate) else { return nil }
        
        return dateInFuture(compareDate, currentDate)
    }
    
    private static func dateIsPast(_ dateToCompare: YearMonthDay, _ currentDate: YearMonthDay) -> Bool {
        if dateToCompare > currentDate {
            return false
        } else if dateToCompare == currentDate {
            return true
        } else if dateToCompare < currentDate {
            return true
        }
        
        return false
    }
    
    private static func dateInFuture(_ dateToCompare: YearMonthDay, _ currentDate: YearMonthDay) -> Bool {
        if dateToCompare < currentDate {
            return false
        } else if dateToCompare == currentDate {
            return true
        } else if dateToCompare > currentDate {
            return true
        }
        
        return false
    }
}
