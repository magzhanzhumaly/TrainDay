//
//  BundleWorkoutAPI.swift
//  WorkoutCalendar
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import Foundation

final class BundleWorkoutAPI: WorkoutAPI {
    private let bundle: Bundle
    private let delayNanos: UInt64

    private var cachedWorkouts: [WorkoutListItem]?
    private var metadataById: [String: WorkoutMetadata]?
    private var diagramById: [String: [DiagramPoint]]?

    init(bundle: Bundle = .main, simulatedDelayNanos: UInt64 = 120_000_000) {
        self.bundle = bundle
        self.delayNanos = simulatedDelayNanos
    }

    func fetchWorkouts(email: String, lastDate: Date) async throws -> [WorkoutListItem] {
        try await simulateDelay()

        if let cachedWorkouts { return cachedWorkouts }

        // expected: [WorkoutListItem]
        let items: [WorkoutListItem] = try JSONLoader.load("test_data/list_workouts.json", bundle: bundle)
        self.cachedWorkouts = items
        return items
    }

    func fetchMetadata(email: String, workoutId: String) async throws -> WorkoutMetadata {
        try await simulateDelay()

        if metadataById == nil {
            metadataById = try loadMetadataIndex()
        }
        guard let meta = metadataById?[workoutId] else {
            throw ServiceError.missingWorkout(workoutId)
        }
        return meta
    }

    func fetchDiagram(email: String, workoutId: String) async throws -> [DiagramPoint] {
        try await simulateDelay()

        if diagramById == nil {
            diagramById = try loadDiagramIndex()
        }
        guard let points = diagramById?[workoutId] else {
            throw ServiceError.missingWorkout(workoutId)
        }
        return points
    }

    // MARK: - Private

    private func simulateDelay() async throws {
        try await Task.sleep(nanoseconds: delayNanos)
    }

    private func loadMetadataIndex() throws -> [String: WorkoutMetadata] {
        // Variant A: dictionary keyed by workoutId
        if let dict: [String: WorkoutMetadata] = try? JSONLoader.load("test_data/metadata.json", bundle: bundle) {
            return dict
        }

        // Variant B: array of metadata objects
        let array: [WorkoutMetadata] = try JSONLoader.load("test_data/metadata.json", bundle: bundle)
        return Dictionary(uniqueKeysWithValues: array.map { ($0.workoutKey, $0) })
    }

    private func loadDiagramIndex() throws -> [String: [DiagramPoint]] {
        // Variant A: dictionary keyed by workoutId -> DiagramResponse
        if let dict: [String: DiagramResponse] = try? JSONLoader.load("test_data/diagram_data.json", bundle: bundle) {
            return dict.mapValues { $0.data }
        }

        // Variant B: dictionary keyed by workoutId -> [DiagramPoint]
        if let dict2: [String: [DiagramPoint]] = try? JSONLoader.load("test_data/diagram_data.json", bundle: bundle) {
            return dict2
        }

        // Variant C (fallback): array of DiagramResponse with unknown structure - если будет, обработаем позже
        throw ServiceError.decodingFailed("test_data/diagram_data.json")
    }
}
