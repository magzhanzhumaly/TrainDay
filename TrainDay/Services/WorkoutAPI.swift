//
//  WorkoutAPI.swift
//  WorkoutCalendar
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import Foundation

protocol WorkoutAPI {
    func fetchWorkouts(email: String, lastDate: Date) async throws -> [WorkoutListItem]
    func fetchMetadata(email: String, workoutId: String) async throws -> WorkoutMetadata
    func fetchDiagram(email: String, workoutId: String) async throws -> [DiagramPoint]
}
