//
//  CalendarDayCellModel.swift
//  WorkoutCalendar
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import Foundation

struct CalendarDayCellModel: Identifiable, Hashable {
    let id: String
    let date: Date?          // nil = пустая ячейка
    let dayNumber: String    // "1", "2"... или "" для пустой
    let isToday: Bool
    let isSelected: Bool
    let markers: [WorkoutType]  // уникальные типы тренировок этого дня
}
