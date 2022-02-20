// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation

class DateUtil {
    static let DATE_FORMAT_yyyyMMdd = "yyyyMMdd"
    static let DATE_FORMAT_yyyy_MM_dd = "yyyy-MM-dd"
    static let DATE_FORMAT_HH_mm = "HH:mm"
    static let DATE_FORMAT_TIME1 = "yyyy-MM-dd HH:mm"
    static let DATE_FORMAT_TIME2 = "yyyy/MM/dd HH:mm"
    static let DATE_FORMAT_TIMESTAMP1 = "yyyy/MM/dd HH:mm:ss"
    static let DATE_FORMAT_TIMESTAMP2 = "yyyy-MM-dd HH:mm:ss"
    
    class func format(date : Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        // dateFormatter.locale = .current
        dateFormatter.locale = NSLocale.system
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    class func format(from : String, fromFomart : String , toFormat: String) -> String {
        let date = toDate(date: from, format: fromFomart)
        return format(date: date!, format: toFormat)
    }
    class func toDate(date: String, format: String) -> Date? {
        if date.isEmpty {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date)
    }
    
    class func getDateByTimeInterval(dateTime: Double) -> String {
        let date = Date(timeIntervalSince1970: dateTime)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = DATE_FORMAT_TIME2
        return  dateFormatter.string(from: date)
    }
}
