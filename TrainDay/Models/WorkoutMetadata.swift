//
//  WorkoutMetadata.swift
//  WorkoutCalendar
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import Foundation

struct WorkoutMetadata: Decodable {
    let workoutKey: String
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

    init(
        workoutKey: String,
        workoutActivityType: WorkoutType,
        workoutStartDate: Date,
        distance: Double?,
        duration: Double?,
        maxLayer: Int?,
        maxSubLayer: Int?,
        avgHumidity: Double?,
        avgTemp: Double?,
        comment: String?,
        photoBefore: String?,
        photoAfter: String?,
        heartRateGraph: String?,
        activityGraph: String?,
        map: String?
    ) {
        self.workoutKey = workoutKey
        self.workoutActivityType = workoutActivityType
        self.workoutStartDate = workoutStartDate
        self.distance = distance
        self.duration = duration
        self.maxLayer = maxLayer
        self.maxSubLayer = maxSubLayer
        self.avgHumidity = avgHumidity
        self.avgTemp = avgTemp
        self.comment = comment
        self.photoBefore = photoBefore
        self.photoAfter = photoAfter
        self.heartRateGraph = heartRateGraph
        self.activityGraph = activityGraph
        self.map = map
    }

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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        workoutKey = try container.decode(String.self, forKey: .workoutKey)
        workoutActivityType = try container.decode(WorkoutType.self, forKey: .workoutActivityType)
        workoutStartDate = try container.decode(Date.self, forKey: .workoutStartDate)
        distance = try container.decodeIfPresent(Double.self, forKey: .distance)
        duration = try container.decodeIfPresent(Double.self, forKey: .duration)
        maxLayer = try container.decodeIfPresent(Int.self, forKey: .maxLayer)
        maxSubLayer = try container.decodeIfPresent(Int.self, forKey: .maxSubLayer)
        avgHumidity = try container.decodeIfPresent(Double.self, forKey: .avgHumidity)
        avgTemp = try container.decodeIfPresent(Double.self, forKey: .avgTemp)
        comment = try container.decodeIfPresent(String.self, forKey: .comment)
        photoBefore = try container.decodeIfPresent(String.self, forKey: .photoBefore)
        photoAfter = try container.decodeIfPresent(String.self, forKey: .photoAfter)
        heartRateGraph = try container.decodeIfPresent(String.self, forKey: .heartRateGraph)
        activityGraph = try container.decodeIfPresent(String.self, forKey: .activityGraph)
        map = try container.decodeIfPresent(String.self, forKey: .map)
    }
}
