//
//  WorkoutMetadata.swift
//  WorkoutCalendar
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import Foundation

struct WorkoutMetadata: Codable, Hashable {
    let workoutKey: String
    let workoutActivityType: WorkoutType
    let workoutStartDate: Date

    let distance: Double?
    let duration: Double?
    let comment: String?

    // Остальные поля из JSON нам не обязательны - делаем опциональными,
    // чтобы декод не падал если структура меняется
    let maxLayer: Int?
    let maxSubLayer: Int?
    let avgHumidity: Double?
    let avgTemp: Double?
    let photoBefore: String?
    let photoAfter: String?
    let heartRateGraph: String?
    let activityGraph: String?
    let map: String?

    enum CodingKeys: String, CodingKey {
        case workoutKey
        case workoutActivityType
        case workoutStartDate
        case distance
        case duration
        case maxLayer
        case maxSubLayer
        case comment
        case photoBefore
        case photoAfter
        case heartRateGraph
        case activityGraph
        case map
        case avgHumidity = "avg_humidity"
        case avgTemp = "avg_temp"
    }
}
