//
//  WorkoutDetailsViewModel.swift
//  WorkoutCalendar
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import SwiftUI
import Combine

@MainActor
final class WorkoutDetailsViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var errorText: String?

    @Published private(set) var metadata: WorkoutMetadata?
    @Published private(set) var diagramPoints: [DiagramPoint] = []

    private let api: WorkoutAPI
    private let workoutId: String
    private let email: String

    init(api: WorkoutAPI, workoutId: String, email: String = "test@gmail.com") {
        self.api = api
        self.workoutId = workoutId
        self.email = email
    }

    func load() async {
        isLoading = true
        errorText = nil
        defer { isLoading = false }

        do {
            let meta = try await api.fetchMetadata(email: email, workoutId: workoutId)
            self.metadata = meta

            // Bonus - диаграмма (может отсутствовать)
            do {
                let points = try await api.fetchDiagram(email: email, workoutId: workoutId)
                self.diagramPoints = points.sorted(by: { $0.timeNumeric < $1.timeNumeric })
            } catch {
                self.diagramPoints = []
            }
        } catch {
            errorText = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }

    // MARK: - Formatting helpers

    var title: String {
        metadata?.workoutActivityType.title ?? "Workout"
    }

    var symbolName: String {
        metadata?.workoutActivityType.sfSymbolName ?? "figure.run"
    }

    var tint: Color {
        metadata?.workoutActivityType.tint ?? .orange
    }

    var dateTimeText: String {
        guard let date = metadata?.workoutStartDate else { return "-" }
        let f = DateFormatter()
        f.locale = Locale.current
        f.dateFormat = "dd MMM yyyy - HH:mm"
        return f.string(from: date)
    }

    var distanceText: String {
        guard let value = metadata?.distance else { return "-" }

        // По данным чаще всего метры. Конвертим в км красиво.
        let km = value / 1000.0
        let f = NumberFormatter()
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 0
        let s = f.string(from: NSNumber(value: km)) ?? String(format: "%.2f", km)
        return "\(s) km"
    }

    var durationText: String {
        guard let seconds = metadata?.duration else { return "-" }
        return Self.formatDuration(seconds: seconds)
    }

    var commentText: String? {
        let text = metadata?.comment?.trimmingCharacters(in: .whitespacesAndNewlines)
        return (text?.isEmpty == false) ? text : nil
    }

    static func formatDuration(seconds: Double) -> String {
        let total = max(0, Int(seconds.rounded()))
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60

        if h > 0 {
            return String(format: "%d:%02d:%02d", h, m, s)
        } else {
            return String(format: "%d:%02d", m, s)
        }
    }
}
