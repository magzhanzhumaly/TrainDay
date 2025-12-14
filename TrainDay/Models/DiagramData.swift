//
//  DiagramData.swift
//  WorkoutCalendar
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import Foundation

struct DiagramResponse: Codable, Hashable {
    let data: [DiagramPoint]
    let states: [DiagramState]?
}

struct DiagramState: Codable, Hashable {
    // В тестовых данных может быть пусто - оставляем гибко
    let name: String?
}

struct DiagramPoint: Codable, Hashable {
    let timeNumeric: Double
    let heartRate: Int
    let speedKmh: Double
    let distanceMeters: Double?
    let steps: Int?
    let elevation: Double?
    let latitude: Double?
    let longitude: Double?
    let temperatureCelsius: Double?
    let currentLayer: Int?
    let currentSubLayer: Int?
    let currentTimestamp: Date?

    enum CodingKeys: String, CodingKey {
        case timeNumeric = "time_numeric"
        case heartRate
        case speedKmh = "speed_kmh"
        case distanceMeters
        case steps
        case elevation
        case latitude
        case longitude
        case temperatureCelsius
        case currentLayer
        case currentSubLayer
        case currentTimestamp
    }
}
