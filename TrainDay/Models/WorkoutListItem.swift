//
//  WorkoutListItem.swift
//  WorkoutCalendar
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import Foundation

struct WorkoutListItem: Codable, Identifiable, Hashable {
    let workoutKey: String
    let workoutActivityType: WorkoutType
    let workoutStartDate: Date

    var id: String { workoutKey }
}
