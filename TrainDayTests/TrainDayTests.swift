//
//  TrainDayTests.swift
//  TrainDayTests
//
//  Created by Magzhan Zhumaly on 15.12.2025.
//

import Foundation
import Testing
@testable import TrainDay

// Swift Testing (not XCTest) style tests.
// Uses #expect / #require.

struct TrainDayTests {

    // MARK: - Helpers

    private func makeCalendar(timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) -> Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = timeZone
        cal.locale = Locale(identifier: "en_US_POSIX")
        cal.firstWeekday = 2 // Monday
        return cal
    }

    private func makeDate(
        _ year: Int,
        _ month: Int,
        _ day: Int,
        _ hour: Int = 0,
        _ minute: Int = 0,
        calendar: Calendar
    ) -> Date {
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = day
        comps.hour = hour
        comps.minute = minute
        comps.second = 0
        comps.timeZone = calendar.timeZone
        return calendar.date(from: comps)!
    }

    private func ymd(_ date: Date, calendar: Calendar) -> (y: Int, m: Int, d: Int) {
        let c = calendar.dateComponents([.year, .month, .day], from: date)
        return (c.year ?? -1, c.month ?? -1, c.day ?? -1)
    }

    // MARK: - DayKey

    @Test func dayKey_sameCalendarDay_isEqualAndSameHash() {
        let cal = makeCalendar()
        let d1 = makeDate(2025, 12, 14, 7, 20, calendar: cal)
        let d2 = makeDate(2025, 12, 14, 23, 59, calendar: cal)

        let k1 = DayKey(date: d1, calendar: cal)
        let k2 = DayKey(date: d2, calendar: cal)

        #expect(k1 == k2)
        #expect(k1.hashValue == k2.hashValue)
    }

    @Test func dayKey_differentCalendarDay_isNotEqual() {
        let cal = makeCalendar()
        let d1 = makeDate(2025, 12, 14, 7, 20, calendar: cal)
        let d2 = makeDate(2025, 12, 15, 7, 20, calendar: cal)

        let k1 = DayKey(date: d1, calendar: cal)
        let k2 = DayKey(date: d2, calendar: cal)

        #expect(k1 != k2)
    }

    // MARK: - DateParser

    @Test func dateParser_serverDateTime_parsesBackendFormat() throws {
        // Backend format from the assignment: "yyyy-MM-dd HH:mm:ss"
        let s = "2025-12-01 07:20:00"
        let parsed = try #require(DateParser.serverDateTime.date(from: s))

        // Ensure we can format back to the exact same string (round-trip)
        let formatted = DateParser.serverDateTime.string(from: parsed)
        #expect(formatted == s)
    }

    @Test func dateParser_serverDate_parsesYyyyMmDd() throws {
        let s = "2025-12-31"
        let parsed = try #require(DateParser.serverDate.date(from: s))
        let formatted = DateParser.serverDate.string(from: parsed)
        #expect(formatted == s)
    }

    // MARK: - CalendarViewModel (MainActor)

    @MainActor
    @Test func calendarVM_defaultSelection_otherMonth_selectsFirstDay() {
        // Pick a month extremely unlikely to match current month.
        let cal = makeCalendar(timeZone: .current)
        let initial = makeDate(2001, 1, 20, 12, 0, calendar: cal)

        let vm = CalendarViewModel(
            api: BundleWorkoutAPI(),
            calendar: cal,
            initialDate: initial
        )

        let selected = vm.selectedDate
        let comps = ymd(selected, calendar: cal)

        #expect(comps.y == 2001)
        #expect(comps.m == 1)
        #expect(comps.d == 1)
    }

    @MainActor
    @Test func calendarVM_displayedMonth_isFirstDayOfThatMonth() {
        let cal = makeCalendar(timeZone: .current)
        let initial = makeDate(2001, 1, 20, 12, 0, calendar: cal)

        let vm = CalendarViewModel(
            api: BundleWorkoutAPI(),
            calendar: cal,
            initialDate: initial
        )

        let displayed = vm.displayedMonth
        let comps = ymd(displayed, calendar: cal)

        #expect(comps.y == 2001)
        #expect(comps.m == 1)
        #expect(comps.d == 1)
    }

    @MainActor
    @Test func calendarVM_defaultSelection_currentMonth_selectsToday() {
        // If opened current month -> default selected day is today.
        // Uses real Date() to match production logic.
        let cal = makeCalendar(timeZone: .current)
        let today = Date()

        let vm = CalendarViewModel(
            api: BundleWorkoutAPI(),
            calendar: cal,
            initialDate: today
        )

        let selected = vm.selectedDate
        let a = ymd(selected, calendar: cal)
        let b = ymd(today, calendar: cal)

        #expect(a.y == b.y)
        #expect(a.m == b.m)
        #expect(a.d == b.d)
    }

    // MARK: - Filtering logic (pure)

    @Test func filterWorkoutsByDayKey_matchesTwoItemsSameDay() {
        let cal = makeCalendar()

        let items: [WorkoutListItem] = [
            .init(workoutKey: "1", workoutActivityType: .walkingRunning, workoutStartDate: makeDate(2025, 12, 14, 7, 0, calendar: cal)),
            .init(workoutKey: "2", workoutActivityType: .yoga, workoutStartDate: makeDate(2025, 12, 14, 19, 0, calendar: cal)),
            .init(workoutKey: "3", workoutActivityType: .water, workoutStartDate: makeDate(2025, 12, 15, 8, 0, calendar: cal))
        ]

        let key = DayKey(date: makeDate(2025, 12, 14, 12, 0, calendar: cal), calendar: cal)
        let filtered = items.filter { DayKey(date: $0.workoutStartDate, calendar: cal) == key }

        #expect(filtered.count == 2)
        #expect(filtered.map { $0.workoutKey }.sorted() == ["1", "2"])
    }
}
