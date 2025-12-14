//
//  JSONLoader.swift
//  WorkoutCalendar
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import Foundation

enum JSONLoader {

    static func load<T: Decodable>(
        _ filename: String,
        bundle: Bundle = .main,
        decoder: JSONDecoder = .trainDay()
    ) throws -> T {

        let url = try findResourceURL(filename, bundle: bundle)

        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode(T.self, from: data)
        } catch {
            throw ServiceError.decodingFailed(filename)
        }
    }

    private static func findResourceURL(_ filename: String, bundle: Bundle) throws -> URL {
        // 1) Пробуем как есть (работает если это folder reference и ты передаешь "test_data/list_workouts.json")
        if let url = bundle.url(forResource: filename, withExtension: nil) {
            return url
        }

        // 2) Пробуем через name + ext (иногда помогает)
        let ns = filename as NSString
        let ext = ns.pathExtension.isEmpty ? nil : ns.pathExtension
        let name = ns.deletingPathExtension

        if let ext, let url = bundle.url(forResource: name, withExtension: ext) {
            return url
        }

        // 3) Пробуем только lastPathComponent (работает если папка была как Group, и в бандл попало только имя файла)
        let last = ns.lastPathComponent as NSString
        let lastExt = last.pathExtension.isEmpty ? nil : last.pathExtension
        let lastName = last.deletingPathExtension

        if let lastExt, let url = bundle.url(forResource: lastName, withExtension: lastExt) {
            return url
        }

        throw ServiceError.fileNotFound(filename)
    }
}

extension JSONLoader {
    static func debugURL(_ filename: String, bundle: Bundle = .main) throws -> URL {
        try findResourceURL(filename, bundle: bundle)
    }

    static func decode<T: Decodable>(_ data: Data, as type: T.Type) throws -> T {
        let decoder = JSONDecoder.trainDay()
        return try decoder.decode(T.self, from: data)
    }
}
