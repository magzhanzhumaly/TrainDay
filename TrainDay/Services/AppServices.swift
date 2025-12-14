//
//  AppServices.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//


import Foundation

struct AppServices {
    let api: WorkoutAPI

    static func live() -> AppServices {
        AppServices(api: BundleWorkoutAPI())
    }
}