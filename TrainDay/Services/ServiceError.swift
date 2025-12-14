//
//  ServiceError.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//


import Foundation

enum ServiceError: LocalizedError {
    case fileNotFound(String)
    case decodingFailed(String)
    case missingWorkout(String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let name):
            return "File not found in bundle: \(name)"
        case .decodingFailed(let name):
            return "Failed to decode JSON: \(name)"
        case .missingWorkout(let id):
            return "Missing data for workoutId: \(id)"
        }
    }
}