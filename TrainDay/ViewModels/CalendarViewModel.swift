//
//  CalendarViewModel.swift
//  WorkoutCalendar
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import Foundation
import Combine

@MainActor
final class CalendarViewModel: ObservableObject {

    // MARK: - Published
    @Published private(set) var isLoading = false
    @Published private(set) var errorText: String?

    @Published var displayedMonth: Date
    @Published var selectedDate: Date

    @Published private(set) var workouts: [WorkoutListItem] = []

    // MARK: - Dependencies
    private let api: WorkoutAPI
    private let calendar: Calendar

    // MARK: - Init
    init(api: WorkoutAPI,
         calendar: Calendar = Calendar.current,
         initialDate: Date = Date()) {
        self.api = api
        self.calendar = calendar
        let monthStart = CalendarViewModel.firstDayOfMonth(for: initialDate, calendar: calendar)
        let defaultSelected = CalendarViewModel.defaultSelectedDate(for: monthStart, calendar: calendar)

        // displayedMonth всегда держим на первом дне месяца (удобнее для сетки)
        self.displayedMonth = monthStart
        // если открыли текущий месяц - дефолтно выбираем сегодня, иначе 1 число
        self.selectedDate = defaultSelected
    }

    // MARK: - Computed

    var monthTitle: String {
        let f = DateFormatter()
        f.locale = Locale.current
        f.calendar = calendar
        f.dateFormat = "LLLL yyyy"
        return f.string(from: displayedMonth).capitalized
    }

    var gridCells: [CalendarDayCellModel] {
        buildMonthGrid(for: displayedMonth)
    }

    var selectedDayWorkouts: [WorkoutListItem] {
        let key = DayKey(date: selectedDate, calendar: calendar)
        return workoutsByDay[key] ?? []
    }

    // MARK: - Private derived
    private var workoutsByDay: [DayKey: [WorkoutListItem]] {
        Dictionary(grouping: workouts, by: { DayKey(date: $0.workoutStartDate, calendar: calendar) })
    }

    // MARK: - Actions

    func load(email: String = "test@gmail.com", lastDate: Date = Date()) async {
        isLoading = true
        errorText = nil
        defer { isLoading = false }

        do {
            let items = try await api.fetchWorkouts(email: email, lastDate: lastDate)
            self.workouts = items.sorted(by: { $0.workoutStartDate < $1.workoutStartDate })

            // Если выбранный день вне текущего displayedMonth (редко, но возможно) - оставим как есть.
        } catch {
            errorText = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }

    func goToPrevMonth() {
        shiftMonth(by: -1)
    }

    func goToNextMonth() {
        shiftMonth(by: 1)
    }

    func select(date: Date) {
        selectedDate = date
        // если тапнули дату другого месяца (например из ведущих/хвостовых дней, если ты их добавишь позже) -
        // можно синхронизировать displayedMonth. Сейчас у нас только даты текущего месяца, так что ок.
    }

    // MARK: - Grid builder

    private func buildMonthGrid(for month: Date) -> [CalendarDayCellModel] {
        let monthStart = firstDayOfMonth(for: month)
        let daysCount = numberOfDaysInMonth(for: monthStart)

        let leading = leadingBlankCount(for: monthStart) // сколько пустых ячеек перед 1 числом

        let todayKey = DayKey(date: Date(), calendar: calendar)
        let selectedKey = DayKey(date: selectedDate, calendar: calendar)

        var cells: [CalendarDayCellModel] = []
        cells.reserveCapacity(leading + daysCount)

        // пустые в начале
        if leading > 0 {
            for i in 0..<leading {
                cells.append(CalendarDayCellModel(
                    id: "empty-\(i)-\(monthStart.timeIntervalSince1970)",
                    date: nil,
                    dayNumber: "",
                    isToday: false,
                    isSelected: false,
                    markers: []
                ))
            }
        }

        // реальные дни месяца
        for day in 1...daysCount {
            guard let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) else { continue }
            let key = DayKey(date: date, calendar: calendar)

            let types = Array(Set((workoutsByDay[key] ?? []).map { $0.workoutActivityType }))
                .sorted(by: { $0.rawValue < $1.rawValue })

            cells.append(CalendarDayCellModel(
                id: "\(key.year)-\(key.month)-\(key.day)",
                date: date,
                dayNumber: "\(day)",
                isToday: key == todayKey,
                isSelected: key == selectedKey,
                markers: types
            ))
        }

        return cells
    }

    private func defaultSelectedDate(for month: Date) -> Date {
        CalendarViewModel.defaultSelectedDate(for: month, calendar: calendar)
    }

    private static func defaultSelectedDate(for month: Date, calendar: Calendar) -> Date {
        let today = Date()

        let isCurrentMonth =
            calendar.component(.year, from: month) == calendar.component(.year, from: today) &&
            calendar.component(.month, from: month) == calendar.component(.month, from: today)

        if isCurrentMonth {
            return today
        } else {
            return firstDayOfMonth(for: month, calendar: calendar)
        }
    }
    
    private func firstDayOfMonth(for date: Date) -> Date {
        CalendarViewModel.firstDayOfMonth(for: date, calendar: calendar)
    }

    private static func firstDayOfMonth(for date: Date, calendar: Calendar) -> Date {
        let comps = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: comps) ?? date
    }

    private func numberOfDaysInMonth(for monthStart: Date) -> Int {
        calendar.range(of: .day, in: .month, for: monthStart)?.count ?? 30
    }

    /// Понедельник - первый день недели (для СНГ-логики).
    private func leadingBlankCount(for monthStart: Date) -> Int {
        var cal = calendar
        cal.firstWeekday = 2 // Monday = 2 (в gregorian)
        let weekday = cal.component(.weekday, from: monthStart) // 1..7 (Sun..Sat)
        // Приводим к индексу 0..6, где 0 = Monday
        // При firstWeekday=2 формула такая:
        // (weekday - firstWeekday + 7) % 7
        let first = cal.firstWeekday
        return (weekday - first + 7) % 7
    }

    private func shiftMonth(by delta: Int) {
        guard let newMonth = calendar.date(byAdding: .month, value: delta, to: displayedMonth) else { return }
        displayedMonth = newMonth

        // Если выбранный день не в новом месяце - выберем 1 число нового месяца (приятнее UX)
        let selectedMonthKey = calendar.dateComponents([.year, .month], from: selectedDate)
        let displayedMonthKey = calendar.dateComponents([.year, .month], from: displayedMonth)

        if selectedMonthKey.year != displayedMonthKey.year || selectedMonthKey.month != displayedMonthKey.month {
            // если вернулись в текущий месяц - выбрать сегодня, иначе 1 число
            selectedDate = defaultSelectedDate(for: displayedMonth)
        }
    }
}
