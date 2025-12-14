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
    
    //    private func loadMetadataIndex() throws -> [String: WorkoutMetadata] {
    //        // Variant A: dictionary keyed by workoutId
    //        if let dict: [String: WorkoutMetadata] = try? JSONLoader.load("test_data/metadata.json", bundle: bundle) {
    //            return dict
    //        }
    //
    //        // Variant B: array of metadata objects
    //        let array: [WorkoutMetadata] = try JSONLoader.load("test_data/metadata.json", bundle: bundle)
    //        return Dictionary(uniqueKeysWithValues: array.map { ($0.workoutKey, $0) })
    //    }
    
    private func loadMetadataIndex() throws -> [String: WorkoutMetadata] {
        let url = try JSONLoader.debugURL("test_data/metadata.json", bundle: bundle)
        let data = try Data(contentsOf: url)
        
        print("metadata url:", url)
        print("metadata bytes:", data.count)
        
        if let preview = String(data: data.prefix(800), encoding: .utf8) {
            print("metadata preview:\n", preview)
        }
        
        // Variant A: dictionary keyed by workoutId
        do {
            let dict: [String: WorkoutMetadata] = try JSONLoader.decode(data, as: [String: WorkoutMetadata].self)
            print("metadata decoded as dict, keys:", dict.count)
            return dict
        } catch {
            print("metadata dict decode error:", error)
        }
        
        // Variant A2: dictionary keyed by workoutId, where inner object may NOT contain `workoutKey`
        do {
            let dict: [String: WorkoutMetadataDTO] = try JSONLoader.decode(data, as: [String: WorkoutMetadataDTO].self)
            print("metadata decoded as dict<DTO>, keys:", dict.count)
            return Dictionary(uniqueKeysWithValues: dict.map { (key, value) in (key, value.asMetadata(workoutKey: key)) })
        } catch {
            print("metadata dict<DTO> decode error:", error)
        }
        
        // Variant B: array of metadata objects
        do {
            let array: [WorkoutMetadata] = try JSONLoader.decode(data, as: [WorkoutMetadata].self)
            print("metadata decoded as array, count:", array.count)
            return Dictionary(uniqueKeysWithValues: array.map { ($0.workoutKey, $0) })
        } catch {
            print("metadata array decode error:", error)
            throw error
        }
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
    // MARK: - DTO fallback (when metadata.json values don't include workoutKey)
    private struct WorkoutMetadataDTO: Decodable {
        let workoutActivityType: WorkoutType
        let workoutStartDate: Date

        let distance: Double?
        let duration: Double?

        let maxLayer: Int?
        let maxSubLayer: Int?
        let avgHumidity: Double?
        let avgTemp: Double?
        let comment: String?
        let photoBefore: String?
        let photoAfter: String?
        let heartRateGraph: String?
        let activityGraph: String?
        let map: String?

        enum CodingKeys: String, CodingKey {
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

        init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: CodingKeys.self)

            workoutActivityType = try c.decode(WorkoutType.self, forKey: .workoutActivityType)
            workoutStartDate = try c.decode(Date.self, forKey: .workoutStartDate)

            distance = try c.decodeLossyDoubleIfPresent(forKey: .distance)
            duration = try c.decodeLossyDoubleIfPresent(forKey: .duration)

            maxLayer = try c.decodeIfPresent(Int.self, forKey: .maxLayer)
            maxSubLayer = try c.decodeIfPresent(Int.self, forKey: .maxSubLayer)

            avgHumidity = try c.decodeLossyDoubleIfPresent(forKey: .avgHumidity)
            avgTemp = try c.decodeLossyDoubleIfPresent(forKey: .avgTemp)

            comment = try c.decodeIfPresent(String.self, forKey: .comment)
            photoBefore = try c.decodeIfPresent(String.self, forKey: .photoBefore)
            photoAfter = try c.decodeIfPresent(String.self, forKey: .photoAfter)
            heartRateGraph = try c.decodeIfPresent(String.self, forKey: .heartRateGraph)
            activityGraph = try c.decodeIfPresent(String.self, forKey: .activityGraph)
            map = try c.decodeIfPresent(String.self, forKey: .map)
        }

        func asMetadata(workoutKey: String) -> WorkoutMetadata {
            WorkoutMetadata(
                workoutKey: workoutKey,
                workoutActivityType: workoutActivityType,
                workoutStartDate: workoutStartDate,
                distance: distance,
                duration: duration,
                maxLayer: maxLayer,
                maxSubLayer: maxSubLayer,
                avgHumidity: avgHumidity,
                avgTemp: avgTemp,
                comment: comment,
                photoBefore: photoBefore,
                photoAfter: photoAfter,
                heartRateGraph: heartRateGraph,
                activityGraph: activityGraph,
                map: map
            )
        }
    }
}

private extension KeyedDecodingContainer {
    func decodeLossyDoubleIfPresent(forKey key: Key) throws -> Double? {
        // Try Double
        do {
            if let d = try decodeIfPresent(Double.self, forKey: key) {
                return d
            }
        } catch {
            // ignore type mismatch
        }

        // Try String
        do {
            if let s = try decodeIfPresent(String.self, forKey: key) {
                return Double(s.replacingOccurrences(of: ",", with: "."))
            }
        } catch {
            // ignore type mismatch
        }

        // Try Int
        do {
            if let i = try decodeIfPresent(Int.self, forKey: key) {
                return Double(i)
            }
        } catch {
            // ignore type mismatch
        }

        return nil
    }
}
