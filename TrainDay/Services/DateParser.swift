//
//  DateParser.swift
//  WorkoutCalendar
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import Foundation

enum DateParser {
    /// Формат из задания: "2025-11-25 09:30:00"
    static let serverDateTime: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0) // стабильно, без сдвигов
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return f
    }()

    /// Формат из задания: "YYYY-MM-DD"
    static let serverDate: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
}
