//
//  JSONDecoder+TrainDay.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import Foundation

extension JSONDecoder {
    static func trainDay() -> JSONDecoder {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let raw = try container.decode(String.self)

            if let date = DateParser.serverDateTime.date(from: raw) {
                return date
            }
            if let dateOnly = DateParser.serverDate.date(from: raw) {
                return dateOnly
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unsupported date format: \(raw)"
            )
        }
        return d
    }
}
