//
//  WorkoutType.swift
//  WorkoutCalendar
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import SwiftUI

enum WorkoutType: String, Codable, CaseIterable, Hashable {
    case walkingRunning = "Walking/Running"
    case yoga = "Yoga"
    case water = "Water"
    case cycling = "Cycling"
    case strength = "Strength"

    var title: String {
        switch self {
        case .walkingRunning: return "Walking/Running"
        case .yoga: return "Yoga"
        case .water: return "Water"
        case .cycling: return "Cycling"
        case .strength: return "Strength"
        }
    }

    var sfSymbolName: String {
        switch self {
        case .walkingRunning: return "figure.run"
        case .yoga: return "figure.yoga"
        case .water: return "drop.fill"
        case .cycling: return "bicycle"
        case .strength: return "dumbbell.fill"
        }
    }

    var tint: Color {
        switch self {
        case .walkingRunning: return .orange
        case .yoga: return .purple
        case .water: return .blue
        case .cycling: return .green
        case .strength: return .red
        }
    }
}
